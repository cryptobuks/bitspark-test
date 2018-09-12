defmodule Wallet.Email do
  import Bamboo.Email

  def claim_transaction_email(to_email, claim_token) do
    claim_url = "#{Application.get_env(:wallet, :wallet_base_url)}/#/claim/#{claim_token}"

    new_email(
      from: "yes@biluminate.com",
      to: to_email,
      subject: "Incoming payment",
      text_body: """
        Dear user,

        One of Biluminate.com users sent you certain amount of BTC. You can claim it at
        #{claim_url}

        Just Sign-in and receive the funds if you are Biluminate.com user already; or Sign-up.

        Be aware of every such transfer has specific expiration time set by the sender
        so claim the funds as soon as possible to avoid the expiration.

        Have a nice day.

        Biluminate.com
        https://www.biluminate.com/about
      """,
      html_body: """
        Dear user,

        <p>
        One of Biluminate.com users sent you certain amount of BTC. You can claim it at<br/>
        #{claim_url}
        </p>

        <p>
        Just Sign-in and receive the funds if you are Biluminate.com user already; or Sign-up.
        </p>

        <p>
        Be aware of every such transfer has specific expiration time set by the sender
        so claim the funds as soon as possible to avoid the expiration.
        </p>

        <p>
        Have a nice day.
        </p>

        <p>
        Biluminate.com<br/>
        https://www.biluminate.com/about
        </p>
      """
    )
  end
end
