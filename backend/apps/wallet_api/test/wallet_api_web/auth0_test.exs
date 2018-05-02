defmodule WalletApiWeb.Auth0Test do
  use ExUnit.Case
  alias WalletApiWeb.Auth0

  test "can validate generated token" do
    assert %Joken.Token{errors: errors} = Auth0.verify_token(Auth0.create_token(%{}))
    assert errors == []
  end
end
