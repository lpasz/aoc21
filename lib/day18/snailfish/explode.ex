defmodule Snailfish.Explode do
  def explode(snailfish) do
    with {:ok, path_to_explode} <-
           find_explodable_path(snailfish) do
      {:ok, do_explode(snailfish, path_to_explode)}
    end
  end

  def find_explodable_path(sfs, depth \\ 1, path \\ [])

  def find_explodable_path([sf1, sf2], depth, path)
      when depth > 4 and is_integer(sf1) and is_integer(sf2) do
    {:ok, Enum.reverse(path)}
  end

  def find_explodable_path(sf1, _depth, _path) when is_integer(sf1) do
    :error
  end

  def find_explodable_path([sf1, sf2], depth, path) do
    case find_explodable_path(sf1, depth + 1, [0 | path]) do
      {:ok, path} -> {:ok, path}
      :error -> find_explodable_path(sf2, depth + 1, [1 | path])
    end
  end

  def do_explode(sfs, path_to_explode) do
    {[x, y], after_explosion} = do_explode_pop(sfs, path_to_explode)

    cond do
      Enum.all?(path_to_explode, &(&1 == 0)) ->
        do_explode_add(after_explosion, next_path(path_to_explode), y, :next)

      Enum.all?(path_to_explode, &(&1 == 1)) ->
        do_explode_add(after_explosion, prev_path(path_to_explode), x, :prev)

      true ->
        after_explosion
        |> do_explode_add(prev_path(path_to_explode), x, :prev)
        |> do_explode_add(next_path(path_to_explode), y, :next)
    end
  end

  def do_explode_pop([sf1, sf2], [current_path]) do
    case current_path do
      0 -> {sf1, [0, sf2]}
      1 -> {sf2, [sf1, 0]}
    end
  end

  def do_explode_pop([sf1, sf2], [current_path | remaining_paths]) do
    case current_path do
      0 ->
        {removed, sf} = do_explode_pop(sf1, remaining_paths)
        {removed, [sf, sf2]}

      1 ->
        {removed, sf} = do_explode_pop(sf2, remaining_paths)
        {removed, [sf1, sf]}
    end
  end

  def do_explode_add(sfs, path, add, type \\ :next)

  def do_explode_add(num, _, add, _) when is_integer(num) do
    num + add
  end

  def do_explode_add([sf1, sf2], [], add, type) do
    case type do
      :prev -> [sf1, do_explode_add(sf2, [], add, type)]
      :next -> [do_explode_add(sf1, [], add, type), sf2]
    end
  end

  def do_explode_add([sf1, sf2], [current_path | remaining_paths], add, type) do
    case current_path do
      0 -> [do_explode_add(sf1, remaining_paths, add, type), sf2]
      1 -> [sf1, do_explode_add(sf2, remaining_paths, add, type)]
    end
  end

  def next_path(path) do
    [1 | path]
    |> Enum.join()
    |> String.to_integer(2)
    |> Kernel.+(1)
    |> Integer.to_string(2)
    |> String.to_integer()
    |> Integer.digits()
    |> tl()
  end

  def prev_path(path) do
    [1 | path]
    |> Enum.join()
    |> String.to_integer(2)
    |> Kernel.-(1)
    |> Integer.to_string(2)
    |> String.to_integer()
    |> Integer.digits()
    |> tl()
  end
end
