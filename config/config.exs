# in config.exs
use Mix.Config

config :logger,
       level: :info,
       truncate: 4096

config :crawly,
       closespider_timeout: 10,
       concurrent_requests_per_domain: 8,
       middlewares: [
         Crawly.Middlewares.DomainFilter,
         Crawly.Middlewares.UniqueRequest,
         Crawly.Middlewares.AutoCookiesManager,
         {Crawly.Middlewares.UserAgent, user_agents: ["Crawly Bot"]}
       ],
       pipelines: [
         {Crawly.Pipelines.Validate, fields: [:text, :author, :goodreads_link]},
         Crawly.Pipelines.JSONEncoder,
         {Crawly.Pipelines.WriteToFile, extension: "json", folder: "/tmp"}
       ]