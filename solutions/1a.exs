{_, count} =
  IO.stream(:stdio, :line)
  |> Enum.reduce({nil, 0}, fn line, {prev, count} ->
    {curr, _} = Integer.parse(line)

    {curr,
     cond do
       prev == nil -> count
       prev < curr -> count + 1
       true -> count
     end}
  end)

IO.puts(count)
