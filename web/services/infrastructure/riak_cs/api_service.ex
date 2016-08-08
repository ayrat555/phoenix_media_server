defmodule MediaServer.Infrastructure.RiakCs.ApiService do
  import MediaServer.Infrastructure.RiakCs.Params
  alias MediaServer.Infrastructure.RiakCs.HttpClient

  def initiate_multipart_upload(bucket, key, content_type) do
    path = "/#{bucket}/#{key}?uploads"
    headers = %{"Content-Type" => content_type,
                "x-amz-acl" => acl}
    HttpClient.post_request(path, %{}, headers)
  end
end
