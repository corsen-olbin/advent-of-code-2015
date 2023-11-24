# AdventOfCodeEx

Solutions to Advent of Code written in Elixir

Make sure to change the code inside of Day_X_.ex to return single integer solution. `part1(input)` and `part2(input)` need to return an integer number; this is the answer that gets plugged into Advent of Code website. `input` is entire input from Advent of Code website read as a string. Need to copy/paste text input from Advent of Code website into associated file in lib/advent_of_code_ex/puzzle_inputs. There's also space to copy easier example from puzzle explanation in lib/advent_of_code_ex/example_inputs.

Example:
```
def part1(input) do
  input
  |> read_input
  |> calc_answer // returns single integer to plug into Advent of Code website
end

def read_input(input) do
  // convert input to readable data structure
end

def calc_answer(readable_data_structure) do
  // do work to return answer
end
```

## Running

### Windows
To compile:
`mix escript.build`

To run:
`escript advent_of_code_ex <day> <part>`

To run example (mainly for debugging/testing):
`escript advent_of_code_ex <day> <part> -e`

