defmodule Mix.Tasks.InstagramParse do
  def to_json(body) do
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
    %{
      :user => %{
        :instagram_id => json["owner"]["id"],
        :username =>  json["owner"]["username"],
        :full_name => json["owner"]["full_name"],
        :profile_picture => json["owner"]["profile_picture"]
      },
      :link => "https://www.instagram.com/p/#{json["shortcode"]}/"
    }
  end
end
