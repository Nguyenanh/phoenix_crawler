defmodule Mix.Tasks.PhantomjsDriver do
  use Hound.Helpers

  def start() do
    try do
      Hound.start_session
      navigate_to("https://www.instagram.com/explore/tags/github/")
      all_posts = find_all_elements(:xpath, ~s|/html/body/span/section/main/article/div/div/div/div/div/a|)
        |> Enum.map(fn(x) -> x |> attribute_value("href") end)
      IO.inspect all_posts
      Hound.end_session
    rescue
      e in RuntimeError -> IO.inspect e
      Hound.end_session
    end
  end
end
