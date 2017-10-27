defmodule ESI.RequestFunctionsTest do
  use ExUnit.Case, async: true

  import ESI.RequestFunctions

  test "function name resources list" do
    assert "get_killmails" == generate_function_name(["killmails"], "get")
  end

  test "function name resource singleton" do
    assert "get_killmail" == generate_function_name(["killmails", "{killmail_id}"], "get")
  end
end
