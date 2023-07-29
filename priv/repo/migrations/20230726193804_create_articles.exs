defmodule Bmvp.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :text
      add :content, :text
      add :author_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:articles, [:author_id])
  end
end
