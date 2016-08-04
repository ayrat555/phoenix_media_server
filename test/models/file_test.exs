defmodule MediaServer.FileTest do
  use MediaServer.ModelCase, async: true

  alias MediaServer.File

  @valid_attrs %{mime_type: "audio/ogg", name: "some content", size: 42}

  test "changeset with valid attributes" do
    changeset = File.changeset(%File{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with empty size and mime_type" do
    invalid_attrs = Map.drop(@valid_attrs, [:mime_type, :size])
    changeset = File.changeset(%File{}, invalid_attrs)
    assert {:mime_type, {"can't be blank", []}}
         in changeset.errors
    assert {:size, {"can't be blank", []}}
            in changeset.errors
    refute changeset.valid?
  end

  test "changeset with invalid mime type" do
    invalid_attrs = Map.put(@valid_attrs, :mime_type, "what/what")
    changeset = File.changeset(%File{}, invalid_attrs)
    assert {:mime_type, {"mime type is unknown", []}}
         in changeset.errors
    refute changeset.valid?
  end
end
