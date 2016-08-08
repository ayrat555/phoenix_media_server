defmodule MediaServer.Infrastructure.RiakCs.Params do
  import MediaServer.ServiceHelpers

  def expiration_days do
    riak_cs_config[:exp_days]
  end

  def secret_key do
    riak_cs_config[:secret_key]
  end

  def key_id do
    riak_cs_config[:key_id]
  end

  def base_url do
    riak_cs_config[:schema] <> "://" <> riak_cs_config[:host]
  end

  def acl do
    riak_cs_config[:acl]
  end

    defp riak_cs_config do
      env_var(:riak_cs)
    end
end
