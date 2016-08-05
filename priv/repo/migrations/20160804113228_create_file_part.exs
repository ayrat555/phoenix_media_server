defmodule MediaServer.Repo.Migrations.CreateFile.Part do
  use Ecto.Migration

  def change do
    create table(:file_parts, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :number, :integer
      add :etag, :string
      add :upload_id, :string
      add :file_uuid, references(:files, type: :uuid, column: :uuid, on_delete: :delete_all)

      timestamps()
    end
    create index(:file_parts, [:file_uuid])

  end
end
