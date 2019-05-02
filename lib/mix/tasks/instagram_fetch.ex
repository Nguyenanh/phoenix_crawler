defmodule TooManyRequestError do
  defexception message: "Retry"
end

defmodule Mix.Tasks.InstagramFetch do
  def fetch(instagram_url) do
    %{:body => body, :status_code => status_code} = URI.decode(instagram_url) |> HTTPotion.get!
    IO.inspect "GET #{instagram_url} --- #{status_code}"
    if http_code?(status_code) do
      %{:body => body}
    else
      %{:body => nil}
    end
  end

  defp http_code?(status_code) when status_code == 200 do
    true
  end

  defp http_code?(status_code) when status_code == 429 do
    raise TooManyRequestError
  end

  defp http_code?(_) do
    false
  end
end
