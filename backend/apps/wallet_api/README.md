# WalletApi

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

# Using CURL to test API

    curl -X POST -H "Content-Type: application/json" -d '{"invoice": "lntb1500n1pdw2kmkpp5akt9zm7xm0d9g38l4np86qqw4203265y2ekwttplm67mq5mfcy7sdpa2fjkzep6yptks7fqv3hk2ueqv4mx2unedahx2grhv9h8ggr5dusxyateypxxzcqzyspzkrz3rzr7kkkp8c0cepmfmamwvqwapjmcejgsa5am9zcv28vqzyztr0ywlm4dxwsa7rp92f5cu6l85c50rdy3vjwe8fc6xcdcylt4gqut8rxt"}' http://localhost:4000/api/wallet/transactions

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
