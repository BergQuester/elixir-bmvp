defmodule BmvpWeb.UrlHelper do
  use BmvpWeb, :verified_routes

  @article_namespace "articles"

  def gen_unique_article_url(article_id) do
    token = Phoenix.Token.sign(BmvpWeb.Endpoint, @article_namespace, article_id)
    Phoenix.VerifiedRoutes.url(BmvpWeb.Endpoint, ~p"/articles/#{article_id}?#{[token: token]}")
  end

  def verify_unique_article_token(token) do
    Phoenix.Token.verify(BmvpWeb.Endpoint, @article_namespace, token, max_age: :infinity)
  end
end
