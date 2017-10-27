defmodule EVESwaggerInterface do
  @moduledoc """
  Simple, `use`-able ESI wrapper.
  """

  defmacro __using__(opts) do
    resp = Tesla.get("https://esi.tech.ccp.is/_latest/swagger.json?datasource=tranquility")
    spec = Poison.decode!(resp.body)

    quote do
      use Tesla

      def client(token) do
        Tesla.build_client([
          {Tesla.Middleware.Headers, %{"Authorization" => "Bearer " <> token}},
          # language
          # user agent
          # base uri
        ])
      end
    end
  end
end
