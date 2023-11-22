defmodule Bmvp.Repo.Migrations.AddPriceToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :price, :money_with_currency
    end
  end
end
