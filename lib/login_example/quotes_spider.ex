defmodule Spiders.Quotes do
  use Crawly.Spider

  @impl Crawly.Spider
  def base_url(), do: "http://quotes.toscrape.com"

  @impl Crawly.Spider
  def init() do
    login_cookie = get_login_cookie("username", "password")

    [
      start_requests: [
        Crawly.Request.new("http://quotes.toscrape.com/", [{"Cookie", login_cookie}])
      ]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    quotes = Floki.find(document, ".quote")

    items =
      Enum.map(quotes, fn quote ->
        goodreads_link =
          Floki.find(quote, "a:fl-contains('about')")
          |> Floki.attribute("href")
          |> Floki.text()

        %{
          text: Floki.find(quote, ".text") |> Floki.text(),
          author: Floki.find(quote, ".author") |> Floki.text(),
          goodreads_link: goodreads_link
        }
      end)

    next_link = Floki.find(document, "li.next a") |> Floki.attribute("href") |> Floki.text()

    requests =
      Crawly.Utils.build_absolute_urls([next_link], base_url())
      |> Crawly.Utils.requests_from_urls()

    %Crawly.ParsedItem{:items => items, :requests => requests}
  end

  def get_login_cookie(username, password) do
    # Get login page
    action = "http://quotes.toscrape.com/login"
    response = Crawly.fetch(action)

    # Extract the cookie and CSRF token from the form
    cookie = :proplists.get_all_values("Set-Cookie", response.headers)
    {:ok, document} = Floki.parse_document(response.body)

    csrf =
      Floki.find(document, "form input[name='csrf_token']")
      |> Floki.attribute("value")
      |> Floki.text()

    req_body =
      URI.encode_query(%{"username" => username, "password" => password, "csrf_token" => csrf})

    {:ok, response} =
      HTTPoison.post(
        action,
        req_body,
        %{"Content-Type" => "application/x-www-form-urlencoded", "Cookie" => cookie}
      )

    :proplists.get_all_values("Set-Cookie", response.headers)
  end
end
