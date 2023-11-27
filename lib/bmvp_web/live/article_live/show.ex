defmodule BmvpWeb.ArticleLive.Show do
  use BmvpWeb, :live_view

  alias Bmvp.Articles

  on_mount({BmvpWeb.UserAuth, :mount_current_user})

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:article, Articles.get_article!(id))}
  end

  def is_author?(nil, _), do: false

  def is_author?(current_user, article) do
    current_user.id == article.author_id
  end

  defp page_title(:show), do: "Show Article"
  defp page_title(:edit), do: "Edit Article"
end
