defmodule Identicon do
  def main(input) do
    input |> hash_input |> pick_color
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
    # :binary.bin_to_list(hash) # we get back a series of 15 numbers, the key for generating an image.
    # the first 3 indexes are the RGB values (for the color)
    # the rest of the indexes (if even or odd) will indicate if their corresponding assigned square(s) are colored or not
  end

  def pick_color(image) do
    # pattern matching out of a struct is a bit different. We write out the data structrue of what we think 'image' is/looks like before we assign anything from 'image' to the variable we make in it
    %Identicon.Image{hex: hex_list} = image # we're pattern matching a new variable hex_list to the actual list inside the hex property in the struct

    [r, g, b | _ ] = hex_list # we could've just put "[r, g, b | _ ]" instead of "hex_list" above to save an extra step
    [r, g, b] # the last variable in a function is what gets returned

   end

end
