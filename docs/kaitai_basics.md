# 4: Defining the Structure in Kaitai

Let's try loading the GIF file in the Kaitai Web IDE to understand this better. Start by navigating to the [Web IDE](https://ide.kaitai.io/) if you don't already have it open. 

## 4.1 Anatomy of the Web IDE

On the left side of the webpage, you'll see a list of folders, each containing pre-built `.ksy` files which you can use to test functionality. For this example, navigate to `formats/image/gif.ksy`, and double click `gif.ksy` to load it into the IDE. The buttons on the bottom left of the webpage are for creating new `.ksy` files, uploading `.ksy` or data files, and saving `.ksy` files respectively:

![buttons](/images/kaitai-icons.png)
```
New, Upload, Save
```

Click the upload button to select a `.gif` file from your computer and load it here. You should now see a webpage that looks like:

![IDE](/images/kaitai_ide.png)

The viewer on the far right side should look somewhat familiar: it's the same data as when the file was opened in Notepad, now just with several of the unreadable symbols replaced with `.`s instead of Notepad's `` symbol, showing the typeable characters alongside their hexadecimal representations. 

If you click to highlight specific characters or sets of characters on either side of the `hex viewer`, the corresponding characters will be highlighted on the other side as well, allowing you to see both the hex code and UTF-8/ASCII representations for any selection. This is also true for the `object tree` section. By clicking on an item in the `object tree` underneath the `.ksy` file such as the `hdr` section, the bytes described by the section are automatically selected in the `hex viewer`. 

In the same window as the `hex viewer` are the `JS Code` and `JS Code (debug)` sections. These show how the `.ksy` file is being translated in the `JavaScript` programming language alongside a debugger.

The `converter` section on the bottom right of the screen provides multiple different possible ways to convert selected characters. These show different methods of translating a hex code as an integer, such as `i8`, which is an 8-bit integer, `i16le` which is a 16-bit integer in `little endian` format, and so on. 

Finally, there is the `info panel` which provides information about a selection of bytes, such as the length of the selection and where in the data stream the selection is.

If you are interested in following along more precisely with the `gif.ksy` file, there is also extensive documentation provided to describe the file format. Having documentation about the file format is crucial for describing your file type. Without documentation to follow, this process looks less like declarative programming and more like cryptography, as you would have to decipher the purpose of much of the binary data unless it happens to be written in plain text already. It's not impossible, just definitely not an ideal or efficient method.

We won't fully describe everything being done in the example `.ksy` file here, instead we are just going to look at a broad overview to give an idea of how to use the program. Now that we know what we're looking at in the IDE, we can take a look at how the file type is being described.

## 4.2 meta and seq

Your `.ksy` files should always start with a `meta` section, defining the meta-information of your file type such as the file extension (like `.gif` or `.tiff`, etc), titles, licenses, endianness (what byte-order the file should be read in), cross-references, miscellaneous documentation (like lines 17-33 of `gif.ksy`), versions, types, encodings, etc.

The `seq` section is where the declarative work really starts. In `seq`, we can begin to describe how to handle the raw data. While it is possible to directly define streams in `seq`, it is necessary to first declare an `id` which will be the name shown in the object tree for any given attribute. You can also specify information such as a `type`, which tells the IDE what to do with the data in that section, a `size` which states the number of bytes for the object to capture, `content` can be specified for `magic` signatures, `encoding` choice can be determined here, etc.

The `types` are then executed in the order that they're declared in `seq`, meaning that when reading the raw data of our gif, it'll apply the `header` type until its type conditions are fulfilled, then `logical_screen_descriptor_struct`, then `color_table`, and finally `blocks`. If for some reason any of the type conditions are unable to be fulfilled, the IDE will interrupt parsing and display an error message underneath the object tree.

Instead of investigating all four different `types` in the file's `seq`, let's instead look only at the first two: `header` and `logical_screen_descriptor` to get a better idea of how Kaitai operates.

## 4.3 Types

The `types` section is where it becomes vital to reference documentation around the file type you're trying to parse. A link to the documentation is provided in the `gif.ksy` file for the first time on line 43 for the `glocal_color_table` section, pointing the user to section 18 of the [Cover Sheet for the GIF89a Specification](https://www.w3.org/Graphics/GIF/spec-gif89a.txt).

