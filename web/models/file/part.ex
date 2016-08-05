defmodule MediaServer.File.Part do
  use MediaServer.Web, :model

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :uuid}
  schema "file_parts" do
    field :number, :integer
    field :etag, :string
    field :upload_id, :string
    belongs_to :file, MediaServer.File, type: :binary_id, foreign_key: :file_uuid

    timestamps()
  end

  @required_fields ~w(number file_uuid)
  @optional_fields ~w()
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required([:number])
    |> assoc_constraint(:file)
  end
end
