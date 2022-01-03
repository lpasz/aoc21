defmodule Snailfish.Magnitude do
  def magnitude(sf) when is_integer(sf) do
    sf
  end

  def magnitude([sf1, sf2]) do
    magnitude(sf1) * 3 + magnitude(sf2) * 2
  end
end
