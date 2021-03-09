defmodule Magnemite.Factories.UserFactory do
  @moduledoc false

  alias Magnemite.Identity

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        password = random_password()

        %Identity.User{
          username: Faker.Internet.user_name(),
          password: password,
          encrypted_password: encrypt_password(password),
          token: Ecto.UUID.generate()
        }
      end

      defp random_password do
        Nanoid.generate_non_secure(8, "abcde12345")
      end

      defp encrypt_password(password) do
        password
        |> Argon2.add_hash()
        |> Map.get(:password_hash)
      end
    end
  end
end
