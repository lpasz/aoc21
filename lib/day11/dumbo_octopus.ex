defmodule DumboOctopus do
  def part_1 do
    num_flash = apply_steps(read_from_disk!(), 100)

    IO.puts("100 steps made #{num_flash}")
  end

  def part_2 do
    input = read_from_disk!()
    len = input |> Enum.to_list() |> length() |> IO.inspect()
    num_flash = when_all_flash_sync(input, len)

    IO.puts("They all light together in step #{num_flash}")
  end

  def read_from_disk!(path \\ "lib/day11/input.txt") do
    path
    |> File.read!()
    |> parse_input()
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line -> line |> String.graphemes() |> Enum.map(&String.to_integer/1) end)
    |> create_dumbo_octopus_grid()
  end

  defp create_dumbo_octopus_grid(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      line
      |> Enum.with_index()
      |> Enum.map(fn {item, x} -> {{x, y}, item} end)
    end)
    |> List.flatten()
    |> Enum.into(%{})
  end

  def when_all_flash_sync(dumbo_octopuses, num_of_octopus, round \\ 0) do
    round = round + 1
    {new_dumbo_octopuses, flashes} = apply_single_step(dumbo_octopuses)

    # IO.inspect(new_dumbo_octopuses, label: :new_dumbo_octopuses)
    # IO.inspect(num_of_octopus, label: :num_of_octopus)
    # IO.inspect(flashes, label: :flash)
    # IO.inspect(round, label: :round)
    # Process.sleep(1000)

    if flashes == num_of_octopus do
      round
    else
      when_all_flash_sync(new_dumbo_octopuses, num_of_octopus, round)
    end
  end

  def apply_steps(dumbo_octopuses, steps, flashes \\ 0)

  def apply_steps(_dumbo_octopuses, 0, flashes), do: flashes

  def apply_steps(dumbo_octopuses, steps, flashes) do
    {new_dumbo_octopuses, new_flashes} = apply_single_step(dumbo_octopuses)

    apply_steps(new_dumbo_octopuses, steps - 1, flashes + new_flashes)
  end

  def apply_single_step(dumbo_octopuses) do
    add_one_dumbo_octopuses =
      dumbo_octopuses
      |> apply_single_step_inc_one()
      |> Enum.into(%{})

    apply_single_step_flash_shockwave(add_one_dumbo_octopuses, add_one_dumbo_octopuses)
  end

  defp apply_single_step_inc_one(dumbo_octopuses) do
    dumbo_octopuses
    |> Enum.to_list()
    |> Enum.map(fn {pos, val} -> {pos, val + 1} end)
  end

  defp apply_single_step_flash_shockwave(dumbo_octopuses, dumbo_octopuses_map) do
    dumbo_octopuses
    |> Enum.map(fn {pos, _} -> pos end)
    |> flash_shockwave(dumbo_octopuses_map)
  end

  defp flash_shockwave(octopus_positions, dumbo_octopuses, flashes \\ 0)
  defp flash_shockwave([], dumbo_octopuses, flashes), do: {dumbo_octopuses, flashes}

  defp flash_shockwave([octopus_pos | rest], dumbo_octopuses, flashes) do
    octopus_energy_level = Map.get(dumbo_octopuses, octopus_pos, 0)

    cond do
      octopus_energy_level > 9 ->
        shockwave_hit = octopus_pos |> flash_wave_surround_areas(dumbo_octopuses)

        shockwave_increase_dumbo_octopuses =
          shockwave_hit
          |> Enum.reduce(dumbo_octopuses, fn shockwave_hit, acc ->
            Map.update(acc, shockwave_hit, 0, fn
              0 -> 0
              x -> x + 1
            end)
          end)
          |> Map.put(octopus_pos, 0)

        octopuses_to_check = List.flatten([shockwave_hit | rest])

        flash_shockwave(octopuses_to_check, shockwave_increase_dumbo_octopuses, flashes + 1)

      true ->
        flash_shockwave(rest, dumbo_octopuses, flashes)
    end
  end

  defp flash_wave_surround_areas({x, y}, map) do
    [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
    ]
    |> Enum.reject(&is_nil(map[&1]))
  end
end

DumboOctopus.part_1()
DumboOctopus.part_2()
