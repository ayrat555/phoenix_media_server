defmodule MediaServer.File do
  use MediaServer.Web, :model

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :uuid}
  schema "files" do
    field :name, :string
    field :mime_type, :string
    field :extension, :string
    field :size, :integer
    field :upload_id, :string
    field :key, :string
    field :processed, :boolean, default: false

    timestamps()
  end

  @required_fields ~w(mime_type size)
  @optional_fields ~w(name)
  @doc """
  Builds a changeset based on the `model` and `params`.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required([:mime_type, :size])
    |> validate_length(:name, max: 50)
    |> validate_mime_type()
  end

    defp validate_mime_type(changeset) do
      case changeset do
        %Ecto.Changeset{valid?: true, changes: %{mime_type: mime_type}} ->
          if MIME.valid?(mime_type), do: put_change(changeset, :extension, extension(mime_type)),
                                     else: add_error(changeset, :mime_type, "mime type is unknown")
        _ ->
          changeset
      end
    end

   defp extension(mime_type) do
     mime_type
     |> MIME.extensions
     |> Enum.at(0)
   end
end
