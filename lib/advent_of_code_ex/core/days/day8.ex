defmodule AdventOfCodeEx.Core.Days.Day8 do

  def part_1(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.map(&calc_literal_memory_difference/1)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.map(fn s -> calc_literal_length2(s) - String.length(s) end)
    |> Enum.sum()
  end

  def calc_literal_memory_difference(string) do
    String.length(string) - calc_mem_length(string)
  end

  def calc_mem_length(string) do
    string
    |> String.trim("\"")
    |> String.graphemes()
    |> calc_mem_length_rec(0)
  end

  def calc_literal_length2(string) do
    string
    |> String.slice(1..-2//1)
    |> String.replace("\\", "\\\\")
    |> String.replace("\"", "\\\"")
    |> then(&("\"\\\"#{&1}\\\"\""))
    |> String.length
  end

  def calc_mem_length_rec([], acc), do: acc
  def calc_mem_length_rec(["\\", "x", _, _ | rest], acc), do: calc_mem_length_rec(rest, acc + 1)
  def calc_mem_length_rec(["\\", _ | rest], acc), do: calc_mem_length_rec(rest, acc + 1)
  def calc_mem_length_rec([_ | rest], acc), do: calc_mem_length_rec(rest, acc + 1)
end
