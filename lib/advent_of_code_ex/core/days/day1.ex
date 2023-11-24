defmodule AdventOfCodeEx.Core.Days.Day1 do


  def part_1(input) do
    input
    |> String.split("", trim: true)
    |> Enum.reduce(0, fn next, acc -> if next == "(", do: acc + 1, else: acc - 1 end)
  end

  def part_2(input) do
    input
    |> String.split("", trim: true)
    |> calc_until_neg_one
  end

  def calc_until_neg_one(list), do: calc_until_neg_one_rec(list, 0, 0)

  def calc_until_neg_one_rec(_list, -1, pos), do: pos
  def calc_until_neg_one_rec([symbol | list], floor, pos) do
    next_floor = if symbol == "(", do: floor + 1, else: floor - 1
    calc_until_neg_one_rec(list, next_floor, pos + 1)
  end
end
