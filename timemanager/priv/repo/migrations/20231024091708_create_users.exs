defmodule Timemanager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstname, :string
      add :lastname, :string
      add :email, :string
      add :password, :string
      add :role, references(:roles, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:users, [:role])
  end
end
