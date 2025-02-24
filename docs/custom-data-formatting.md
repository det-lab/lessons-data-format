# Custom Data Formatting Lesson
**Created by Adrian Fisher**
# Table of Contents:
- [1. Summary](#1-summary)
- [2. Setup](#2-setup)
    - [2.1 Kaitai Setup](#21-kaitai-setup)
    - [2.2 Construct Setup](#22-construct-setup)
- [3 Understanding Uses](#3-understanding-issues)
    - [3.1 What computers "see"](#31-what-computers-see)
        - [3.1.1 Opening the file in Notepad](#311-opening-the-file-in-notepad)
        - [3.2.1 Exploring the Structure in Kaitai](#321-exploring-the-structure-in-kaitai)
        - [3.2.2 meta and seq](#322-meta-and-seq)
        - [3.2.3 types](#323-types)
# 1. Summary
Kaitai and Construct are both very useful and versatile libraries designed around describing binary data in a way that makes them easier (or possible at all) to work with. It's common in the scientific community to record data in a custom data format which might be unreadable to existing programming languages. While Construct is designed specifically for use with Python, Kaitai can be used to work with data in Python, CSharp, Java, Javascript, Perl, PHP, or Ruby. 
# 2. Setup
Installation isn't strictly necessary for working with Kaitai, but is required for working with Construct.
## 2.1 Kaitai Setup
For Kaitai, the [Web IDE](https://ide.kaitai.io/) is the simplest way to get started. You can jump straight in to describing your data set, ideally after reading through the [documentation](https://doc.kaitai.io/user_guide.html) (of which these instructions are referencing), by simply uploading a file that you intend to parse and creating a new `.ksy` file to describe the data format. 
However, if for any reason you would prefer to avoid the in browser version, you'd instead want to install the desktop/console version, although this isn't necessary (or recommended) for this lesson. For that, the different OS downloads are available [here](https://kaitai.io/#download).
After installation, you should have:
* `ksc` (`kaitai-struct-compiler`) - a command line Kaitai Struct Compiler which translates `.ksy` files into parsing libraries for a chosen target language.
* `ksv` (`kaitai-struct-visualizer`, optional) a console visualizer
## 2.2 Construct Setup
Construct is installable from Pypi, using the standard command-line. There aren't hard dependencies, but all supported modules can be installed as well. You can either run:
* `pip install construct` for the basic installation, or
* `pip install construct[extras]` to install all supported modules.
# 3 Understanding Uses
For this lesson, we're going to start by exploring a file to explain some of the utilities of Kaitai and Construct and what to expect when working with them. To do that, we're going to try opening an understood filetype in an "incorrect" way in order to illustrate what problem these libraries exist to solve. One of the simpler formats to explain in this way is the `GIF` filetype. 
`GIF` stands for "Graphics Interchange Format", and is notable for being able to represent multiple images in a single file, so the filetype is often used for animations. In our example, we're going to explore some different ways to open and read one of these files, as well as what we can do with the files after we read them.
## 3.1 What computers "see"
You can use any `GIF` file to follow along with this lesson, but if you desire to follow along exactly with this lesson, we will be using an image taken from Wikipedia's article on the subject of GIFs:

![Rotating Earth](https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif)

To get an idea of the problems that one might run into when trying to deal with custom data formats, we can treat this image as a raw binary file and try opening the image in a program that wasn't meant to deal with it, such as Notepad, so that we can understand what it is that a computer "sees" without the assistance of programs built to handle our file types.
## 3.1.1 Opening the file in Notepad
When opening an image file with Notepad, the program returns the raw binary version of the data. It's the exact same information as can be found in the above gif, just in a way that is completely opaque to human users. The result is a jumble of numbers, spaces, letters, and symbols, which should look something like:

![gif](/images/gif_txt.png)

Any program capable of opening that image *as* an image is designed to translate all of that binary information into a collection of colored and ordered pixels. This is because, while invisible to us, those bytes contain information such as the width and height of the image, the number of the frames, and the RGB color of every pixel in every frame, as well as metadata. While Kaitai and Construct aren't designed to show you the final animation, they are designed to allow you to translate the binary data into something usable so that you can then use a separate programming language to recreate the final image.

## 3.2.1 Exploring the Structure in Kaitai

Let's try loading this information in the Kaitai Web IDE to understand this better. Start by navigating to the [Web IDE](https://ide.kaitai.io/) if you don't already have it open. 
On the left side of the webpage, you'll see a list of folders, each containing pre-built `.ksy` files which you can use to test functionality. For this example, navigate to `formats/image/gif.ksy`, double clicking `gif.ksy` to load it into the IDE. You should now see a webpage that looks something like:

![IDE](/images/kaitai_ide.png)

The hex viewer on the far right side should look somewhat familiar: it's the same data as before, just with several of the unreadable symbols replaced with `.`s, only showing the typeable characters alongside their hexadecimal representations. If you highlight a specific set of characters on either side of the hex viewer, the corresponding characters will be highlighted on the other side as well, allowing you to see both representations. This is also true for the `object tree`. As you can see, the `hdr` section is selected underneath the `.ksy` file, and the bytes described by the section are selected automatically in the hex viewer.

Luckily, there is extensive documentation provided describing the `GIF` file format. Without a description of the data type that you're trying to parse, this process looks less like declarative programming and more like cryptography, as you would have to personally decipher the purpose of much of the binary data. It's not impossible, just definitely not an ideal or efficient method of programming.

This lesson won't fully describing everything being done in the example `.ksy` file, just the broad strokes. 

## 3.2.2 meta and seq

Your `.ksy` files should always start with a `meta` section, defining the meta-information of your file such as the file extension (`.gif`), titles, licenses, endianness (what byte-order the file should be read in), cross-references, miscellaneous documentation (like lines 17-33 of `gif.ksy`), versions, types, encodings, etc.

The `seq` section is where the declarative work really starts. In `seq`, we can begin to describe how to actually handle the raw data. While it is possible to directly define streams in seq, it's common to declare an `id` which will be the name for a stream of bytes as shown in the object tree, and a `type` which tells the IDE what to do with the data in that section. This is also where it becomes useful to have access to the documentation for your data. This is provided in the `gif.ksy` file for the first time on line 43 for the `glocal_color_table` section, pointing the user to section 18 of the [Cover Sheet for the GIF89a Specification](https://www.w3.org/Graphics/GIF/spec-gif89a.txt). 

The `types` are then executed in the order that they're declared in `seq`, meaning that when reading the raw data of our gif, it'll apply the `header` type until its conditions are fulfilled, then `logical_screen_descriptor_struct`, then `color_table`, and finally `blocks`.

Instead of investigating all four different `types` in the file's `seq`, let's instead look only at the first two: `header` and `logical_screen_descriptor` to get a better idea of how Kaitai operates.

### 3.2.3 Types

While the types as shown in `gif.ksy` (starting from line 48) are generally verbose, the longer descriptions aren't always guarenteed depending on the scope of your project. For instance, if you would expect the first 4 bytes to identify an object's width and height, your type could be settled in the main `seq` fairly simply as:
```
seq:
  - id: width
    type: u2
  - id: height
    type: u2
```
In this example, `u2` could be replaced with `s1`, `s2`, `s4`, `u1`, `u2`, `u4`, etc, where `s` or `u` stands for signed or unsigned bytes, and the number tells the IDE how many bytes to read of that type. We could instead however write this as:
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
The former method is useful for simpler data, while the latter is useful for more complex data, or to consolidate multiple simpler types into a single place. This is useful especially if the type might benefit from using the instructions of a different type.

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
The keyword `magic` is especially useful here as a type of safeguard, acting as a sort of file signature when paired with the `contents` key. It simply checks that the first bytes match up with the contents, "GIF" in this case. It's then followed by `version`, which simply grabs the next 3 bytes as denoted by `size` as a `str` (string) type, and `ASCII` encoding.
This also highlights one of the bigger strengths of Kaitai - its readability. For the most part, it's a very straightforward language.