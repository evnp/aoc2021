{_, _, _, count} =
  IO.stream(:stdio, :line)
  |> Enum.reduce({nil, nil, nil, 0}, fn line, {prevc, prevb, preva, count} ->
    {curr, _} = Integer.parse(line)

    {
      prevb,
      preva,
      curr,
      cond do
        preva == nil -> count
        prevb == nil -> count
        prevc == nil -> count
        prevc + prevb + preva < prevb + preva + curr -> count + 1
        true -> count
      end
    }
  end)

IO.puts(count)
