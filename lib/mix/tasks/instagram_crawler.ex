require IEx
defmodule Mix.Tasks.InstagramCrawler do
  use Mix.Task
  use Retry
  def run(_) do
    HTTPotion.start
    url = "https://www.instagram.com/p/BqkWY27BPAY/"

    result = retry with: constant_backoff(5000) |> Stream.take(10), rescue_only: [TooManyError] do
      Mix.Tasks.InstagramFetch.fetch(url)
    after
      result -> result
    else
      error -> error
    end
    if result.body do
      json = Mix.Tasks.InstagramParse.to_json(body)
    else
      json = {}
    end
    # IEx.pry
  end
end
