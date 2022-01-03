defmodule Snailfish.Split do
  def split(sfs) do
    with {:ok, path_to_split} <- find_split_path(sfs) do
      {:ok, do_split(sfs, path_to_split)}
    end
  end

  defp find_split_path(sfs, path \\ [])

  defp find_split_path(sf, path) when is_integer(sf) and sf > 9 do
    {:ok, Enum.reverse(path)}
  end

  defp find_split_path(sf, _path) when is_integer(sf) do
    :error
  end

  defp find_split_path([sf1, sf2], path) do
    case find_split_path(sf1, [0 | path]) do
      :error -> find_split_path(sf2, [1 | path])
      {:ok, path} -> {:ok, path}
    end
  end

  defp do_split(sf, []) do
    [div(sf, 2), round(sf / 2)]
  end

  defp do_split([sf1, sf2], [current_path | remaining_paths]) do
    case current_path do
      0 -> [do_split(sf1, remaining_paths), sf2]
      1 -> [sf1, do_split(sf2, remaining_paths)]
    end
  end
end
