bits =
  IO.stream(:stdio, :line)
  |> Enum.reduce([], fn line, counts ->
    String.graphemes(String.trim(line))
    |> Enum.with_index()
    |> Enum.map(fn {bit, idx} ->
      delta =
        case bit do
          "0" -> -1
          "1" -> +1
        end

      case Enum.at(counts, idx) do
        nil -> delta
        count -> count + delta
      end
    end)
  end)
  |> Enum.map(fn count -> if count >= 0, do: "1", else: "0" end)

gamma = bits |> Enum.join("")

epsilon =
  bits
  |> Enum.map(fn
    "0" -> "1"
    "1" -> "0"
  end)
  |> Enum.join("")

{gamma_int, _} = Integer.parse(gamma, 2)
{epsilon_int, _} = Integer.parse(epsilon, 2)

IO.puts(gamma_int * epsilon_int)
