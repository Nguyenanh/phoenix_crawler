use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :phoenix_crawler, PhoenixCrawlerWeb.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  url: [scheme: "http", host: "13.115.209.106", port: 80],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: "HPDgnupWT6vxG7fLEYqrjzPHX0nIVKp/yBYt21eR9TsqZxtzzeXRsncphPuoRMf8",

# Configure your database
config :phoenix_crawler, PhoenixCrawler.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "postgres://qzewlihqxvxnca:489a72d69e04d4d62fb97aa4485aa20db55cbbc36930ce084c2b11669050717b@ec2-184-73-210-189.compute-1.amazonaws.com:5432/dguahbvtbkcsj",
  pool_size: String.to_integer(10)

# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :phoenix_crawler, PhoenixCrawlerWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         :inet6,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :phoenix_crawler, PhoenixCrawlerWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases (distillery)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :phoenix_crawler, PhoenixCrawlerWeb.Endpoint, server: true
#
# Note you can't rely on `System.get_env/1` when using releases.
# See the releases documentation accordingly.

# Finally import the config/prod.secret.exs which should be versioned
# separately.
# import_config "prod.secret.exs"
