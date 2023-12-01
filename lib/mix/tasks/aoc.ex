defmodule Mix.Tasks.Aoc do
  @moduledoc """
  Runs solutions for Advent of Code.

  ## Usage
  `mix aoc <day>`

  `mix aoc <day> <part>`

  If `part` is not given, default is 1.

  ## Command line options
    * `--example` or `-e` - uses input from dayXexample.txt instead of dayX.txt.
  """
  use Mix.Task
  alias AdventOfCodeEx.CLI

  @shortdoc "Runs Advent of Code solution."
  @impl Mix.Task
  def run(args) do
    CLI.main(args)
  end
end
