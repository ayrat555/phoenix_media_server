defmodule MediaServer.Infrastructure.RiakCs.HttpClient do
  import MediaServer.Infrastructure.RiakCs.Params
  alias MediaServer.Infrastructure.RiakCs.Signer

  def post_request(path, params \\ %{}, headers \\ %{}, body \\ []) do
    path
    |> request_url("POST",  headers, params)
    |> HTTPoison.post(body, headers)
  end

    defp request_url(path, request_type, headers, params) do
      encoded_params =
        path
        |> Signer.signature_params(request_type, headers)
        |> Map.merge(params, fn(_k, v1, v2) -> v1 end)
        |> URI.encode_query()
      base_url <> path <> "&" <> encoded_params
    end
end
