# struct - short for structure, a struct is a map (basically an object in javascript terms) that is used to store data in an elixir application, just like maps, but with two advantages: they can be assigned default values, and have additional compile time checking properties.
defmodule Identicon.Image do
  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil # we're going to store that list numbers as this hex property, which has a default value of nil
  #iex> %Identicon.Image{} # this creates a struct with the default nil value for the hex property we define above

end
