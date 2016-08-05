defmodule MediaServer.FileRepoTest do
  use MediaServer.ModelCase
  alias MediaServer.File
  alias MediaServer.Repo

  @valid_attrs %{name: "best file", mime_type: "video/mp4", size: 600}

  test "sets uuid on file creation" do
    {:ok, changeset} = create_file(@valid_attrs)
    assert changeset.uuid
  end

  test "sets extension on file creation" do
    {:ok, _} = create_file(@valid_attrs)
    assert Repo.get_by!(File, @valid_attrs).extension == "mp4"
  end
end
