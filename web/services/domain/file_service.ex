defmodule MediaServer.Domain.FileService do
  import Ecto

  alias MediaServer.File
  alias MediaServer.Repo

  def create_file_with_parts(params) do
    changeset = File.changeset(%File{}, params)
    if changeset.valid? do
      {:ok, result} = Repo.transaction(fn ->
                                         insert_file_and_parts(changeset)
                                       end)
      result
    else
      changeset
    end
  end

    defp insert_file_and_parts(file_changeset) do
      max_part_number = parts_number(file_changeset.changes.size)
      file = Repo.insert!(file_changeset)
      file
      |> create_parts(1, max_part_number)
      |> Enum.each(&Repo.insert!(&1))
      file
    end

    defp create_parts(changeset, part_number, max_part_number, parts \\ [])

    defp create_parts(changeset, part_number, max_part_number, parts) when part_number < max_part_number  do
      new_part = build_assoc(changeset, :parts, number: part_number)
      create_parts(changeset, part_number + 1, max_part_number, [new_part | parts])
    end

    defp create_parts(changeset, part_number, max_part_number, parts) when part_number == max_part_number do
      new_part = build_assoc(changeset, :parts, number: part_number)
      [new_part | parts]
    end

    defp parts_number(size) do
      part_size = part_size(size)
      extra_part = if rem(size, part_size) > 0 , do: 1, else: 0
      div(size, part_size) + extra_part
    end

    defp part_size(size) do
      max_parts_number = Application.fetch_env!(:media_server, :max_parts_number)
      min_part_size = Application.fetch_env!(:media_server, :part_size)
      size
      |> Kernel./(max_parts_number)
      |> Float.ceil()
      |> max(min_part_size)
      |> round()
    end
end
