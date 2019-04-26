require IEx

defmodule TooManyError do
  defexception message: "Retry"
end

defmodule Mix.Tasks.InstagramFetch do

  def fetch(instagram_url) do
    IO.puts "GET " <> instagram_url
    %{:body => body, :status_code => status_code} = HTTPotion.get! instagram_url
    if http_code?(status_code) do
      %{:body => body}
    else
      %{:body => nil}
    end
  end

  defp http_code?(status_code) when status_code == 200 do
    true
  end

  defp http_code?(status_code) when status_code == 404 do
    false
  end

  defp http_code?(status_code) when status_code == 500 do
    http_code?(400)
  end

  defp http_code?(status_code) when status_code == 301 do
    http_code?(400)
  end

  defp http_code?(status_code) when status_code == 429 do
    raise TooManyError
  end
end
