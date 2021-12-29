defmodule PacketDecoderTest do
  use ExUnit.Case

  test "decode type_id 4 literal correctly" do
    {packet, <<0::size(3)>>} = "D2FE28" |> Base.decode16!() |> PacketDecoder.decode()
    assert packet.literal_value == 2021
    assert packet.type_id == 4
    assert packet.version == 6
  end

  test "decode length type id 0 correctly" do
    {packet, <<0::size(7)>>} = "38006F45291200" |> Base.decode16!() |> PacketDecoder.decode()
    assert packet.length_type_id == 0
    assert packet.sub_packets == [%{literal_value: 10, type_id: 4, version: 6}]
    assert packet.total_length_in_bits == 27
    assert packet.type_id == 6
    assert packet.version == 1
  end

  test "decode length type id 1 correctly" do
    {packet, <<0::size(5)>>} = "EE00D40C823060" |> Base.decode16!() |> PacketDecoder.decode()
    assert packet.length_type_id == 1
    assert packet.number_of_sub_packets == 3

    assert packet.sub_packets == [
             %{literal_value: 3, type_id: 4, version: 1},
             %{literal_value: 2, type_id: 4, version: 4},
             %{literal_value: 1, type_id: 4, version: 2}
           ]

    assert packet.type_id == 3
    assert packet.version == 7
  end
end
