defmodule BeaconScanner do
  def read_from_disk!(path \\ "test/day19/input.txt") do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.reduce([], fn [_scanner_title | scanners], acc ->
      scanners =
        scanners
        |> Enum.map(&String.split(&1, ","))
        |> Enum.map(fn pos_x_y_z -> Enum.map(pos_x_y_z, &String.to_integer/1) end)

      [scanners | acc]
    end)
    |> Enum.reverse()
  end

  def calc_beacons([initial_scanner | others_scans]) do
    Enum.reduce(
      others_scans,
      initial_scanner,
      &unique_beacons_in_relation_to_prev_scanner(&2, &1)
    )
  end

  def unique_beacons_in_relation_to_prev_scanner(
        prev_scanner_beacon,
        next_scanner_beacon
      ) do
    previous_beacons_distance_to_other_scanned_beacons =
      all_beacons_distance_to_all_other_beacons(prev_scanner_beacon)

    next_beacons_distance_to_other_scanned_beacons =
      all_beacons_distance_to_all_other_beacons(next_scanner_beacon)

    overlapping_points =
      overlapping_pairs(
        previous_beacons_distance_to_other_scanned_beacons,
        next_beacons_distance_to_other_scanned_beacons
      )

    next_scanner_position = next_scanner_position(overlapping_points)

    recalculate_next_scanner_beacon_position(
      prev_scanner_beacon,
      next_scanner_beacon,
      next_scanner_position
    )
  end

  def recalculate_next_scanner_beacon_position(
        prev_scanner_beacons,
        next_scanner_beacons,
        [nx, ny, nz]
      ) do
    for nsb <- beacon_scanned_by_orientation(next_scanner_beacons) do
      next_scanner_remapped = Enum.map(nsb, fn [x, y, z] -> [nx - x, ny - y, nz - z] end)

      prev_scanner_beacons ++ next_scanner_remapped
    end
    |> Enum.map(&Enum.uniq/1)
    |> Enum.min_by(&length/1)
  end

  def next_scanner_position(overlapping_points) do
    {prev_scanner_beacons_overlap, next_scanner_beacons_overlap} = Enum.unzip(overlapping_points)

    for next_scanner_beacons_overlap_variant <-
          beacon_scanned_by_orientation(next_scanner_beacons_overlap) do
      next_scanner_position =
        prev_scanner_beacons_overlap
        |> Enum.zip(next_scanner_beacons_overlap_variant)
        |> Enum.map(fn {[x1, y1, z1], [x2, y2, z2]} -> [x1 + x2, y1 + y2, z1 + z2] end)

      {Enum.all?(next_scanner_position, &(&1 == next_scanner_position |> hd())),
       next_scanner_position}
    end
    |> Enum.filter(fn {is, _val} -> is end)
    |> Enum.flat_map(fn {_, [h | _t]} -> h end)
  end

  def beacon_scanned_by_orientation(beacons) do
    beacons
    |> Enum.map(&beacon_in_relation_to_all_scanner_possibilities/1)
    |> Enum.zip_with(& &1)
  end

  def beacon_in_relation_to_all_scanner_possibilities(beacon) do
    beacon_with_index =
      beacon |> Enum.with_index() |> Enum.flat_map(fn {b, i} -> [{b, i}, {-b, i}] end)

    is_uniq? = &(&1 |> Enum.uniq() |> length() == 3)

    for {x, xi} <- beacon_with_index,
        {y, yi} <- beacon_with_index,
        {z, zi} <- beacon_with_index,
        is_uniq?.([xi, yi, zi]) do
      [x, y, z]
    end
  end

  def all_beacons_distance_to_all_other_beacons(scanner) do
    for beacon1 <- scanner, beacon2 <- scanner, beacon1 != beacon2 do
      {distance_between_two_beacons(beacon1, beacon2), [beacon1, beacon2]}
    end
  end

  def distance_between_two_beacons([x1, y1, z1], [x2, y2, z2] \\ [0, 0, 0]) do
    abs(x1 - x2) * abs(y1 - y2) * abs(z1 - z2)
  end

  def overlapping_pairs(previous_beacons_distance, next_beacons_distance) do
    map =
      previous_beacons_distance
      |> Enum.map(&seek_beacons_overlapping_in_next_scanner(&1, next_beacons_distance))
      |> Enum.reject(fn {_, next_beacon_pairs} -> next_beacon_pairs == [] end)
      |> Enum.reduce(%{}, &number_of_occurrences_together/2)
      |> Enum.reduce(%{}, &find_matching_point/2)

    repeated =
      map
      # |> IO.inspect()
      |> Enum.reject(fn {k, v} -> length(v) != 2 end)

    if repeated != [] do
      repeated
      |> Enum.unzip()
      |> IO.inspect()
      |> Enum.reduce(map, fn {[k1, k2], [v1, v2]}, acc ->
        [vs1, vs2] = Enum.uniq(v1 ++ v2) |> IO.inspect()

        ps = Enum.all?(k1, &positive?/1) and Enum.all?(vs1, &positive?/1)
        ns = Enum.all?(k1, &(not positive?(&1))) and Enum.all?(vs1, &(not positive?(&1)))

        if ns or ps do
          if distance_between_two_beacons(k1) > distance_between_two_beacons(k2) do
            acc
            |> Map.put(k1, Enum.max_by([vs1, vs2], &distance_between_two_beacons/1))
            |> Map.put(k2, Enum.min_by([vs1, vs2], &distance_between_two_beacons/1))
          else
            acc
            |> Map.put(k2, Enum.max_by([vs1, vs2], &distance_between_two_beacons/1))
            |> Map.put(k1, Enum.min_by([vs1, vs2], &distance_between_two_beacons/1))
          end
        else
          if distance_between_two_beacons(k1) > distance_between_two_beacons(k2) do
            acc
            |> Map.put(k2, Enum.max_by([vs1, vs2], &distance_between_two_beacons/1))
            |> Map.put(k1, Enum.min_by([vs1, vs2], &distance_between_two_beacons/1))
          else
            acc
            |> Map.put(k1, Enum.max_by([vs1, vs2], &distance_between_two_beacons/1))
            |> Map.put(k2, Enum.min_by([vs1, vs2], &distance_between_two_beacons/1))
          end
        end
      end)
    else
      map
    end

    # Enum.map(map, fn {k, ls = [h | _]} ->
    #   if is_list(h) do
    #     {k, Kernel.--(ls, map |> Map.delete(k) |> Map.keys())}
    #   else
    #     {k, ls}
    #   end
    # end)
    # |> IO.inspect()
    # |> Enum.into(%{})
  end

  defp find_matching_point({beacon, related_beacons}, acc) do
    freq = Enum.frequencies(related_beacons)

    {_, max} = Enum.max_by(freq, fn {_, n} -> n end)

    case Enum.filter(freq, fn {_, n} -> max == n end) do
      [] ->
        raise "You Failed"

      [{one, _}] ->
        Map.put(acc, beacon, one)

      more_than_one ->
        find_overlapping_by_signals(beacon, more_than_one, acc)
    end
  end

  defp positive?(n), do: n > 0

  defp find_overlapping_by_signals(beacon, beacons, acc) do
    equal_or_complete_oposite? = fn b1, b2 ->
      o1 = Enum.map(b1, &positive?/1)
      o2 = Enum.map(b2, &positive?/1)

      zip = Enum.zip(o1, o2)

      Enum.all?(zip, fn {i1, i2} -> i1 == i2 end) or
        Enum.all?(zip, fn {i1, i2} -> i1 != i2 end)
    end

    beacons
    |> Enum.filter(fn {b1, _} -> equal_or_complete_oposite?.(beacon, b1) end)
    |> case do
      [] ->
        raise "You Failed"

      [{one, _}] ->
        Map.put(acc, beacon, one)

      more ->
        Map.put(acc, beacon, Enum.map(more, fn {val, _} -> val end))
    end
  end

  defp number_of_occurrences_together({[beacon1, beacon2], [beacon3, beacon4]}, acc) do
    acc
    |> Map.update(beacon1, [beacon3, beacon4], &[beacon3, beacon4 | &1])
    |> Map.update(beacon2, [beacon3, beacon4], &[beacon3, beacon4 | &1])
  end

  defp seek_beacons_overlapping_in_next_scanner(
         {prev_pair_distance, prev_beacon_pair},
         next_beacons_distance
       ) do
    matching_pairs =
      next_beacons_distance
      |> Enum.filter(fn {next_pair_distance, _} -> next_pair_distance == prev_pair_distance end)
      |> Enum.map(fn {_, next_beacons_pair} -> next_beacons_pair end)
      |> Enum.reduce([], &++/2)
      |> Enum.uniq()

    {prev_beacon_pair, matching_pairs}
  end
end
