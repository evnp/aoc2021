{dist, depth} =
  IO.stream(:stdio, :line)
  |> Enum.reduce({0, 0}, fn line, {dist, depth} ->
    [direction, str_amount] = ~w[#{line}]
    {amount, _} = Integer.parse(str_amount)

    {
      case direction do
        "forward" -> dist + amount
        "backward" -> dist - amount
        _ -> dist
      end,
      case direction do
        "down" -> depth + amount
        "up" -> depth - amount
        _ -> depth
      end
    }
  end)

IO.puts(dist * depth)
