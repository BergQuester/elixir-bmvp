defmodule Bmvp.Repo do
  use Ecto.Repo,
    otp_app: :bmvp,
    adapter: Ecto.Adapters.Postgres
end
