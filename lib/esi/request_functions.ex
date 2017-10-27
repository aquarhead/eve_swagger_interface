defmodule ESI.RequestFunctions do
  @moduledoc false

  def generate_functions(spec) do
    base_uri = %URI{
      scheme: spec["schemes"] |> List.first,
      host: spec["host"],
      path: spec["basePath"],
    }

    version_in_path = (base_uri.path == nil)

    Enum.each(spec["paths"], fn {path, v} ->
      Enum.each(v, fn {method, subspec} ->
        url_parts = path
        |> String.trim("/")
        |> String.split("/")
        |> remove_version(version_in_path)
        |> generate_function_name(method)

        IO.puts "#{method}, #{path} => #{generate_function_name(method, url_parts)}"
      end)
    end)
  end

  def generate_function_name(http_method, url_parts) do
    url_parts
    |> Enum.reduce(
      [""],
    fn (part, [last_part | rest] = name_parts) ->
      cleaned_part = clean_argument_part(part)
      if String.starts_with?(last_part, cleaned_part) do
        [cleaned_part | rest]
      else
        [cleaned_part | name_parts]
      end
    end)
    |> Enum.reverse
    |> Enum.drop(1)
    |> List.insert_at(0, http_method)
    |> Enum.join("_")
  end

  defp remove_version(path, true), do: path |> Enum.drop(1)
  defp remove_version(path, false), do: path

  defp clean_argument_part(part) do
    if String.starts_with?(part, "{") do
      part
      |> String.trim_leading("{")
      |> String.trim_trailing("}")
      |> String.trim_trailing("_id")
    else
      part
    end
  end
end
