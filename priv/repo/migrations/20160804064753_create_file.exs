defmodule MediaServer.Repo.Migrations.CreateFile do
  use Ecto.Migration

  def change do
    create table(:files, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add :mime_type, :string
      add :extension, :string
      add :size, :integer
      add :upload_id, :string
      add :key, :string
      add :processed, :boolean, default: false, null: false

      timestamps()
    end

  end
end