While it takes around 150 lines of code to full describe the types in `gif.ksy` (from line 48-197), longer descriptions aren't always necessary depending on the scope of your project. For instance, if you would expect the first 4 bytes to identify an object's width and height, your type could be settled quickly in the main `seq` section without ever having to create a type description, as:
```
seq:
  - id: width
    type: u2
  - id: height
    type: u2
```
In this example, `u2` could be replaced with `s1`, `s2`, `s4`, `u1`, `u2`, `u4`, etc, where `s` or `u` stands for signed or unsigned bytes, and the number tells the IDE how many bytes to read of that type. However, if we knew that we would later need to grab a different width and height for some reason, we could instead write this as:
```
seq:
  - id: dimensions
    type: width_and_height

...

types:
  width_and_height:
    seq:
      - id: width
        type: u2
      - id: height
        type: u2
```
The former method is useful for simple, straightforward data, while the latter is useful for describing repetitive data structures or for reusing types. It allows you to consolidate multiple types into a single place, to repeat types, or to use certain types in the definitions of other types.

When looking at `gif.ksy`'s `header` type, we see:
```
  header:
    doc-ref: https://www.w3.org/Graphics/GIF/spec-gif89a.txt - section 17
    seq:
      - id: magic
        contents: 'GIF'
      - id: version
        type: str
        size: 3
        encoding: ASCII
```
The keyword `magic` is especially useful here as a type of safeguard, acting as a file signature when paired with the `contents` key. It simply checks that the first bytes match up with the contents, "GIF" in this case. The `magic` id is then followed by `version`, which simply grabs the next 3 bytes as denoted by `size` using the built in `str` (string) type, and specifies that it is using `ASCII` encoding.

This also highlights one of the bigger strengths of Kaitai - its readability. For the most part, it's a very straightforward language.
This strength is also apparent in the next type, `logical_screen_descriptor_struct`:
```
  logical_screen_descriptor_struct:
    doc-ref: https://www.w3.org/Graphics/GIF/spec-gif89a.txt - section 18
    seq:
      - id: screen_width
        type: u2
      - id: screen_height
        type: u2
      - id: flags
        type: u1
      - id: bg_color_index
        type: u1
      - id: pixel_aspect_ratio
        type: u1
    instances:
      has_color_table:
        value: '(flags & 0b10000000) != 0'
      color_table_size:
        value: '2 << (flags & 7)'
```

As you can see, it simply grabs the width and the height of the screen on which the gif will be drawn as 2 unsigned bytes, followed by three unsigned bytes that describe the `flags`, `bg_color_index`, and `pixel_aspect_ratio`. 

### 4.3.1 Instances

After the `id`s are set in the type `seq`, we then see an `instances` section. This section is setting new variables by manipulating the previously found `flags` object using Kaitai's expression language. 

```value: '(flags & 0b10000000) !=0'``` is doing something called "bit masking"; taking the bits from the `flag` byte and showing only the first one. The beginning `0b` simply means to read the `flags` object as bytes for the masking, then the `1` means the first bit is allowed through while the rest are masked with `0`, so are blocked from being read. The value is set as `True` or `False` depending on if the first bit is NOT (`!=`) equal to 0. This is a boolean operation - either the gif does or does not have a color table, which is revealed by the first bit in the `flags` byte. 

This is a good time to mention that `bytes` are not some kind of fundamental unit of computation. The choice to have 8 bits in one byte was a decision made by the International Organization for Standardization (ISO) and the International Electrotechnical Commmission (IEC) in 1993, but 6 and 9 bit bytes were common through the 1960s. Bit masking can allow for one to use every individual bit or combination of bits in a selection to correspond to a different value. In this way, one can surpass some of the artificially imposed limits on computation.

`color_table_size` is doing a similar operation but with different syntax. `7` in binary is `00000111`, so ```(flags & 7)``` is selecting the final 3 bits. `2` in binary is `00000010` - `<<` is the command to shift bits to the left, so that command shifts 2 to the left by `flags & 7` places. This is equivalent to raising 2 to the power of `1+(flags mod 8)` and then assigning that new value to a character.

In our case, `flags` = 247, or `11110111`, so `has_color_table = True`, and `1+(flags mod 8) = 8`, $2^8 = 256$, so `color_table_size = 256`

All of this section has been to explain, in broad strokes, some of the types as shown in the `GIF` file type. If you're interested in reading more about Kaitai Struct Language, the full documentation can be found [here](http://doc.kaitai.io/user_guide.html#_kaitai_struct_language). For now, let's continue this lesson and talk about how this same file type definition can be done with the Construct library.