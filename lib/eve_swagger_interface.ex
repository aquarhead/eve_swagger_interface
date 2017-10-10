defmodule EVESwaggerInterface do
  @moduledoc """
  Simple, `use`-able ESI wrapper.
  """

  defmacro __using__(opts) do
    resp = Tesla.get("https://esi.tech.ccp.is/_latest/swagger.json?datasource=tranquility")
    spec = Poison.decode!(resp.body)
    base_uri = %URI{
      scheme: spec["schemes"] |> List.first,
      host: spec["host"],
      path: spec["basePath"],
    }

    version_in_path = (base_uri.path == nil)

    Enum.each(spec["paths"], fn {path, v} ->
      Enum.each(v, fn {method, subspec} ->
        IO.puts "#{method}, #{path} => #{ESI.RequestFunctions.generate_function_name(method, path, version_in_path)}"
      end)
    end)

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
