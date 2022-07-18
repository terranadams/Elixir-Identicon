defmodule Identicon do
  def main(input) do
    input |> hash_input |> pick_color |> build_grid |> filter_odd_squares
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input) |> :binary.bin_to_list
    %Identicon.Image{hex: hex} # this is how we're saving our hex to the hex property in the image.ex file (the struct, which is a similar concept to a JSON file)
    # ^^^ this is also what gets returned out of the function

    # The goal here is to convert the string being passed into a series of unique numbers (to make the identicon with).
    # iex> hash = :crypto.hash(:md5, "banana') # this is us calculating a hash with the md5 algorithm. This will give us back a series of bytes that represent the hashed string "banana".
    # << 114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65>>
    # we can then turn this into a readable string by writing...
    # iex> Base.encore16(hash)
    # "72B302BF297A228A75730123EFEF7C41"
    # so if we compute the hash and then pass it into this function...
    # :binary.bin_to_list(hash) # we get back a series of 15 numbers, the key for generating our image.
    # the first 3 indexes are the RGB values (for the color)
    # the rest of the indexes (if even or odd) will indicate if their corresponding assigned square(s) are colored or not
  end

  def pick_color(image) do
    # pattern matching out of a struct is a bit weird looking. We write out the struct shape (to meet pattern matching dataype requirements) before we assign anything from the actual 'image' struct that gets passed into the function
    %Identicon.Image{hex: hex_list} = image # we're pattern matching a new variable hex_list from the actual data list inside the hex property in the struct to get the value from it
    # we can also pattern match variables right out of the parameter declaration, instead of "def pick_color(image) do", we could "def pick_color(%Identicon.Image{hex: hex_list} = image, anotherArgument) do"
    [r, g, b | _ ] = hex_list # we could've just put "[r, g, b | _ ]" instead of "hex_list" above to save an extra step, as well.
    %Identicon.Image{image | color: {r, g, b}} # we're making a new image struct, takes all the properties off the existing struct (represented by 'image'), and then includes the color property with its new values into the new struct.
   end

   def build_grid(%Identicon.Image{hex: hex} = image) do
     #Enum.chunk(3) takes a list of numbers, and group them into lists inside of a main list (in our case, in groups of 3)
    grid = hex |> Enum.chunk(3) |> Enum.map(fn row -> mirror_row(row) end) |> List.flatten
    |> Enum.with_index # Elixir comprehensions (loops, maps, etc) don't conceptualize indexes, so this function here gives an index to each element by creating tuples with both the value and the index
    # could've also done Enum.map(&mirror_row/1)
    %Identicon.Image{image | grid: grid}
   end
   def mirror_row(row) do
     [first, second | _tail ] = row
     row ++ [second, first]
   end


   def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn {code, _index} -> rem(code, 2) == 0 end # since each tuple we're iterating through holds two values, we destructure / pattern match the first value into a variable called 'code
    %Identicon.Image{image | grid: grid}
   end

end
