defmodule Skuldaring.Repo do
  use Ecto.Repo,
    otp_app: :skuldaring,
    adapter: Ecto.Adapters.Postgres
end
