defmodule BmvpWeb.PageController do
  use BmvpWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home)
  end

  def checkout_success(conn, _params) do
    render(conn, :checkout_success)
  end
end
