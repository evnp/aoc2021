counts =
  IO.stream(:stdio, :line)
  |> Enum.reduce([], fn line, counts ->
    bits = String.trim(line)

    String.graphemes(bits)
    |> Enum.with_index()
    |> Enum.map(fn {bit, idx} ->
      delta =
        case bit do
          "0" -> -1
          "1" -> +1
        end

      count_key =
        cond do
          idx == 0 -> ""
          idx > 0 -> String.slice(bits, 0..(idx - 1))
        end

      count_map =
        case Enum.at(counts, idx) do
          nil -> %{}
          map -> map
        end

      count =
        case Map.fetch(count_map, count_key) do
          :error -> {delta, bits}
          {:ok, {count, _}} -> {count + delta, nil}
        end

      Map.put(count_map, count_key, count)
    end)
  end)

{oxy_bits, co2_bits, oxy_match, co2_match} =
  counts
  |> Enum.reduce({"", "", nil, nil}, fn count_map, {oxy_bits, co2_bits, oxy_match, co2_match} ->
    {oxy_count, oxy_found_match} =
      case Map.fetch(count_map, oxy_bits) do
        :error -> {nil, oxy_match}
        {:ok, count} -> count
      end

    {co2_count, co2_found_match} =
      case Map.fetch(count_map, co2_bits) do
        :error -> {nil, co2_match}
        {:ok, count} -> count
      end

    {
      cond do
        oxy_count == nil -> oxy_bits
        oxy_count >= 0 -> oxy_bits <> "1"
        true -> oxy_bits <> "0"
      end,
      cond do
        co2_count == nil -> co2_bits
        co2_count >= 0 -> co2_bits <> "0"
        true -> co2_bits <> "1"
      end,
      oxy_found_match,
      co2_found_match
    }
  end)

oxy_code =
  case oxy_match do
    nil -> oxy_bits
    match -> match
  end

co2_code =
  case co2_match do
    nil -> co2_bits
    match -> match
  end

oxygen = String.to_integer(oxy_code, 2)
co2 = String.to_integer(co2_code, 2)

IO.inspect(oxygen * co2)
