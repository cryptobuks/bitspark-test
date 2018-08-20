defmodule Wallet.Email do
  import Bamboo.Email

  def claim_transaction_email(to_email, claim_url) do
    new_email(
      from: "yes@biluminate.com",
      to: to_email,
      subject: "Incoming Bitcoin payment",
      text_body: "Claim your BTC at #{claim_url}",
      html_body: "Claim your BTC at <a href=\"#{claim_url}\">#{claim_url}</a>"
    )
  end
end
