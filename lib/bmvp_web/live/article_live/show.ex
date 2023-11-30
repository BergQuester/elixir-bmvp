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
  def handle_params(%{"id" => id} = params, _, socket) do
    article = Articles.get_article!(id)
    current_user = socket.assigns.current_user
    show_full_article = is_author_or_has_valid_token?(current_user, params, article)
    {:noreply,
     socket
     |> assign(:show_full_article, show_full_article)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:article, article)}
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

  def is_author_or_has_valid_token?(current_user, params, article) do
    is_author?(current_user, article) || has_valid_token?(params, article)
  end

  defp is_author?(nil, _), do: false

  defp is_author?(current_user, article) do
    current_user.id == article.author_id
  end

  defp has_valid_token?(%{"token" => token} = _params, article) do
    case Bmvp.UrlHelper.verify_unique_article_token(token) do
      {:ok, article_id} -> article_id == article.id
      _error -> false
    end
  end

  defp has_valid_token?(_params, _article), do: false


  defp page_title(:show), do: "Show Article"
  defp page_title(:edit), do: "Edit Article"
end
