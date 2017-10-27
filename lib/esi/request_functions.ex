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

        IO.puts "#{method}, #{path} => #{ESI.RequestFunctions.generate_function_name(url_parts, method)}"
      end)
    end)
  end

  def generate_function_name(url_parts, http_method) do
    url_parts
    |> Enum.reduce(
      [""], # start with "", so we don't have to handle special case for first part
    fn (part, [last_part | rest] = name_parts) ->
      cleaned_part = clean_part(part) # remove {} and _id from parameter part
      if String.starts_with?(last_part, cleaned_part) do # e.g. /killmails/{killmail_id} -> /killmail
        [cleaned_part | rest]
      else
        [cleaned_part | name_parts]
      end
    end)
    |> Enum.reverse # reverse because we're adding everything to head
    |> Enum.drop(1) # remove the initial ""
    |> List.insert_at(0, http_method) # add http method in the front
    |> Enum.join("_") # join and hooray!
  end

  defp remove_version(path, true), do: path |> Enum.drop(1)
  defp remove_version(path, false), do: path

  defp clean_part(part) do
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
