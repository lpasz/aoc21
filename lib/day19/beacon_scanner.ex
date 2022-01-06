defmodule BeaconScanner do
  def read_from_disk!(path \\ "test/day19/input.txt") do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.reduce(%{}, fn [scanner_title | scanners], acc ->
      scanner_title =
        scanner_title
        |> String.trim_leading("--- ")
        |> String.trim_trailing(" ---")
        |> String.replace(" ", "")
        |> String.to_atom()

      scanners =
        scanners
        |> Enum.map(&String.split(&1, ","))
        |> Enum.map(fn pos_x_y_z -> Enum.map(pos_x_y_z, &String.to_integer/1) end)

      Map.put(acc, scanner_title, scanners)
    end)
  end

  def number_of_beacons(scanners) do
    x =
      Enum.reduce(scanners, [], fn {k, v}, acc ->
        sall = all_beacons_agains_all(v)

        sall ++ acc
      end)

    y =
      x
      |> Enum.group_by(fn {k, v} -> k end)
      |> Enum.filter(fn {_, v} -> length(v) > 2 end)
      |> Enum.flat_map(fn {k, v} -> v end)
      |> Enum.flat_map(fn {_, v} -> v end)
      |> Enum.uniq()
      |> length()

    z =
      x
      |> Enum.group_by(fn {k, _} -> k end)
      |> Enum.flat_map(fn {_, v} -> v end)
      |> Enum.flat_map(fn {_, v} -> v end)
      |> Enum.uniq()
      |> length()

    z - y
  end

  def all_beacons_agains_all(scanner) do
    for beacon1 <- scanner, beacon2 <- scanner do
      {new_point(beacon1, beacon2), [beacon1, beacon2]}
    end
    |> Enum.reject(fn {k, v} -> k == [0, 0, 0] end)
  end

  def new_point([x1, y1, z1], [x2, y2, z2]) do
    [abs(x1 - x2), abs(y1 - y2), abs(z1 - z2)]
  end
end
