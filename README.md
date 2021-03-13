# Magnemite

A Phoenix app that provides bank account opening functionality to the (fictional) Brazilian Bipolar Bank through a RESTful API.

## API docs

Magnemite's API documentation can be found [here on Postman](https://documenter.getpostman.com/view/8554720/Tz5qZwyn).

## Development

### Requirements

- [Elixir 1.11.3](https://elixir-lang.org/install.html)
- [Erlang 23.1.1](https://www.erlang.org/downloads)
- [Nodejs 13.8.0](https://nodejs.org/en/download/)
- [PostgreSQL 12.6](https://www.postgresql.org/download/)

### Running the server

1. Install dependencies with `mix deps.get`.
2. Create and migrate your database with `mix ecto.setup`.
3. Start the server with an attached console with `iex -S mix phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Environment variables

1. Copy `.env.sample` to `.env.development`.
2. Generate a secret key with `mix phx.gen.secret` and assign it to `GUARDIAN_SECRET_KEY`.
3. Run `iex`, generate an encryption key for [cloak_ecto](https://github.com/danielberkompas/cloak_ecto) with the command below and assign it to `CLOAK_SECRET_KEY`.

```elixir
32 |> :crypto.strong_rand_bytes() |> Base.encode64()
```
## Contributing

1. [Fork the repository](https://github.com/andsleonardo/magnemite/fork).
2. Create your feature branch with `git checkout -b feat-fooBar`.
3. Commit your changes with `git commit -am 'Add some fooBar'`.
4. Push your changes to the remote branch with `git push origin feat-fooBar`.
5. Create a new pull request.
