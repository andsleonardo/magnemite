defmodule Magnemite.Identity.Guardian do
  @moduledoc false

  use Guardian, otp_app: :magnemite

  alias Magnemite.Identity.{User, Users}

  def subject_for_token(%User{id: nil}, _claims) do
    {:error, :invalid_token_resource}
  end

  def subject_for_token(%User{id: user_id}, _claims) do
    {:ok, user_id}
  end

  def subject_for_token(_, _) do
    {:error, :invalid_token_resource}
  end

  def resource_from_claims(%{"sub" => user_id}) do
    Users.get(user_id)
  end

  def resource_from_claims(_claims) do
    {:error, :invalid_token_claims}
  end
end
