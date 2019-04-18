defmodule PhoenixCrawler.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_crawler,
    adapter: Ecto.Adapters.Postgres
end
