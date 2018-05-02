defmodule WalletApi.Lightning do
  @moduledoc """
  The Lnd context.
  """

  alias WalletApi.Lightning.Invoice

  def decode_invoice("lntb1500n1pdw2kmkpp5akt9zm7xm0d9g38l4np86qqw4203265y2ekwttplm67mq5mfcy7sdpa2fjkzep6yptks7fqv3hk2ueqv4mx2unedahx2grhv9h8ggr5dusxyateypxxzcqzyspzkrz3rzr7kkkp8c0cepmfmamwvqwapjmcejgsa5am9zcv28vqzyztr0ywlm4dxwsa7rp92f5cu6l85c50rdy3vjwe8fc6xcdcylt4gqut8rxt") do
    %Invoice{
      description: "Baguette",
      msatoshi: 150000
    }
  end
end
