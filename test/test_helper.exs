ExUnit.start()
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(Magnemite.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
