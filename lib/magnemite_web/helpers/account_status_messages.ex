defmodule MagnemiteWeb.Helpers.AccountStatusMessages do
  @moduledoc false

  def pending_account_message do
    "Please, send us your missing information to open an account."
  end

  def complete_account_message do
    "Your Magnemite account has been successfully opened!"
  end
end
