defmodule AdventOfCodeEx.Core.Days.Day2 do

  def part_1(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.map(&(String.split(&1, "x", trim: true)))
    |> Enum.map(fn x -> calc_surface_area_for_wrapping(x) end)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.map(&(String.split(&1, "x", trim: true)))
    |> Enum.map(fn x -> calc_ribbon_length(x) end)
    |> Enum.sum()
  end

  def calc_surface_area_for_wrapping([ls, ws, hs | []]) do
    l = String.to_integer(ls)
    w = String.to_integer(ws)
    h = String.to_integer(hs)
    lw = l * w
    wh = w * h
    hl = h * l
    (2*lw) + (2*wh) + (2*hl) + min(lw, min(wh, hl))
  end

  def calc_ribbon_length(lengths) do
    sides = Enum.map(lengths, &String.to_integer/1)
    max_side = Enum.max(sides)

    short_sides = Enum.filter(sides, fn x -> x < max_side end)

    [l1, l2] = case Enum.count(short_sides) do
      2 -> short_sides
      1 -> [max_side | short_sides]
      0 -> [max_side, max_side]
    end

    2*l1 + 2*l2 + Enum.reduce(sides, 1, fn x, acc -> x * acc end)
  end
end
