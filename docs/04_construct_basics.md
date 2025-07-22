# Defining the Structure in Construct

Construct is a Python library for declaratively describing and parsing binary data formats. Its functionality is similar to Kaitai Struct, but it uses Python code and programmatic constructs. In Construct, you define `Structs` (structures) that describe how to interpret sections of a binary file. These `Structs` can be combined and nested to represent complex file formats, ultimately building up to a main `Struct` that captures the entire file's structure.

## Struct basics

A `Struct` in Construct is a collection of ordered fields, each with a name and a type. Fields are parsed or built in the order they are defined. When parsing, Construct returns a dictionary-like object with keys matching the field names. Unlike Kaitai, field names are optional in Construct, but naming fields makes the resulting data much easier to work with.

Let's recreate the dimensions example from the Kaitai section. Here is how you would define a `width_and_height` `Struct` in Construct:

```python
width_and_height = Struct(
    "width" / Int16ul,
    "height" / Int16ul
)
```

Here, `Int16ul` means an **Int**eger of **16** **u**nsigned bits in **l**ittle-endian format. You can then reuse this `width_and_height` struct in other structures:

```python
dimensions = Struct(
    "w_and_h" / width_and_height
)
```

This modular approach allows you to build up complex file formats from smaller, reusable pieces.

## Building gif.py

Let's look at how Construct can be used to describe the GIF file format, using the [gif.py](https://github.com/construct/construct/blob/master/deprecated_gallery/gif.py) example from Construct's GitHub repository.

Unlike Kaitai, where types can be declared in any order, Python requires that each `Struct` be defined before it is referenced. This means you typically define the smallest components first and then combine them into larger structures. This means that when examining the structure of `Structs`, it often makes sense to start from the final defined `Struct` to see what building blocks it uses.

Here is the top-level `gif_file` struct, which represents the entire GIF file:

```python
gif_file = Struct(
    "signature" / Const(b"GIF"),
    "version" / Const(b"89a"),
    "logical_screen" / gif_logical_screen,
    "data" / GreedyRange(gif_data),
    # "trailer" / Const(0x3B, Int8ul)  # Optional: GIF file terminator
)
```

- `Const(b"GIF")` and `Const(b"89a")` ensure the file starts with the correct signature and version, similar to the `magic` keyword in Kaitai. However, this also means it will fail to parse if the version number is anything other than `89a`.
- `logical_screen` and `data` are parsed using other structs defined above `gif_file`.
- `GreedyRange(gif_data)` repeats the `gif_data` struct until the end of the file.

Now, let's look at the `gif_logical_screen` struct:

```python
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
            )
        )
    ),
)
```

- `BitStruct` allows you to parse individual bits within a byte, which is useful for fields like `flags` that pack multiple values into a single byte.
- The `palette` field is only present if `global_color_table` is `True`. Its length is determined by the value of `global_color_table_bpp`.

The `data` section of the GIF file is parsed using a combination of `Struct`, `Switch`, and `GreedyRange`:

```python
gif_data = Struct(
    "introducer" / Int8ul,
    "data" / Switch(this.introducer, {
        0x21: extension,
        0x2C: image_descriptor,
    })
)
```

- The `introducer` byte determines whether the next section is an extension or an image descriptor.
- `Switch` selects the appropriate struct based on the value of `introducer`.
- Each of these sub-structs (`extension`, `image_descriptor`) is defined elsewhere in the file.

As mentioned earlier, having `GreedyRange(gif_data)` in the top-level struct repeats this process for each data block in the file, allowing Construct to parse the entire sequence of GIF blocks.

This modular, programmatic approach makes Construct powerful for describing binary formats in Python. While Kaitai uses a declarative YAML-based syntax, Construct leverages Python's syntax and logic, which can be more flexible for complex parsing tasks.

---

Now that you have seen how to describe file formats in both Kaitai and Construct, the next step is to create your own custom data format and try parsing it using these tools. Continue to the next section to learn how to generate and work with example data.

---
Continue to [Creating Example Data](05_creating_example_data.md) to generate and save your own binary data.