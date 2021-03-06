defmodule Demo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Demo.Trade.Transaction

  @required_fields [:name, :email, :email, :phone_number]

  schema "users" do
    # add user_type
    field :type, :string
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :password_confirmation, :string, virtual: true
    field :balance, :integer

    timestamps()

    many_to_many(
      :transactions,
      Transaction,
      join_through: "user_transaction",
      on_replace: :delete
    )
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 2, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:type, :name, :email, :balance])
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
  end
  # @phone ~r/^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$/

  # @doc false
  # def changeset(user, attrs) do
  #   user
  #   |> cast(attrs, [:email, :email, :phone_number, :password])
    # |> validate_required([:email, :email, :phone_number])
    # |> validate_confirmation(:password)
    # |> validate_format(:email, ~r/^[a-zA-Z0-9_]*$/,
    #   message: "only letters, numbers, and underscores please"
    # )
    # |> validate_length(:email, max: 12)
    # |> validate_format(:email, ~r/.+@.+/, message: "must be a valid email address")
    # |> validate_format(:phone_number, @phone, message: "must be a valid number")
    # |> unique_constraint(:email)
  # end


  def changeset_update_transactions(user, transactions) do
    user
    |> cast(%{}, @required_fields)
    # associate transactions to the user
    |> put_assoc(:transactions, transactions)
  end

end
