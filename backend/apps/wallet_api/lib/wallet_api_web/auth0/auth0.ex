defmodule WalletApiWeb.Auth0 do
  @moduledoc """
  Auth0 context.
  """

  def get_config, do: Application.get_env(:wallet_api, :auth0)

  def get_auth_key, do: get_config() |> get_auth_key
  def get_auth_key(config) do
    JOSE.JWK.from_pem_file(Path.join(
          Application.app_dir(:wallet_api),
          config[:key]))
  end

  def verify_function() do
    config = get_config()

    %Joken.Token{}
    |> Joken.with_json_module(Poison)
    |> Joken.with_signer(Joken.rs256(get_auth_key(config)))
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

  def create_token(auth_scopes) do
    config = get_config()

    %Joken.Token{claims: auth_scopes}
    |> Joken.with_signer(Joken.rs256(get_auth_key(config)))
    |> Joken.with_aud(config[:aud])
    |> Joken.with_iat
    |> Joken.with_exp(Joken.current_time + 86_400)
    |> Joken.with_iss(config[:issuer])
    |> Joken.sign
    |> Joken.get_compact
  end
end
