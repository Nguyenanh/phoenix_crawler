defmodule Mix.Tasks.InstagramCrawler do
  use Mix.Task
  use Retry

  def run(_) do
    HTTPotion.start
    urls()
      |> Enum.map(&(Task.async(fn -> get_data(&1) end)))
      |> Enum.map(&Task.await/1)
  end

  defp get_data(url) do
    result = retry with: constant_backoff(10000) |> Stream.take(5), rescue_only: [TooManyRequestError] do
      url |> Mix.Tasks.InstagramFetch.fetch
    after
      result -> result
    else
      error -> error
    end
    post =
      if result.body do
        result.body
          |> Mix.Tasks.InstagramParse.to_json
          |> Mix.Tasks.InstagramParse.to_post
      else
        nil
      end
      post |> IO.inspect
  end

  def urls do
   ["https://www.instagram.com/p/BcZW_hNjCQV/",
    "https://www.instagram.com/p/BcYOCcOj7X_/",
    "https://www.instagram.com/p/BcWwqIpjxd4/",
    "https://www.instagram.com/p/BcVo7QND8gT/",
    "https://www.instagram.com/p/BcUZhkvDKpW/",
    "https://www.instagram.com/p/BcTDDGfjkIl/",
    "https://www.instagram.com/p/BcRnDd1jvGC/",
    "https://www.instagram.com/p/BcOMyDDjf-a/",
    "https://www.instagram.com/p/BcNLVMQlcht/",
    "https://www.instagram.com/p/BcKKR6ugIOc/",
    "https://www.instagram.com/p/BcKCZ3YBs_U/",
    "https://www.instagram.com/p/BcJ8FCwDEiF/",
    "https://www.instagram.com/p/BcHHbp5jTub/",
    "https://www.instagram.com/p/BcGOYxxFF0m/",
    "https://www.instagram.com/p/BcFCmeCDHS_/",
    "https://www.instagram.com/p/BcEdhKEjx02/",
    "https://www.instagram.com/p/BcD_W81jzdX/",
    "https://www.instagram.com/p/BcBRvhGF1UR/",
    "https://www.instagram.com/p/BcBJL8UDPX9/",
    "https://www.instagram.com/p/Bb9eA6EgDnK/",
    "https://www.instagram.com/p/Bb9KWx1FqXm/",
    "https://www.instagram.com/p/Bb36zCUj6sF/",
    "https://www.instagram.com/p/Bb36m2QjF1H/",
    "https://www.instagram.com/p/Bb35g-HDkTc/",
    "https://www.instagram.com/p/Bb1QiXOBy6_/",
    "https://www.instagram.com/p/Bb09CzhHxNi/",
    "https://www.instagram.com/p/Bb0rfx2lA38/",
    "https://www.instagram.com/p/Bb0mJURlLKR/",
    "https://www.instagram.com/p/Bb0ihjVDml-/",
    "https://www.instagram.com/p/Bb0iZ1zDWF5/",
    "https://www.instagram.com/p/Bb0gPVJDWDr/",
    "https://www.instagram.com/p/Bb0bgr2j1EI/",
    "https://www.instagram.com/p/Bb0ao8DjXaz/",
    "https://www.instagram.com/p/Bb0aaJij-vu/",
    "https://www.instagram.com/p/BbzNAgggCdq/",
    "https://www.instagram.com/p/BbzK7ZylbwH/",
    "https://www.instagram.com/p/BbzAzt3HdFa/",
    "https://www.instagram.com/p/Bby3Fb3gqpB/",
    "https://www.instagram.com/p/Bbyy4poBGif/",
    "https://www.instagram.com/p/BbyqUntDLLE/",
    "https://www.instagram.com/p/BbynwKNgjJ0/",
    "https://www.instagram.com/p/BbynZYSH8SG/",
    "https://www.instagram.com/p/BbynJlIAInx/",
    "https://www.instagram.com/p/BbylMOplbhy/",
    "https://www.instagram.com/p/BbyeiKhgLw-/",
    "https://www.instagram.com/p/BbydlJsFxDi/",
    "https://www.instagram.com/p/BbyOe27Hcuv/",
    "https://www.instagram.com/p/BbyA56OgGGw/",
    "https://www.instagram.com/p/BbxnuiylHNx/",
    "https://www.instagram.com/p/BbwtP4iDaxB/"]
  end
end
