defmodule AdventOfCodeEx.Core.Days.Day9 do
  def part_1(input) do
    input
    |> String.split("\r\n", trim: true)
    |> make_graph()
    |> shortest_dist_to_all()
    |> then(fn {_, dist} -> dist end)
  end

  def part_2(input) do
    input
    |> String.split("\r\n", trim: true)
    |> make_graph()
    |> longest_dist_to_all()
    |> then(fn {_, dist} -> dist end)
  end

  def make_graph(list), do: make_graph_rec(list, %{})

  def make_graph_rec([], acc), do: acc

  def make_graph_rec([head | list], acc) do
    with node <- read_line(head) do
      new_acc =
        acc
        |> Map.update(node["from"], [{node["to"], String.to_integer(node["distance"])}], fn x ->
          [{node["to"], String.to_integer(node["distance"])} | x]
        end)
        |> Map.update(node["to"], [{node["from"], String.to_integer(node["distance"])}], fn x ->
          [{node["from"], String.to_integer(node["distance"])} | x]
        end)

      make_graph_rec(list, new_acc)
    end
  end

  def read_line(line) do
    Regex.named_captures(~r/(?<from>[a-zA-Z]+) to (?<to>[a-zA-Z]+) = (?<distance>[0-9]+)/, line)
  end

  def shortest_dist_to_all(graph) do
    keys = Map.keys(graph)

    keys
    |> Enum.map(fn x -> dist_rec(graph, x, List.delete(keys, x), %{}, 0, {%{}, 1_000_000_000}) end)
    |> Enum.min_by(fn {_, dist} -> dist end)
  end

  def dist_rec(_graph, _, [], order, dist, {_, short_dist} = short) do
    if dist < short_dist do
      {order, dist}
    else
      short
    end
  end

  def dist_rec(graph, current, to_visit, order, dist, short) do
    visit_list =
      graph
      |> Map.get(current)
      |> Enum.filter(fn {x, _} -> Enum.any?(to_visit, fn to -> to == x end) end)

    visit_list
    |> Enum.map(fn {to, to_dist} ->
      dist_rec(graph, to, List.delete(to_visit, to), [to | order], dist + to_dist, short)
    end)
    |> Enum.min_by(fn {_, final} -> final end)
  end

  def longest_dist_to_all(graph) do
    keys = Map.keys(graph)

    keys
    |> Enum.map(fn x -> dist_rec2(graph, x, List.delete(keys, x), %{}, 0, {%{}, 0}) end)
    |> Enum.max_by(fn {_, dist} -> dist end)
  end

  def dist_rec2(_graph, _, [], order, dist, {_, long_dist} = long) do
    if dist > long_dist do
      {order, dist}
    else
      long
    end
  end

  def dist_rec2(graph, current, to_visit, order, dist, short) do
    visit_list =
      graph
      |> Map.get(current)
      |> Enum.filter(fn {x, _} -> Enum.any?(to_visit, fn to -> to == x end) end)

    visit_list
    |> Enum.map(fn {to, to_dist} ->
      dist_rec2(graph, to, List.delete(to_visit, to), [to | order], dist + to_dist, short)
    end)
    |> Enum.max_by(fn {_, final} -> final end)
  end
end
