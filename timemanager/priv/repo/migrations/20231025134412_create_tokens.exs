defmodule Timemanager.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :token, :string
      add :user, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:tokens, [:user])
  end
end
