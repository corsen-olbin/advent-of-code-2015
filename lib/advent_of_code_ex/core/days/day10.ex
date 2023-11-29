defmodule AdventOfCodeEx.Core.Days.Day10 do

  def part_1(input) do
    input
    |> look_and_say_rec(40)
    |> String.length()
  end

  def part_2(input) do
    input
    |> look_and_say_rec(50)
    |> String.length()
  end

  def look_and_say_rec(string, 0), do: string
  def look_and_say_rec(string, times_left) do
    string
    |> String.graphemes()
    |> calc_new_string_rec(String.first(string), 0, "")
    |> look_and_say_rec(times_left - 1)
  end

  def calc_new_string_rec([], last, times, acc), do: acc <> "#{times}#{last}"

  def calc_new_string_rec([head | rest], head, times, acc) do
    calc_new_string_rec(rest, head, times + 1, acc)
  end

  def calc_new_string_rec([head | rest], last, times, acc) do
    calc_new_string_rec(rest, head, 1, acc <> "#{times}#{last}")
  end
end
