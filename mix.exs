defmodule LoginExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :login_example,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {LoginExample.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:floki, "~> 0.26.0"},
      {:crawly, git: "https://github.com/oltarasenko/crawly.git", branch: "start_requests"}
    ]
  end
end
