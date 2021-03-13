defmodule MagnemiteWeb.Api.V1.AccountView do
  @moduledoc false

  use MagnemiteWeb, :view

  import MagnemiteWeb.Helpers.AccountStatusMessageTranslator

  def render("opening_request.json", %{account: account}) do
    account
    |> Map.take([:referral_code, :status])
    |> Map.merge(%{
      message: translate_account_status_to_message(account.status)
    })
  end

  def render("referred.json", %{accounts: accounts}) do
    %{
      accounts: render_many(accounts, __MODULE__, "referred.json")
    }
  end

  def render("referred.json", %{account: account}) do
    account
    |> Map.take([:id])
    |> Map.merge(%{
      name: account.name
    })
  end
end
