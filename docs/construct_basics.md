# 5: Defining the Structure in Construct

As mentioned earlier, Construct is a library designed to work specifically in Python, but it's functionality is similar to the functionality of Kaitai, just with more programmatic language. In Construct, we define `Structs` which are similar to `types` in Kaitai. After describing the structure of a section on the byte level, `Structs` can then be combined with each other to capture larger sections of the data until they're combined in a final `Struct` which captures all of the file's data.

## 5.1 Struct basics

In Construct, a `Struct` is a collection of ordered and (usually) named fields that are then parsed or built in the defined order. The `Struct` can either used to parse a file's data or build a file that matches the file format. When a `Struct` is parsed, values are returned in a dictionary with keys matching the defined names, but names aren't strictly necessary like they are in Kaitai. It's possible to instead build from nothing and return nothing when parsing, so a name can be skipped in those instances. 

Let's recreate our dimension example from the Kaitai section. We can define the `dimensions` `Struct` with:

```
dimensions = Struct(
    "width" / Int16ul,
    "height" / Int16ul
)
```

`Int16ul` here means that we are deciphering the width and height as an **Int**eger of **16** **u**nsigned bits in **l**ittle endian format. To show how that type could then be used elsewhere, we could define another `Struct` using it:

```
example = Struct(
  "dimensions" / dimensions
)
```

## 5.2 Building gif.py

Ok, now let's take a look at how Construct defines a gif from the file [gif.py](https://github.com/construct/construct/blob/master/deprecated_gallery/gif.py) in Construct's github. 

When we look at `gif.py`, we can see that the structure is essentially reversed when compared to Kaitai. All of the smaller, defining fields come first before they're put together into larger `Structs`. This is because the structures in Kaitai are global; the order is arbitrary as long as they're placed in the right sections (`types` or `seq`), while in Construct the structures must be defined in order - one `Struct` can't use another unless the other is already defined. Let's try looking at the file backwards then, starting with the final `Struct` on line 121:

```
gif_file = Struct(
    "signature" / Const(b"GIF"),
    "version" / Const(b"89a"),
    "logical_screen" / gif_logical_screen,
    "data" / GreedyRange(gif_data),
    # Const(Int8ul("trailer"), 0x3B)
)
```

In the `gif_file` `Struct`, we can see that instead of there being a defined `header` `Struct`, we can instead just grab the `signature` and `version` as `Const` (constant) types, which functions much like the `magic` keyword in Kaitai. The only downside to doing it this way as opposed to setting a `Struct` earlier is that it will fail to parse if the version is different than the defined `89a`, instead returning an error. After those, we see: `"logical_screen" / gif_logical_screen`, `"data" / GreedyRange(gif_data)`, and an optional (commented out) `Const(Int8ul("trailer"), 0x3B)`. 

Let's take a look at the `logical_screen` `Struct` which can be found at line 20 to see how it's defined in Construct:

```
gif_logical_screen = Struct(
    "width" / Int16ul,
    "height" / Int16ul,
    "flags" / BitStruct(
        "global_color_table" / Bit,
        "color_resolution" / BitsInteger(3),
        "sort_flag" / Bit,
        "global_color_table_bpp" / BitsInteger(3),
    ),
    "bgcolor_index" / Int8ul,
    "pixel_aspect_ratio" / Int8ul,
    "palette" / If(this.flags.global_color_table,
        Array(lambda this: 2**(this.flags.global_color_table_bpp + 1),
            Struct(
                "R" / Int8ul,
                "G" / Int8ul,
                "B" / Int8ul,
            ))),
)
```

Here we can see that `width` and `height` have the expected definitions, only selecting 2 bytes each, but `flags` is using something called a `BitStruct`. These are much like a normal `Struct`, but designed to operate on bits instead of bytes. In parsing these, the data is converted to a stream of `\x01` and `\x00`s (`1`s and `0`s) and then fed into the substructs. So `global_color_table` grabs just the first bit, `color_resolution` grabs the next 3 bits and parses them as an integer, etc. These values are then used in `palette` if `global_color_table` is `True` (`1`), and an `Array` is constructed with a length determined by raising 2 to the power of `global_color_table_bpp + 1` where each element in the array is another `Struct` defining the RGB values of each pixel.

When we take a look at the next section, `"data" / GreedyRange(gif_data)`, we can see a bit more of how Construct utilizes its nested `Struct`. The `gif_data` `Struct` has a one byte `introducer` field which can either be read (in hex) as `0x21` or `0x2c`. That value is then read by `data` which uses a switch to either use the `extension` type or the `image_descriptor` type respectively depending on `introducer`. The extension type then has another switch which either triggers `application_extension`, `comment_extension`, `graphic_control_extension`, or the `plain_text_extension`, all of which are separately defined `Structs`. While the `image_descriptor` `Struct` is longer, it only uses bytes or BitStructs aside from its final section, `data_sub_block`.

Now that we have some of the basics out of the way regarding describing files in Kaitai and Construct, let's try putting it all together and create a new file format to describe some data!