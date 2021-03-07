defmodule MagnemiteWeb.Helpers.AccountStatusMessageTranslator do
  @moduledoc false

  alias MagnemiteWeb.Helpers.AccountStatusMessages

  @doc """
  Renders a different message about an account opening depending on a status.
  """
  def translate_account_status_to_message(:pending) do
    AccountStatusMessages.pending_account_message()
  end

  def translate_account_status_to_message(:complete) do
    AccountStatusMessages.complete_account_message()
  end
end
