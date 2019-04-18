defmodule PhoenixCrawlerWeb.PageController do
  use PhoenixCrawlerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
