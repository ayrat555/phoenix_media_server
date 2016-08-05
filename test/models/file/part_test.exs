defmodule MediaServer.File.PartTest do
  use MediaServer.ModelCase

  alias MediaServer.File.Part

  @valid_attrs %{number: 42, file_uuid: "this-uuid-is-valid"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Part.changeset(%Part{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Part.changeset(%Part{}, @invalid_attrs)
    refute changeset.valid?
    assert {:number, {"can't be blank", []}}
         in changeset.errors
    assert {:file_uuid, {"can't be blank", []}}
         in changeset.errors
    refute changeset.valid?
  end

  # test "changeset with not existing file_uuid attribute" do
  #   attrs = Map.put(@valid_attrs, :file_uuid, "this-uuid-is-valid")
  #   changeset = Part.changeset(%Part{}, attrs)
  #   IO.inspect changeset
  #   refute changeset.valid?
  # end
end
