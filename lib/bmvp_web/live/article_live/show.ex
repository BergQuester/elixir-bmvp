defmodule BmvpWeb.ArticleLive.Show do
  use BmvpWeb, :live_view

  alias Bmvp.Articles

  @store_id "51857"
  @variant_id "123"

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

  @impl true
  def handle_event("purchase", _params, socket) do
    article = socket.assigns.article
    price = get_price_in_cents(article)

    data = %{
      custom_price: price,
      product_options: %{
        name: "Article on CashBlog.app",
        description: article.title
      },
      checkout_data: %{
        custom: %{
          article_id: article.id
        }
      }
    }

    {:ok, checkout} = LemonEx.Checkouts.create(@store_id, @variant_id, data)

    {:noreply, redirect(socket, external: checkout.url)}
  end

  defp get_price_in_cents(article) do
    {:EUR, custom_price, -2, _rest} = Money.to_integer_exp(article.price)
    custom_price
  end

  def is_author?(nil, _), do: false

  def is_author?(current_user, article) do
    current_user.id == article.author_id
  end

  defp page_title(:show), do: "Show Article"
  defp page_title(:edit), do: "Edit Article"
end
