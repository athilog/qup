defmodule Demo.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :product, :string
      add :price, :string
      add :buyer, :string
      add :seller, :string
      add :where, :string

      add :buyer_id, references(:users)
      add :seller_id, references(:users)

      timestamps()
    end
    # create(unique_index(:transactions, :buyer_id, :seller_id))
  end
end
