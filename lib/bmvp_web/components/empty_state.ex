defmodule BmvpWeb.Component.EmptyState do
  use BmvpWeb, :html

  attr(:text, :string, required: true)
  attr(:image, :string, required: true)

  def show(assigns) do
    ~H"""
    <div>
      <h2 class="text-lg font-semibold tracking-tight sm:text-center sm:text-lg">
        <%= @text %>
      </h2>
      <div class="mt-10 mx-auto w-full max-w-xs">
        <img
          src={~p"/images/#{@image}"}
          class="w-full max-w-none rounded-xl ring-1 ring-gray-400/10 md:-ml-4 lg:-ml-0"
        />
      </div>
    </div>
    """
  end
end
