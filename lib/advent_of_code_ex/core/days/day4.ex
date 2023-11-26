defmodule AdventOfCodeEx.Core.Days.Day4 do


  def part_1(input) do
    input
    |> find_md5_five_zero_start("00000")
  end

  def part_2(input) do
    input
    |> find_md5_five_zero_start("000000")
  end


  def find_md5_five_zero_start(string, start), do: find_md5_five0s_rec(string, 1, start, Range.new(0,String.length(start) - 1))

  def find_md5_five0s_rec(string, num, start, start_range) do
    with combo <- string <> to_string(num),
      hash <- :crypto.hash(:md5, combo) |> Base.encode16() do
        if String.slice(hash, start_range) == start do
          num
        else
          find_md5_five0s_rec(string, num + 1, start, start_range)
        end
      end
  end
end
