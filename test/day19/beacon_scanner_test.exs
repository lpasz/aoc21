defmodule BeaconScannerTest do
  use ExUnit.Case

  test "get_all_orientations" do
    original_orientation = [
      [-1, -1, 1],
      [-2, -2, 2],
      [-3, -3, 3],
      [-2, -3, 1],
      [5, 6, -4],
      [8, 0, 7]
    ]

    all_orientations = [
      [
        [-1, -1, 1],
        [-2, -2, 2],
        [-3, -3, 3],
        [-2, -3, 1],
        [5, 6, -4],
        [8, 0, 7]
      ],
      [
        [1, -1, 1],
        [2, -2, 2],
        [3, -3, 3],
        [2, -1, 3],
        [-5, 4, -6],
        [-8, -7, 0]
      ],
      [
        [-1, -1, -1],
        [-2, -2, -2],
        [-3, -3, -3],
        [-1, -3, -2],
        [4, 6, 5],
        [-7, 0, 8]
      ],
      [
        [1, 1, -1],
        [2, 2, -2],
        [3, 3, -3],
        [1, 3, -2],
        [-4, -6, 5],
        [7, 0, 8]
      ],
      [
        [1, 1, 1],
        [2, 2, 2],
        [3, 3, 3],
        [3, 1, 2],
        [-6, -4, -5],
        [0, 7, -8]
      ]
    ]

    assert get_all_orientations(original_orientation) -- all_orientations == []
  end
end
