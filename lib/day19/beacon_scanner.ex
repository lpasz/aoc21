defmodule BeaconScanner do
  def read_from_disk!(path \\ "test/day19/input.txt") do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.reduce([], fn [scanner_title | scanners], acc ->
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

      [scanners | acc]
    end)
    |> Enum.reverse()
  end

  def check_overlapping_beacons(scanner1, scanner2) do
    {all, same_distance_beacons} = more_overlapping(scanner1, scanner2)

    remap_beacons = map_beacons_from_one_scanner_to_the_other(same_distance_beacons)

    [x1, y1, z1] = get_scanner_position(remap_beacons)

    remap_scanner_2 = get_scanner_new_position(scanner1, scanner2, [x1, y1, z1])

    Enum.uniq(scanner1 ++ remap_scanner_2) |> tap(&IO.inspect(length(&1)))
  end

  def all_beacons_distance_to_all_other_beacons(scanner) do
    for beacon1 <- scanner, beacon2 <- scanner, beacon1 != beacon2, into: %{} do
      {distance_between_two_beacons(beacon1, beacon2), [beacon1, beacon2]}
    end
  end

  def distance_between_two_beacons([x1, y1, z1], [x2, y2, z2]) do
    abs(x1 - x2) * abs(y1 - y2) * abs(z1 - z2)
  end

  def distance_between_scanners(scanner1, scanner2) do
    check_overlapping_beacons(scanner1, scanner2)
  end

  def map_beacons_from_one_scanner_to_the_other(all_points) when is_list(all_points) do
    all_points
    |> Enum.flat_map(&map_beacons_from_one_scanner_to_the_other/1)
    |> Enum.group_by(fn [b1, _b2] -> b1 end)
    |> Enum.map(fn {k, v} ->
      {k, v |> Enum.frequencies() |> Enum.max_by(fn {_n, v} -> v end) |> elem(0) |> tl() |> hd()}
    end)
  end

  def map_beacons_from_one_scanner_to_the_other({beacon_pair1, beacon_pair2}) do
    positive? = &(&1 > 0)

    equal_or_complete_oposite? = fn b1, b2 ->
      o1 = Enum.map(b1, positive?)
      o2 = Enum.map(b2, positive?)

      zip = Enum.zip(o1, o2)

      Enum.all?(zip, fn {i1, i2} -> i1 == i2 end) or Enum.all?(zip, fn {i1, i2} -> i1 != i2 end)
    end

    for b1 <- beacon_pair1, b2 <- beacon_pair2 do
      for b2_all <- all_orientations(b2), equal_or_complete_oposite?.(b1, b2_all) do
        [b1, b2_all]
      end
    end
  end

  def all_scanner_orientations(beacons) do
    Enum.map(beacons, &all_orientations/1)
    |> Enum.zip_with(& &1)
  end

  def all_orientations([x, y, z]) do
    ii = [x, y, z] |> Enum.with_index() |> Enum.flat_map(fn {x, i} -> [{x, i}, {-x, i}] end)

    for {x1, xi} <- ii, {y1, yi} <- ii, {z1, zi} <- ii, Enum.uniq([xi, yi, zi]) == [xi, yi, zi] do
      [x1, y1, z1]
    end
  end

  def get_scanner_position(results) do
    ops = [&Kernel.+/2, &Kernel.-/2]

    IO.inspect(results, label: :overlapping)

    for x_op <- ops, y_op <- ops, z_op <- ops do
      for {[x1, y1, z1], [x2, y2, z2]} <- results do
        [x_op.(x1, x2), y_op.(y1, y2), z_op.(z1, z2)]
      end
    end
    |> Enum.filter(fn results ->
      not Enum.empty?(results) and Enum.all?(results, &(&1 == hd(results)))
    end)
    |> hd
    |> hd
  end

  def get_scanner_new_position(scanner1, scanner2, [xs, ys, zs]) do
    ops = [&Kernel.+/2, &Kernel.-/2]

    for x_op <- ops, y_op <- ops, z_op <- ops do
      for [x1, y1, z1] <- scanner2 do
        [x_op.(xs, x1), y_op.(ys, y1), z_op.(zs, z1)]
      end
    end
    |> Enum.min_by(fn scanner -> (scanner1 ++ scanner) |> Enum.uniq() |> length() end)
  end

  def more_overlapping(scanner1, scanner2) do
    all_beacons1 = all_beacons_distance_to_all_other_beacons(scanner1)

    more_ov =
      scanner2
      |> all_scanner_orientations()
      |> Enum.map(fn scanner ->
        all_beacons2 = all_beacons_distance_to_all_other_beacons(scanner)

        all_beacons1
        |> Enum.map(fn {d1, beacons1} -> {beacons1, all_beacons2[d1]} end)
      end)
      |> Enum.min_by(fn beacons_agains_each_other ->
        Enum.count(beacons_agains_each_other, fn {_, v} -> is_nil(v) end)
      end)

    {more_ov,
     more_ov |> Enum.reject(fn {_beacons1, beacons2} -> beacons2 == nil end) |> IO.inspect()}
  end
end
