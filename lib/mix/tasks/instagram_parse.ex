defmodule Mix.Tasks.InstagramParse do
  def to_json(body) do
    IO.inspect(body)
    body
      |> Floki.find("body script")
      |> hd
      |> elem(2)
      |> hd
      |> String.split("window._sharedData = ")
      |> List.last
      |> String.slice(0..-2)
      |> Poison.decode!
      |> Map.fetch!("entry_data")
      |> Map.fetch!("PostPage")
      |> hd
      |> Map.fetch!("graphql")
      |> Map.fetch!("shortcode_media")
  end

  def to_post(json) do
    caption = json["edge_media_to_caption"]["edges"] |> hd |> Map.fetch!("node")
    owner   = json["owner"]
    %{
      user: %{
        instagram_id: owner["id"],
        username:  owner["username"],
        full_name: owner["full_name"],
        profile_picture: owner["profile_pic_url"]
      },
      link: "https://www.instagram.com/p/#{json["shortcode"]}/",
      caption: %{
        id: json["id"],
        text: caption["text"],
        created_time: json["taken_at_timestamp"],
        from: %{
          id: owner["id"],
          username: owner["username"],
          full_name: owner["full_name"],
          profile_picture: owner["profile_pic_url"]
        }
      },
      tags: Regex.scan(~r/\B#[^\s#.]+/, caption["text"]) |> Enum.concat,
      likes: %{
        count: json["edge_media_preview_like"]["count"]
      },
      location: %{
        id: json["location"]["id"],
        name: json["location"]["name"],
        slug: json["location"]["slug"]
      },
      media_id: "#{json["id"]}_#{owner["id"]}",
      created_time: json["taken_at_timestamp"] |> DateTime.from_unix |> elem(1) |> DateTime.add(32400, :second),
      comments: %{
        count: json["edge_media_to_comment"]["count"]
      },
      media_type: json |> post_media_type,
      images: json |> post_images,
      videos: nil,
      carousel_media: json["edge_sidecar_to_children"] |> carousel_media
    }
  end

  defp carousel_media(children) when is_map(children) do
    children["edges"] |> Enum.map(fn(x) -> post_images(x["node"]) end)
  end

  defp carousel_media(_), do: []

  defp post_media_type(json) do
    case json["__typename"] do
      'GraphSidecar' -> 'carousel'
      'GraphImage'   -> 'image'
      _              -> 'video'
    end
  end

  defp post_images(json) do
    display_resources = json["display_resources"]
    %{
      images: %{
        thumbnail: %{
          width: display_resources |> Enum.at(0) |> Map.fetch!("config_width"),
          height: display_resources |> Enum.at(0) |> Map.fetch!("config_height"),
          url: display_resources |> Enum.at(0) |> Map.fetch!("src")
        },
        low_resolution: %{
          width: display_resources |> Enum.at(1) |> Map.fetch!("config_width"),
          height: display_resources |> Enum.at(1) |> Map.fetch!("config_height"),
          url: display_resources |> Enum.at(1) |> Map.fetch!("src")
        },
        standard_resolution: %{
          width: display_resources |> Enum.at(2) |> Map.fetch!("config_width"),
          height: display_resources |> Enum.at(2) |> Map.fetch!("config_height"),
          url: display_resources |> Enum.at(2) |> Map.fetch!("src")
        }
      },
      type: json |> post_media_type,
      users_in_photo: json["edge_media_to_tagged_user"]["edges"]
    }
  end
end
