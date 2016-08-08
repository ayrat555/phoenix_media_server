defmodule MediaServer.Infrastructure.RiakCs.SignerService do
  import MediaServer.ServiceHelpers

  def generate_signature_params(request_type, path, headers \\ %{}) do
    exp_date = expiration_date()
    %{
      AWSAccessKeyId: env_var(:riac_cs_key_id),
      Expires: exp_date,
      Signature: signature(request_type, exp_date, path, headers)
    }
  end

    defp expiration_date do
      Timex.now
      |> Timex.shift(days: env_var(:riac_cs_exp_days))
      |> Timex.to_unix()
    end

    defp signature(request_type, exp_date, path, headers) do
      string_to_sign = string_to_sign(request_type, exp_date, path, headers)
      :crypto.hmac(:sha, env_var(:riac_cs_secret_key), string_to_sign)
      |> Base.encode64
    end

    defp string_to_sign(request_type, exp_date, path, headers) do
      content_type = content_type(headers)
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

    defp content_type(headers) do
      case Map.fetch(headers, "Content-Type") do
        {:ok, value} -> value
        :error -> nil
      end
    end
end
