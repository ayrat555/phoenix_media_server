defmodule MediaServer.Infrastructure.RiakCs.Params do
  import MediaServer.ServiceHelpers

  def expiration_days do
    env_var(:riac_cs_exp_days)
  end

  def secret_key do
    env_var(:riac_cs_secret_key)
  end

  def key_id do
    env_var(:riac_cs_key_id)
  end

  def base_url do
    env_var(:riak_cs_schema) <> "://" <> env_var(:riak_cs_host)
  end

  def acl do
    env_var(:riak_cs_acl)
  end
end
