defmodule AdventOfCodeEx.Core.Days.Day3 do


  def part_1(input) do
    input
    |> String.split("", trim: true)
    |> calc_houses_visited()
    |> Map.keys()
    |> Enum.count()
  end

  def part_2(input) do
    input
    |> String.split("", trim: true)
    |> split_into_two_lists()
    |> Enum.map(&calc_houses_visited/1)
    |> combine_both_maps()
    |> Map.keys()
    |> Enum.count()
  end

  def calc_houses_visited(list), do: calc_houses_visited_rec(list, {0, 0}, %{{0, 0} => 1})

  def calc_houses_visited_rec([], _pos, history), do: history
  def calc_houses_visited_rec([command | rest], {x, y}, history) do
    new_pos = case command do
      "<" -> { x - 1, y }
      ">" -> { x + 1, y }
      "^" -> { x, y + 1 }
      "v" -> { x, y - 1 }
    end
    new_history = Map.update(history, new_pos, 1, fn x -> x + 1 end)

    calc_houses_visited_rec(rest, new_pos, new_history)
  end

  def split_into_two_lists(list) do
    [Enum.drop_every(list, 2), Enum.drop_every(["x" | list], 2)]
  end

  def combine_both_maps([map1, map2]) do
    Map.merge(map1, map2, fn _key, v1, v2 -> v1 + v2 end)
  end
end
