defmodule MagnemiteWeb.Api.V1.AccountView do
  @moduledoc false

  use MagnemiteWeb, :view

  alias MagnemiteWeb.Api.V1.CustomerView

  import MagnemiteWeb.Helpers.AccountStatusMessageTranslator

  def render("show.json", %{account: account}) do
    %{
      customer: render_one(account.customer, CustomerView, "show.json"),
      message: translate_account_status_to_message(account.status),
      status: account.status
    }
  end
end
