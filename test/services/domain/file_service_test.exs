defmodule MediaServer.Domain.FileServiceTest do
  use MediaServer.ServiceCase

  alias MediaServer.Domain.FileService
  alias MediaServer.Repo
  alias MediaServer.File

  @attrs %{name: "best file", mime_type: "video/mp4"}

  test "creates file and parts with valid attrs" do
    part_count = :rand.uniform(20) + 1
    size = part_count * min_part_size()
    attrs = Map.put(@attrs, :size, size)

    file = FileService.create_file_with_parts(attrs)
    file_with_parts =
    Repo.get_by(File, uuid: file.uuid)
    |> Repo.preload(:parts)
    assert Enum.count(file_with_parts.parts) == part_count
  end

  test "creates all parts when part number is large" do
    part_count = 200
    size = part_count * min_part_size()
    attrs = Map.put(@attrs, :size, size)

    file = FileService.create_file_with_parts(attrs)
    file_with_parts =
    Repo.get_by(File, uuid: file.uuid)
    |> Repo.preload(:parts)

    assert Enum.count(file_with_parts.parts) == part_count

    part_numbers =
      file_with_parts.parts
      |> Enum.map(fn(part)->
                      part.number
                  end)
    Range.new(1, part_count)
    |> Enum.each(fn(num) ->
                   assert num == Enum.find(part_numbers, fn(x) -> x == num end)
                 end)

  end

  test "returns changeset if attr are invalid" do
    file = FileService.create_file_with_parts(@attrs)
    refute file.valid?
  end
end
