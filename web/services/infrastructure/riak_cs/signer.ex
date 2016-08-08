defmodule MediaServer.Infrastructure.RiakCs.Signer do
  import MediaServer.Infrastructure.RiakCs.Params

  def signature_params(path, request_type, headers \\ %{}) do
    exp_date = expiration_date()
    %{
      AWSAccessKeyId: key_id,
      Expires: exp_date,
      Signature: signature(request_type, exp_date, path, headers)
      }
  end

    defp expiration_date do
      Timex.now
      |> Timex.shift(days: expiration_days)
      |> Timex.to_unix()
    end

    defp signature(request_type, exp_date, path, headers) do
      string_to_sign = string_to_sign(request_type, exp_date, path, headers)
      :crypto.hmac(:sha, secret_key, string_to_sign)
      |> Base.encode64
    end

    defp string_to_sign(request_type, exp_date, path, headers) do
      content_type = Map.get(headers, "Content-Type")
      headers = Map.delete(headers, "Content-Type")
      string_to_sign = ""
      string_to_sign = string_to_sign <> request_type <> "\n\n"
      string_to_sign = if content_type, do: string_to_sign <> content_type <> "\n", else: string_to_sign
      string_to_sign = string_to_sign <> Integer.to_string(exp_date) <> "\n"
      string_to_sign = Enum.reduce(headers, string_to_sign, fn(header, string_to_sign) ->
                                                              {key, value} = header
                                                              string_to_sign <> "#{key}:" <> value <> "\n"
                                                            end)
      string_to_sign <> path
    end
end
