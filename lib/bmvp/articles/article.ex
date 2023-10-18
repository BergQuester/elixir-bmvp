defmodule Bmvp.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "articles" do
    field :content, :string
    field :title, :string
    field :author_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:author_id, :title, :content])
    |> validate_required([:title, :content])
  end
end
