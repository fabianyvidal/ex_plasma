defmodule ExPlasma.Transactions.Deposit do
  @moduledoc """
  A Deposit `Transaction` type. We use this to send money into the contract
  to be used. This is really just a Payment Transaction with no inputs
  """

  alias ExPlasma.Transaction
  alias ExPlasma.Transaction.Utxo

  @behaviour Transaction

  # A Deposit Transaction is really a Payment Transaction according
  # to the contracts. Therefor, the markers here are the same.
  @transaction_type 1
  @output_type 1

  # A Deposit transaction can only have 0 inputs and 1 output.
  @max_input_count 0
  @max_output_count 1

  @type t :: %__MODULE__{
          sigs: list(String.t()),
          inputs: list(Utxo.t()),
          outputs: list(Utxo.t()),
          metadata: binary()
        }

  defstruct(sigs: [], inputs: [], outputs: [], metadata: nil)

  @doc """
  The associated value for the output type. It's a hard coded
  value you can find on the contracts
  """
  @spec output_type() :: non_neg_integer()
  def output_type(), do: @output_type

  @doc """
  The associated value for the transaction type. It's a hard coded
  value you can find on the contracts
  """
  @spec transaction_type() :: non_neg_integer()
  def transaction_type(), do: @transaction_type

  @doc """
  Generate a new Deposit transaction struct which should:
    * have 0 inputs
    * have 1 output, containing the owner, currency, and amount

  ## Examples

  # Generate with a single output Utxo
  iex> alias ExPlasma.Transaction.Utxo
  iex> alias ExPlasma.Transactions.Deposit
  iex> address = "0x1dF62f291b2E969fB0849d99D9Ce41e2F137006e"
  iex> currency = "0x2e262d291c2E969fB0849d99D9Ce41e2F137006e"
  iex> Deposit.new(%Utxo{owner: address, currency: currency, amount: 1})
  %ExPlasma.Transactions.Deposit{
    inputs: [],
    sigs: [],
    metadata: nil,
    outputs: [%ExPlasma.Transaction.Utxo{
      amount: 1,
      blknum: 0,
      currency: "0x2e262d291c2E969fB0849d99D9Ce41e2F137006e",
      oindex: 0,
      owner: "0x1dF62f291b2E969fB0849d99D9Ce41e2F137006e",
      txindex: 0}]
  }

  # Generate the whole structure
  iex> alias ExPlasma.Transaction.Utxo
  iex> alias ExPlasma.Transactions.Deposit
  iex> address = "0x1dF62f291b2E969fB0849d99D9Ce41e2F137006e"
  iex> currency = "0x2e262d291c2E969fB0849d99D9Ce41e2F137006e"
  iex> utxo = %Utxo{owner: address, currency: currency, amount: 1}
  iex> Deposit.new(%{inputs: [], outputs: [utxo]})
  %ExPlasma.Transactions.Deposit{
    inputs: [],
    sigs: [],
    metadata: nil,
    outputs: [%ExPlasma.Transaction.Utxo{
      amount: 1,
      blknum: 0,
      currency: "0x2e262d291c2E969fB0849d99D9Ce41e2F137006e",
      oindex: 0,
      owner: "0x1dF62f291b2E969fB0849d99D9Ce41e2F137006e",
      txindex: 0}]
  }
  """
  @spec new(Utxo.t()) :: __MODULE__.t()
  def new(%Utxo{} = utxo) do
    Transaction.new(%__MODULE__{inputs: [], outputs: [utxo]})
  end

  @spec new(map()) :: __MODULE__.t()
  def new(%{inputs: inputs, outputs: outputs} = deposit)
      when is_list(inputs) and length(inputs) <= @max_input_count and
             is_list(outputs) and length(outputs) <= @max_output_count do
    Transaction.new(struct(__MODULE__, deposit))
  end
end
