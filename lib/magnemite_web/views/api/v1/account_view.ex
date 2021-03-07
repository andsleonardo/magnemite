defmodule MagnemiteWeb.Api.V1.AccountView do
  @moduledoc false

  use MagnemiteWeb, :view

  import MagnemiteWeb.Helpers.AccountStatusMessageTranslator

  def render("show.json", %{account: account}) do
    %{
      message: translate_account_status_to_message(account.status),
      referral_code: account.referral_code,
      status: account.status
    }
  end
end
