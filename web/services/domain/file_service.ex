defmodule MediaServer.Domain.FileService do
  import Ecto
  import MediaServer.ServiceHelpers

  alias MediaServer.File
  alias MediaServer.Repo

  def create_file_with_parts(params) do
    changeset = File.changeset(%File{}, params)
    if changeset.valid? do
      {:ok, file} = insert_file_and_parts(changeset)
      file
    else
      changeset
    end
  end

    defp insert_file_and_parts(file_changeset) do
      max_part_number = parts_number(file_changeset.changes.size)
      sync_part_number = env_var(:sync_part_number)
      file = Repo.insert!(file_changeset)
      Repo.transaction(fn ->
        part_number_limit = if max_part_number > sync_part_number do
          create_last_parts_async(file, max_part_number)
          sync_part_number
        else
          max_part_number
        end
        file
        |> create_parts(1, part_number_limit)
        |> Enum.each(&Repo.insert!(&1))
        file
      end)
    end

    defp create_parts(changeset, min_part_number, max_part_number, parts \\ [])

    defp create_parts(changeset, min_part_number, max_part_number,  parts) when max_part_number > min_part_number  do
      new_part = build_assoc(changeset, :parts, number: max_part_number)
      create_parts(changeset, min_part_number, max_part_number - 1, [new_part | parts])
    end

    defp create_parts(changeset, min_part_number, max_part_number,  parts) when max_part_number == min_part_number do
      new_part = build_assoc(changeset, :parts, number: max_part_number)
      [new_part | parts]
    end

    defp parts_number(size) do
      part_size = part_size(size)
      extra_part = if rem(size, part_size) > 0 , do: 1, else: 0
      div(size, part_size) + extra_part
    end

    defp part_size(size) do
      max_parts_number = env_var(:max_parts_number)
      min_part_size = env_var(:part_size)
      size
      |> Kernel./(max_parts_number)
      |> Float.ceil()
      |> max(min_part_size)
      |> round()
    end

    defp create_last_parts_async(file, max_part_number) do
      Task.start_link(fn ->
        Repo.transaction(fn ->
          sync_part_number = env_var(:sync_part_number)
          file
          |> create_parts(sync_part_number + 1, max_part_number)
          |> Enum.each(&Repo.insert!(&1))
        end)
      end)
    end
end
