defmodule AdventOfCodeEx.Core.Days.Day7 do
  import Bitwise

  def part_1(input) do
    input
    |> String.split("\r\n", trim: true)
    |> build_instr_tree()
    |> solve("a")
    |> Map.get("a")
  end

  def part_2(_input) do
    raise "Part 2 of day 7 involves changing input based on answer to part 1"
  end

  def solve(instr_tree, to_solve),
    do: solve_rec(instr_tree, %{}, [Map.fetch!(instr_tree, to_solve)])

  def solve_rec(_instr_tree, solved_map, []), do: solved_map

  def solve_rec(instr_tree, solved_map, [head | rest]) when is_bitstring(head) do
    with {:ok, _solved} <- Map.fetch(solved_map, head) do

      solve_rec(instr_tree, solved_map, rest)
    else
      :error -> solve_rec(instr_tree, Map.put(solved_map, head, String.to_integer(head)), rest)
    end
  end

  def solve_rec(instr_tree, solved_map, [%{command: :num, to: to, right: right} | rest] = list) do
    with {:ok, solved} <- Map.fetch(solved_map, right) do
      solve_rec(instr_tree, Map.put(solved_map, to, solved), rest)
    else
      :error -> solve_rec(instr_tree, solved_map, [Map.get(instr_tree, right, right) | list])
    end
  end

  def solve_rec(
        instr_tree,
        solved_map,
        [%{command: :and, to: to, right: right, left: left} | rest] = list
      ) do
    with {:ok, right_solved} <- Map.fetch(solved_map, right),
         {:ok, left_solved} <- Map.fetch(solved_map, left) do
      solve_rec(
        instr_tree,
        Map.put(solved_map, to, right_solved &&& left_solved &&& 0xFFFF),
        rest
      )
    else
      :error ->
        solve_rec(instr_tree, solved_map, [
          Map.get(instr_tree, left, left),
          Map.get(instr_tree, right, right) | list
        ])
    end
  end

  def solve_rec(
        instr_tree,
        solved_map,
        [%{command: :or, to: to, right: right, left: left} | rest] = list
      ) do
    with {:ok, right_solved} <- Map.fetch(solved_map, right),
         {:ok, left_solved} <- Map.fetch(solved_map, left) do
      solve_rec(
        instr_tree,
        Map.put(solved_map, to, (right_solved ||| left_solved) &&& 0xFFFF),
        rest
      )
    else
      :error ->
        solve_rec(instr_tree, solved_map, [
          Map.get(instr_tree, left, left),
          Map.get(instr_tree, right, right) | list
        ])
    end
  end

  def solve_rec(
        instr_tree,
        solved_map,
        [%{command: :not, to: to, right: right} | rest] = list
      ) do
    with {:ok, right_solved} <- Map.fetch(solved_map, right) do
      solve_rec(instr_tree, Map.put(solved_map, to, ~~~right_solved &&& 0xFFFF), rest)
    else
      :error ->
        solve_rec(instr_tree, solved_map, [
          Map.get(instr_tree, right, right) | list
        ])
    end
  end

  def solve_rec(
        instr_tree,
        solved_map,
        [%{command: :lshift, to: to, right: right, left: left} | rest] = list
      ) do
    with {:ok, left_solved} <- Map.fetch(solved_map, left) do
      solve_rec(instr_tree, Map.put(solved_map, to, left_solved <<< right &&& 0xFFFF), rest)
    else
      :error ->
        solve_rec(instr_tree, solved_map, [
          Map.get(instr_tree, left, left) | list
        ])
    end
  end

  def solve_rec(
        instr_tree,
        solved_map,
        [%{command: :rshift, to: to, right: right, left: left} | rest] = list
      ) do
    with {:ok, left_solved} <- Map.fetch(solved_map, left) do
      solve_rec(instr_tree, Map.put(solved_map, to, left_solved >>> right &&& 0xFFFF), rest)
    else
      :error ->
        solve_rec(instr_tree, solved_map, [
          Map.get(instr_tree, left, left) | list
        ])
    end
  end

  def build_instr_tree(inputs), do: build_instr_tree_rec(inputs, %{})

  def build_instr_tree_rec([], acc), do: acc

  def build_instr_tree_rec([head | list], acc) do
    new_acc =
      case parse_command(head) do
        %{to: to} = command -> Map.put(acc, to, command)
      end

    build_instr_tree_rec(list, new_acc)
  end

  def parse_command(string) do
    cond do
      String.contains?(string, "AND") -> read_and(string)
      String.contains?(string, "OR") -> read_or(string)
      String.contains?(string, "NOT") -> read_not(string)
      String.contains?(string, "LSHIFT") -> read_lshift(string)
      String.contains?(string, "RSHIFT") -> read_rshift(string)
      true -> read_num(string)
    end
  end

  def read_and(string) do
    case Regex.named_captures(
           ~r/(?<left>[a-z0-9]+) AND (?<right>[a-z]+) -> (?<to>[a-z]+)/,
           string
         ) do
      %{"right" => right, "left" => left, "to" => to} ->
        %{command: :and, right: right, left: left, to: to}

      _ ->
        raise "error parsing #{string}"
    end
  end

  def read_or(string) do
    case Regex.named_captures(~r/(?<left>[a-z]+) OR (?<right>[a-z]+) -> (?<to>[a-z]+)/, string) do
      %{"right" => right, "left" => left, "to" => to} ->
        %{command: :or, right: right, left: left, to: to}

      _ ->
        raise "error parsing #{string}"
    end
  end

  def read_not(string) do
    case Regex.named_captures(~r/NOT (?<right>[a-z]+) -> (?<to>[a-z]+)/, string) do
      %{"right" => right, "to" => to} -> %{command: :not, right: right, to: to}
      _ -> raise "error parsing #{string}"
    end
  end

  def read_lshift(string) do
    case Regex.named_captures(
           ~r/(?<left>[a-z]+) LSHIFT (?<right>[0-9]+) -> (?<to>[a-z]+)/,
           string
         ) do
      %{"right" => right, "left" => left, "to" => to} ->
        %{command: :lshift, right: String.to_integer(right), left: left, to: to}

      _ ->
        raise "error parsing #{string}"
    end
  end

  def read_rshift(string) do
    case Regex.named_captures(
           ~r/(?<left>[a-z]+) RSHIFT (?<right>[0-9]+) -> (?<to>[a-z]+)/,
           string
         ) do
      %{"right" => right, "left" => left, "to" => to} ->
        %{command: :rshift, right: String.to_integer(right), left: left, to: to}

      _ ->
        raise "error parsing #{string}"
    end
  end

  def read_num(string) do
    case Regex.named_captures(~r/(?<right>[a-z0-9]+) -> (?<to>[a-z]+)/, string) do
      %{"right" => right, "to" => to} ->
        %{command: :num, right: right, to: to}

      _ ->
        raise "error parsing #{string}"
    end
  end
end
