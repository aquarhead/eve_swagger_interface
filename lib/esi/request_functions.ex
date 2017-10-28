defmodule ESI.RequestFunctions do
  @moduledoc false

  def generate_functions(spec) do
    base_uri = %URI{
      scheme: spec["schemes"] |> List.first,
      host: spec["host"],
      path: spec["basePath"],
    }

    versioned_path? = (base_uri.path == nil)

    Enum.each(spec["paths"], fn {path, v} ->
      Enum.each(v, fn {method, _subspec} ->
        func_name = generate_function_name(method, path, versioned_path?)

        IO.puts "#{method |> String.upcase}\t#{path} => #{func_name}"
      end)
    end)
  end

  def generate_function_name(method, path, versioned_path?) do
    path
    |> String.trim("/")
    |> String.split("/")
    |> remove_version(versioned_path?)
    |> Enum.reduce([], &merge_name_parts/2)
    |> Enum.reverse
    |> List.insert_at(0, method)
    |> Enum.join("_")
  end

  defp remove_version(path, true), do: path |> Enum.drop(1)
  defp remove_version(path, false), do: path

  defp merge_name_parts(part, []), do: [part]
  defp merge_name_parts(part, [last_part | rest] = name_parts) do
    cleaned_part = clean_argument_part(part)
    if String.starts_with?(last_part, cleaned_part) and last_part != cleaned_part do
      [cleaned_part | rest]
    else
      [cleaned_part | name_parts]
    end
  end

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
