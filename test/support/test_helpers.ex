defmodule MediaServer.TestHelpers do
  alias MediaServer.File
  alias MediaServer.Repo

  def create_file(attrs \\ %{mime_type: "video/mp4", size: 1024*1024*10}) do
    changeset = File.changeset(%File{}, attrs)
    Repo.insert(changeset)
  end

  def min_part_size() do
    Application.fetch_env!(:media_server, :part_size)
  end
end
