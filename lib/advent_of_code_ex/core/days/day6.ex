defmodule AdventOfCodeEx.Core.Days.Day6 do
alias AdventOfCodeEx.Core.Helpers.Map2D


  def part_1(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.map(&read_input/1)
    |> run_commands
    |> Map2D.count(fn x -> x end)
  end

  def part_2(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.map(&read_input/1)
    |> run_commands2
    |> Map2D.sum()
  end

  def read_input(command) do
    # turn on 0,0 through 999,0
    case Regex.named_captures(~r/(?<command>[a-z ]+) (?<x1>[0-9]+),(?<y1>[0-9]+) through (?<x2>[0-9]+),(?<y2>[0-9]+)/, command) do
      map when is_map(map) -> parse_regex(map)
      _ -> raise "issue with regex"
    end
  end

  def parse_regex(%{"command" => command, "x1" => x1, "y1" => y1, "x2" => x2, "y2" => y2}) do
    %{
      command: parse_command(command),
      x1: String.to_integer(x1),
      y1: String.to_integer(y1),
      x2: String.to_integer(x2),
      y2: String.to_integer(y2)
    }
  end

  def parse_command(command) do
    case command do
      "toggle" -> :toggle
      "turn on" -> :on
      "turn off" -> :off
    end
  end

  def run_commands(commands), do: run_commands_rec(commands, %{})

  def run_commands_rec([], acc), do: acc
  def run_commands_rec([%{command: com, x1: x1, y1: y1, x2: x2, y2: y2} | rest], grid) do
    new_grid = case com do
      :toggle -> for x <- x1..x2, y <- y1..y2, reduce: grid, do: (acc -> Map2D.update(acc, x, y, true, fn light -> not light end))
      :on -> for x <- x1..x2, y <- y1..y2, reduce: grid, do: (acc -> Map2D.update(acc, x, y, true, fn _light -> true end))
      :off -> for x <- x1..x2, y <- y1..y2, reduce: grid, do: (acc -> Map2D.update(acc, x, y, false, fn _light -> false end))
    end

    run_commands_rec(rest, new_grid)
  end

  def run_commands2(commands), do: run_commands_rec2(commands, %{})

  def run_commands_rec2([], acc), do: acc
  def run_commands_rec2([%{command: com, x1: x1, y1: y1, x2: x2, y2: y2} | rest], grid) do
    new_grid = case com do
      :toggle -> for x <- x1..x2, y <- y1..y2, reduce: grid, do: (acc -> Map2D.update(acc, x, y, 2, fn light -> light + 2 end))
      :on -> for x <- x1..x2, y <- y1..y2, reduce: grid, do: (acc -> Map2D.update(acc, x, y, 1, fn light -> light + 1 end))
      :off -> for x <- x1..x2, y <- y1..y2, reduce: grid, do: (acc -> Map2D.update(acc, x, y, 0, fn light -> max(light - 1, 0) end))
    end

    run_commands_rec2(rest, new_grid)
  end
end
