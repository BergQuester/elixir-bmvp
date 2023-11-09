defmodule BmvpWeb.OverviewLive do
  use BmvpWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>hello overview</div>
    """
  end

  def mount(%{"username" => username}, _session, socket) do
    IO.inspect(username)
    {:ok, socket}
  end
end
