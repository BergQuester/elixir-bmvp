defmodule BmvpWeb.OverviewLive do
  use BmvpWeb, :live_view

  alias Bmvp.Accounts
  alias Bmvp.Articles

  def render(assigns) do
    ~H"""
<div class="bg-white py-24 sm:py-32">
  <div class="mx-auto max-w-7xl px-6 lg:px-8">
    <div class="mx-auto max-w-2xl lg:mx-0">
      <h2 class="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">From the blog of <%= @author.username %></h2>
    </div>
    <div class="mx-auto mt-10 grid max-w-2xl grid-cols-1 gap-x-8 gap-y-16 border-t border-gray-200 pt-10 sm:mt-16 sm:pt-16 lg:mx-0 lg:max-w-none lg:grid-cols-3">
      <%= for article <- @articles do %>
        <article class="flex max-w-xl flex-col items-start justify-between">
        <div class="flex items-center gap-x-4 text-xs">
          <time datetime="2020-03-16" class="text-gray-500"><%= article.updated_at %></time>
        </div>
        <a href={~p"/articles/#{article.id}"}>
          <div class="group relative">
            <h3 class="mt-3 text-lg font-semibold leading-6 text-gray-900 group-hover:text-gray-600">
                <span class="absolute inset-0"></span>
                <%= article.title %>
            </h3>
            <p class="mt-5 line-clamp-3 text-sm leading-6 text-gray-600"><%= String.slice(article.content, 0, 200) %></p>
          </div>
        </a>
        </article>
      <% end %>
      <!-- More posts... -->
    </div>
  </div>
</div>
    """
  end

  def mount(%{"username" => username}, _session, socket) do
    with {:ok, author} <- Accounts.get_user_by_username(username),
        articles <- Articles.list_articles_by_author_id(author.id) do
      {:ok, assign(socket, author: author, articles: articles)}
    else
      _error ->
        {:ok, assign(socket, author: nil, articles: [])}
    end
  end
end
