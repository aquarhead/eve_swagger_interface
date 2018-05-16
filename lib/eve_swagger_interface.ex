defmodule EVESwaggerInterface do
  @moduledoc """
  Simple, `use`-able ESI wrapper.
  """

  defmacro __using__(opts) do
    {:ok, resp} = Tesla.get("https://esi.evetech.net/_latest/swagger.json?datasource=tranquility")
    spec = Poison.decode!(resp.body)

    quote do
      use Tesla
      adapter Tesla.Adapter.Hackney

      def build_client(opts) do

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
