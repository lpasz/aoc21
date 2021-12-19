defmodule SyntaxScoring do
  defstruct [:valid?, :open_brackets, :error_bracket, :auto_complete]

  @matching_pair %{
    "(" => ")",
    "{" => "}",
    "[" => "]",
    "<" => ">",
    ")" => "(",
    "]" => "[",
    "}" => "{",
    ">" => "<"
  }

  def part_1 do
    result = read_from_disk!() |> total_compilation_error()

    IO.puts("Total compilation errors are #{result}")
  end

  def part_2 do
    result = read_from_disk!() |> total_autocompletion_points()

    IO.puts("Total compilation autocomplete points are #{result}")
  end

  def read_from_disk!(path \\ "lib/day10/input.txt") do
    path |> File.read!() |> String.split("\n") |> Enum.map(&String.codepoints/1)
  end

  def total_compilation_error(input) do
    input
    |> Enum.map(&line_compilation_error_points/1)
    |> Enum.map(&compilation_error_points(&1.error_bracket))
    |> Enum.sum()
  end

  def total_autocompletion_points(input) do
    input
    |> Enum.map(&line_compilation_error_points/1)
    |> Enum.filter(& &1.valid?)
    |> Enum.map(&autocomplete_closing_brackets/1)
    |> Enum.map(&autocomplete_closing_brackets_points(&1.auto_complete))
    |> Enum.sort()
    |> get_middle()
  end

  defp get_middle(list) do
    len = length(list)
    middle = len - div(len, 2) - 1
    {val, _} = List.pop_at(list, middle)
    val
  end

  defp autocomplete_closing_brackets(
         %__MODULE__{open_brackets: open_brackets, auto_complete: []} = token
       ) do
    %{token | auto_complete: Enum.map(open_brackets, &@matching_pair[&1])}
  end

  defp autocomplete_closing_brackets_points(auto_complete) when is_list(auto_complete) do
    auto_complete
    |> Enum.map(&autocomplete_closing_bracket_points/1)
    |> Enum.reduce(0, &(&2 * 5 + &1))
  end

  defp autocomplete_closing_bracket_points(auto_complete_bracket) do
    case auto_complete_bracket do
      ")" -> 1
      "]" -> 2
      "}" -> 3
      ">" -> 4
    end
  end

  defp line_compilation_error_points(line) do
    start_syntax_scoring_token = %__MODULE__{
      valid?: true,
      error_bracket: nil,
      open_brackets: [],
      auto_complete: []
    }

    Enum.reduce(line, start_syntax_scoring_token, &check_line/2)
  end

  def compilation_error_points(error_causing_closing_brackets) do
    case error_causing_closing_brackets do
      nil -> 0
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
    end
  end

  defp check_line(current_bracket, %__MODULE__{valid?: false} = token) do
    token
  end

  defp check_line(current_open_bracket, %__MODULE__{} = token)
       when current_open_bracket in ~w({ [ \( <) do
    %{token | open_brackets: [current_open_bracket | token.open_brackets]}
  end

  defp check_line(
         current_close_bracket,
         %__MODULE__{open_brackets: [current_open | still_open]} = token
       )
       when current_close_bracket in ~w(} ] \) >) do
    if current_close_bracket == @matching_pair[current_open] do
      %{token | open_brackets: still_open}
    else
      %{token | error_bracket: current_close_bracket, valid?: false}
    end
  end
end

SyntaxScoring.part_1()
SyntaxScoring.part_2()
