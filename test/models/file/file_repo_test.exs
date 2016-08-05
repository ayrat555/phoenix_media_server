defmodule MediaServer.File.PartRepoTest do
  use MediaServer.ModelCase

  alias MediaServer.File.Part
  alias MediaServer.Repo

  @invalid_attrs %{number: 42, file_uuid: "4edbfdf9-9517-4902-8e92-2212215b0de5"}

  test "part with existing file" do
    {:ok, file} = create_file()
    changeset = Part.changeset(%Part{}, %{number: 1, file_uuid: file.uuid})
    assert changeset.valid?
  end


  test "part with not existing file_uuid attribute" do
    changeset = Part.changeset(%Part{}, @invalid_attrs)
    {:error, changeset} = Repo.insert(changeset)
    assert {:file, {"does not exist", []}}
         in changeset.errors
  end
end
