defmodule AdventOfCodeEx.Core.Days.Day5 do
  def part_1(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.filter(&check_string/1)
    |> Enum.count()
  end

  def part_2(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.filter(&check_string2/1)
    |> Enum.count()
  end

  def check_string(string) do
    case is_nice(string) do
      {:nice, _string} -> true
      {:naughty, _string} -> false
    end
  end

  def is_nice(string) do
    string
    |> three_vowels()
    |> double_letter()
    |> no_bad_strings()
  end

  def three_vowels(string) do
    case Enum.count(String.graphemes(string), fn x -> Enum.member?(["a", "e", "i", "o", "u"], x) end) > 2 do
      true -> {:nice, string}
      false -> {:naughty, :not_enough_vowels}
    end
  end

  def double_letter({:naughty, _} = res), do: res
  def double_letter({:nice, string}) do
    case has_double_rec(String.graphemes(string), "") do
      true -> {:nice, string}
      false -> {:naughty, :no_double_letter}
    end
  end

  def has_double_rec([], _), do: false
  def has_double_rec([next | _rest], next), do: true
  def has_double_rec([next | rest], _last), do: has_double_rec(rest, next)

  def no_bad_strings({:naughty, _} = res), do: res
  def no_bad_strings({:nice, string}) do
    case Enum.any?(["ab", "cd", "pq", "xy"], fn bad -> String.contains?(string, bad) end) do
      true -> {:naughty, :contains_bad}
      false -> {:nice, string}
    end
  end

  def check_string2(string) do
    case is_nice2(string) do
      {:nice, _string} -> true
      {:naughty, _string} -> false
    end
  end

  def is_nice2(string) do
    string
    |> two_letters_twice()
    |> repeat_with_one_between()
  end

  def two_letters_twice(string), do: two_letters_twice_rec(String.graphemes(string), string)

  def two_letters_twice_rec([], _string), do: {:naughty, :no_two_letters_twice}
  def two_letters_twice_rec([_x | []], _string), do: {:naughty, :no_two_letters_twice}
  def two_letters_twice_rec([_x, _y | []], _string), do: {:naughty, :no_two_letters_twice}
  def two_letters_twice_rec([x, y | rest], string) do
    case String.contains?(Enum.join(rest), x <> y) do
      true -> {:nice, string}
      false -> two_letters_twice_rec([y | rest], string)
    end
  end

  def repeat_with_one_between({:naughty, _} = res), do: res
  def repeat_with_one_between({:nice, string}), do: repeat_with_one_between_rec(String.graphemes(string), string)

  def repeat_with_one_between_rec([], _string), do: {:naughty, :no_repeat_one_between}
  def repeat_with_one_between_rec([_one | []], _string), do: {:naughty, :no_repeat_one_between}
  def repeat_with_one_between_rec([_one, _two | []], _string), do: {:naughty, :no_repeat_one_between}
  def repeat_with_one_between_rec([one, _two, one | _rest], string), do: {:nice, string}
  def repeat_with_one_between_rec([_one, two, thr | rest], string), do: repeat_with_one_between_rec([two, thr | rest], string)
end
