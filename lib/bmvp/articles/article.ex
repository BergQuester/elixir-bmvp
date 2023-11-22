defmodule Bmvp.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "articles" do
    field :content, :string
    field :title, :string
    field :author_id, :binary_id
    field(:price, Money.Ecto.Composite.Type,
      default_currency: :EUR,
      default: Money.new(:EUR, "1.50")
    )

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:author_id, :title, :content, :price])
    |> validate_required([:title, :content, :price, :author_id])
  end
end
