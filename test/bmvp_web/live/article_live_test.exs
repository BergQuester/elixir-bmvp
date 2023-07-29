defmodule BmvpWeb.ArticleLiveTest do
  use BmvpWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bmvp.ArticlesFixtures

  @create_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil}

  defp create_article(_) do
    article = article_fixture()
    %{article: article}
  end

  describe "Index" do
    setup [:create_article]

    test "lists all articles", %{conn: conn, article: article} do
      {:ok, _index_live, html} = live(conn, ~p"/articles")

      assert html =~ "Listing Articles"
      assert html =~ article.content
    end

    test "saves new article", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/articles")

      assert index_live |> element("a", "New Article") |> render_click() =~
               "New Article"

      assert_patch(index_live, ~p"/articles/new")

      assert index_live
             |> form("#article-form", article: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#article-form", article: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/articles")

      html = render(index_live)
      assert html =~ "Article created successfully"
      assert html =~ "some content"
    end

    test "updates article in listing", %{conn: conn, article: article} do
      {:ok, index_live, _html} = live(conn, ~p"/articles")

      assert index_live |> element("#articles-#{article.id} a", "Edit") |> render_click() =~
               "Edit Article"

      assert_patch(index_live, ~p"/articles/#{article}/edit")

      assert index_live
             |> form("#article-form", article: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#article-form", article: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/articles")

      html = render(index_live)
      assert html =~ "Article updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes article in listing", %{conn: conn, article: article} do
      {:ok, index_live, _html} = live(conn, ~p"/articles")

      assert index_live |> element("#articles-#{article.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#articles-#{article.id}")
    end
  end

  describe "Show" do
    setup [:create_article]

    test "displays article", %{conn: conn, article: article} do
      {:ok, _show_live, html} = live(conn, ~p"/articles/#{article}")

      assert html =~ "Show Article"
      assert html =~ article.content
    end

    test "updates article within modal", %{conn: conn, article: article} do
      {:ok, show_live, _html} = live(conn, ~p"/articles/#{article}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Article"

      assert_patch(show_live, ~p"/articles/#{article}/show/edit")

      assert show_live
             |> form("#article-form", article: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#article-form", article: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/articles/#{article}")

      html = render(show_live)
      assert html =~ "Article updated successfully"
      assert html =~ "some updated content"
    end
  end
end
