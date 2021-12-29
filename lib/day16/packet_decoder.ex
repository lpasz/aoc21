defmodule PacketDecoder do
  def read_from_disk!(path \\ "lib/day16/input.txt") do
    path
    |> File.read!()
    |> Base.decode16!()
  end

  def part_1(input \\ read_from_disk!()) do
    input
    |> decode()
    |> sum_versions()
  end

  def part_2(input \\ read_from_disk!()) do
    input
    |> decode()
    |> IO.inspect()
    |> do_decoded_operation()
  end

  def do_decoded_operation({decode, _rest}), do: decode |> do_decoded_operation()

  def do_decoded_operation(decode) do
    case decode.type_id do
      0 ->
        Enum.map(decode.sub_packets, &get_packet_val/1) |> Enum.sum()

      1 ->
        Enum.map(decode.sub_packets, &get_packet_val/1) |> Enum.product()

      2 ->
        Enum.map(decode.sub_packets, &get_packet_val/1) |> Enum.min()

      3 ->
        Enum.map(decode.sub_packets, &get_packet_val/1) |> Enum.max()

      5 ->
        [v1, v2] = Enum.map(decode.sub_packets, &get_packet_val/1)
        if v1 < v2, do: 1, else: 0

      6 ->
        [v1, v2] = Enum.map(decode.sub_packets, &get_packet_val/1)
        if v1 > v2, do: 1, else: 0

      7 ->
        [v1, v2] = Enum.map(decode.sub_packets, &get_packet_val/1)
        if v1 == v2, do: 1, else: 0
    end
  end

  defp get_packet_val(packet) do
    case Map.get(packet, :literal_value) do
      nil -> do_decoded_operation(packet)
      val -> val
    end
  end

  def sum_versions({decode, _rest}), do: decode |> List.wrap() |> sum_versions(0)

  def sum_versions([decode | decodes], sum) do
    (decodes ++ Map.get(decode, :sub_packets, []))
    |> IO.inspect()
    |> sum_versions(decode.version + sum)
  end

  def sum_versions([], sum), do: sum

  def decode_all(encoded, decoded \\ []) do
    case decode(encoded) do
      {[], rest} -> {decoded, rest}
      {packet, rest} -> decode_all(rest, [packet | decoded])
    end
  end

  def decode(encoded) do
    case encoded do
      <<version::size(3), 4::size(3), rest::bits()>> ->
        {literal_value, rest} = decode_subpacket(rest)

        {%{version: version, type_id: 4, literal_value: literal_value}, rest}

      <<version::size(3), type_id::size(3), 0::size(1), total_length_in_bits::size(15),
        sub_packets_encoded::bitstring()-size(total_length_in_bits), rest::bits()>> ->
        {sub_packets, other_rest} = decode_all(sub_packets_encoded)

        {%{
           version: version,
           type_id: type_id,
           length_type_id: 0,
           total_length_in_bits: total_length_in_bits,
           sub_packets: sub_packets
         }, <<other_rest::bitstring(), rest::bitstring()>>}

      <<version::size(3), type_id::size(3), 1::size(1), number_of_sub_packets::size(11),
        rest::bits()>> ->
        {sub_packets, rest} =
          Enum.reduce(1..number_of_sub_packets, {[], rest}, fn _,
                                                               {sub_packets_decoded,
                                                                sub_packets_encoded} ->
            {decoded, rest} = decode(sub_packets_encoded)
            {[decoded | sub_packets_decoded], rest}
          end)

        {%{
           version: version,
           type_id: type_id,
           length_type_id: 1,
           number_of_sub_packets: number_of_sub_packets,
           sub_packets: sub_packets
         }, rest}

      _ ->
        {[], encoded}
    end
  end

  def decode_subpacket(encoded, current_literal \\ <<>>)

  def decode_subpacket(
        <<0::size(1), literal_part::bitstring()-size(4), rest::bits()>>,
        current_literal
      ) do
    current_literal = <<current_literal::bitstring(), literal_part::bitstring()>>
    size_of_current_literal = bit_size(current_literal)
    <<num::size(size_of_current_literal)>> = current_literal
    {num, rest}
  end

  def decode_subpacket(
        <<1::size(1), literal_part::bitstring()-size(4), rest::bits()>>,
        current_literal
      ) do
    decode_subpacket(rest, <<current_literal::bitstring(), literal_part::bitstring()>>)
  end
end
