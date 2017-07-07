defmodule Elissh do
  use Application
  import Supervisor.Spec

  def start(:normal, _) do
    children = [
      worker(Elissh.ConnectionRegistry, []),
      worker(Elissh.Console, []),
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Elissh.Supervisor)
  end

  def start_config_registry(supervisor, config_file) do
    config = File.read!(config_file) |> YamlElixir.read_from_string
    Supervisor.start_child(supervisor, worker(Elissh.ConfigRegistry, [config]))
  end

  def start_fact_registry(supervisor, fact_file) do
    facts = File.read!(fact_file) |> YamlElixir.read_from_string
    Supervisor.start_child(supervisor, worker(Elissh.FactRegistry, [facts]))
  end

  def start_script_reader(supervisor, script) do
    Supervisor.start_child(supervisor, worker(Elissh.ScriptReader, [script]))
  end
end
