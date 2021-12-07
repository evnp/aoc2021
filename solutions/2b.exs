{_, dist, depth} =
  IO.stream(:stdio, :line)
  |> Enum.reduce({0, 0, 0}, fn line, {aim, dist, depth} ->
    [direction, str_amount] = ~w{#{line}}
    {amount, _} = Integer.parse(str_amount)

    {
      case direction do
        "down" -> aim + amount
        "up" -> aim - amount
        _ -> aim
      end,
      case direction do
        "forward" -> dist + amount
        "backward" -> dist - amount
        _ -> dist
      end,
      case direction do
        "forward" -> depth + aim * amount
        "backward" -> depth - aim * amount
        _ -> depth
      end
    }
  end)

IO.puts(dist * depth)
