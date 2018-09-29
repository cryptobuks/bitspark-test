defmodule WalletWeb.Auth0 do
  use Agent

  @moduledoc """
  Auth0 context.
  """

  def start_link() do
    config = Application.get_env(:wallet_web, :auth0)

    # TODO: Fetch key(s) from Auth0: Get
    # https://biluminate.eu.auth0.com/.well-known/jwks.json and call
    # JOSE.JWK.from_map (on parsed JSON keys)
    key = JOSE.JWK.from_pem_file(
      Path.join(Application.app_dir(:wallet_web), config[:key]))
    processed_config = Keyword.put(config, :key, key)

    Agent.start_link(fn -> processed_config end, name: __MODULE__)
  end

  defp get_config(), do: Agent.get(__MODULE__, &(&1))

  def verify_function() do
    config = get_config()

    %Joken.Token{}
    |> Joken.with_json_module(Poison)
    |> Joken.with_signer(Joken.rs256(config[:key]))
    |> Joken.with_validation("aud", &((is_list(&1) and (config[:aud] in &1))
        or &1 == config[:aud]), "Invalid audience")
    |> Joken.with_validation("iat", &(&1 <= Joken.current_time))
    |> Joken.with_validation("exp", &(&1 > Joken.current_time), "Expired token")
    |> Joken.with_validation("iss", &(&1 == config[:issuer]))
  end

  def verify_token(token) do
    verify_function()
    |> Joken.with_compact_token(token)
    |> Joken.verify
  end

  def create_token(auth_scopes \\ %{sub: "testing"}, opts \\ []) do
    config = get_config()

    %Joken.Token{claims: auth_scopes}
    |> Joken.with_signer(Joken.rs256(config[:key]))
    |> Joken.with_aud(config[:aud])
    |> Joken.with_iat
    |> Joken.with_exp(Joken.current_time + Keyword.get(opts, :expires_after, 86_400 * 14))
    |> Joken.with_iss(config[:issuer])
    |> Joken.sign
    |> Joken.get_compact
  end

  def print_testing_token() do
    IO.puts(create_token(%{sub: "testing"}))
  end

  def print_random_token() do
    IO.puts(create_token(%{sub: Utils.random_string(32)}))
  end

  def print_expired_token() do
    IO.puts(create_token(%{sub: Utils.random_string(32)}, expires_after: 0))
  end
end
