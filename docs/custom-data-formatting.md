# Custom Data Formatting Lesson
**Created by Adrian Fisher**
# Table of Contents:
- [1. Summary](#1-summary)
- [2. Setup](#2-setup)
    - [2.1 Kaitai Setup](#21-kaitai-setup)
    - [2.2 Construct Setup](#22-construct-setup)
- [3 Introduction: What is a filetype?](#3-introduction-what-is-a-filetype)
    - [3.1 Opening a file wrong](#31-opening-a-file-wrong)
- [4 Exploring the Structure in Kaitai](#4-exploring-the-structure-in-kaitai)
      - [4.1 meta and seq](#41-meta-and-seq)
      - [4.2 Types](#42-types)
# 1. Summary
It's common in the scientific community to record data in a custom format which might be unreadable to existing programming languages. This means that in the processes of data analysis, it can be necessary to create and describe a new filetype. This lesson will be exploring how Kaitai and Construct can be used to translate one's custom binary data in a way that makes it easier to work with. Construct is designed specifically for use with the Python programming language, while Kaitai can be used to work in Python, CSharp, Java, Javascript, Perl, PHP, or Ruby. 
# 2. Setup
Installation isn't strictly necessary for working with Kaitai, but is required for working with Construct.
## 2.1 Kaitai Setup
For Kaitai, the [Web IDE](https://ide.kaitai.io/) is the simplest way to get started. You can jump straight in to describing your data set, ideally after reading through some of the [documentation](https://doc.kaitai.io/user_guide.html) of which these instructions are referencing. You can directly upload a file that you wish to parse and create a new `.ksy` file to describe the data format. 

If for any reason you would prefer to avoid the in browser version, you could instead install the desktop/console version, although this isn't necessary or recommended for this lesson. The different OS downloads are available [here](https://kaitai.io/#download).

After installation, you should have:
* `ksc` (`kaitai-struct-compiler`) - a command line Kaitai Struct Compiler which translates `.ksy` files into parsing libraries for a chosen target language.
* `ksv` (`kaitai-struct-visualizer`, optional) a console visualizer
## 2.2 Construct Setup
Construct is installable from Pypi, using the standard command-line. There aren't hard dependencies, but all supported modules can be installed as well. You can either run:
* `pip install construct` for the basic installation, or
* `pip install construct[extras]` to install all supported modules.
# 3 Introduction: What is a filetype?
While it's easy to say that a `.jpg` "is a picture", a `.gif` "is an animation", or a `.txt` "is a text document" let's back up and think about how data is stored on a computer and translated into something that we can read and understand. 

While humans have pretty familiar systems in place now for interacting with computers, it's important to remember that we interact with computers through several layers of culturally specific translations, abstractations, and conveniences that exist as barriers between our world of symbols and the laws of electromagnetism. Humans have spent much of the last century learning to shape metals and electricity into processing units and graphics cards which can deliver us images of "cats" and graphs of "the economy". *Every* filetype is a custom filetype that someone, somewhere, had to teach a computer to interpret. 

Let's say you want to take some data using an existing filetype, such as `.txt`. When you type a character on your keyboard, the mechanical action presses conductive material into place against a complex printed circuit laying underneath the key, allowing for a current to flow through a distinct path. The current will then enter the microcontroller, the "brain" of the keyboard, where the resulting signal is converted into a binary representation of `1`s and `0`s. However, this familiar numerical representation is an abstraction used to explain the physical system comprised of transistors and capacitors which exist inside of memory cells. 

The circuit completed by the key press allows for electricity to charge a series of capacitors in your computer's memory cells. When a capacitor is charged, we call it a `1`, and when it is discharged, we call it a `0`. This series of charged and uncharged cells is then held and written from a specific location inside of the RAM chip until the file is saved, at which point it is written onto the computer's hard drive. Even if you save something on the cloud, it is still a string of information stored physically by some computer server somewhere.

It's in this way that `a` becomes `01100001`. Each character you can type is represented by a `byte` 8 digits long. This also means that one byte can represent any value between `00000000` and `11111111` (or 0-256 in decimal representation). Still, `01100001` is essentially just a number: `97` when represented in decimal form. It's only through UTF-8 encoding that when you open your `.txt` file in Notepad, it knows to represent `01100001` as `a`. But Notepad doesn't have the instructions to open every filetype, and will give some illustrative results if you use it to try and open non-text files.

## 3.1 Opening a file wrong

Let's see what happens when we try to open a filetype that Notepad wasn't written for: `.gif`. This one is taken from Wikipedia's article on the subject of GIFs:

![Rotating Earth](https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif)

`GIF` stands for "Graphics Interchange Format", and is notable for being able to represent multiple images in a single file, so the filetype is often used for animations. 

When opening the file with Notepad, the program returns the data as encoded in UTF-8. It's the exact same information as can be found in the above gif, just in a way that is completely unreadable to human users. The result is a jumble of numbers, spaces, letters, and symbols, which should look something like:

![gif](/images/gif_txt.png)

You might notice in that collection of seemingly random symbols that some legible words stand out, such as the first 3 letters, "GIF", and further down on the left side you can find "NETSCAPE2.0".

A program which was designed to open that file has instructions to use those bytes to assigns values to the width and height of a window in which to draw the image, the number of the frames that the image will be drawn on, and the RGB color of every pixel in every frame, as well as metadata.

While Kaitai and Construct aren't designed to show you the final animation, they are designed to allow you to translate the raw data into something usable so that you can then load all of that information elsewhere.

## 4 Exploring the Structure in Kaitai

Let's try loading this information in the Kaitai Web IDE to understand this better. Start by navigating to the [Web IDE](https://ide.kaitai.io/) if you don't already have it open. 
On the left side of the webpage, you'll see a list of folders, each containing pre-built `.ksy` files which you can use to test functionality. For this example, navigate to `formats/image/gif.ksy`, and double click `gif.ksy` to load it into the IDE. Then, click the upload button on the bottom left to navigate to your `.gif` file and load it here. You should now see a webpage that looks something like:

![IDE](/images/kaitai_ide.png)

The hex viewer on the far right side should look somewhat familiar: it's the same data as when the file was opened in Notepad, now just with several of the unreadable symbols replaced with `.`s instead of Notepad's `` symbol, showing the typeable characters alongside their hexadecimal representations. If you highlight a specific set of characters on either side of the hex viewer, the corresponding characters will be highlighted on the other side as well, allowing you to see both representations. This is also true for the `object tree`. As you can see, the `hdr` section is selected underneath the `.ksy` file, and the bytes described by the section are selected automatically in the hex viewer.

Luckily, there is extensive documentation provided describing the `GIF` file format. Without a description of the data type that you're trying to parse, this process looks less like declarative programming and more like cryptography, as you would have to personally decipher the purpose of much of the binary data. It's not impossible, just definitely not an ideal or efficient method of programming.

This lesson won't fully describing everything being done in the example `.ksy` file, just the broad strokes. 

## 4.1 meta and seq

Your `.ksy` files should always start with a `meta` section, defining the meta-information of your file such as the file extension (`.gif`), titles, licenses, endianness (what byte-order the file should be read in), cross-references, miscellaneous documentation (like lines 17-33 of `gif.ksy`), versions, types, encodings, etc.

The `seq` section is where the declarative work really starts. In `seq`, we can begin to describe how to actually handle the raw data. While it is possible to directly define streams in `seq`, it's necessary to declare an `id` which will be the name shown in the object tree for a given attribute. You can also specify information such as a `type`, which tells the IDE what to do with the data in that section, a `size` which states the number of bytes for the `id` object to capture, `content` can be specified for `magic` signatures, and `encoding` can also be set here. This is also where it becomes handy to have access to the documentation for your data. 

Documentation is provided in the `gif.ksy` file for the first time on line 43 for the `glocal_color_table` section, pointing the user to section 18 of the [Cover Sheet for the GIF89a Specification](https://www.w3.org/Graphics/GIF/spec-gif89a.txt).

The `types` are then executed in the order that they're declared in `seq`, meaning that when reading the raw data of our gif, it'll apply the `header` type until its conditions are fulfilled, then `logical_screen_descriptor_struct`, then `color_table`, and finally `blocks`.

Instead of investigating all four different `types` in the file's `seq`, let's instead look only at the first two: `header` and `logical_screen_descriptor` to get a better idea of how Kaitai operates.

### 4.2 Types

While it takes almost 150 lines of code to describe the types in `gif.ksy` (from line 48-197), the longer descriptions aren't always guaranteed depending on the scope of your personal project. For instance, if you would expect the first 4 bytes to identify an object's width and height, your type could be settled in the main `seq` fairly simply as:
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
The former method is useful for simpler data, while the latter is useful for more complex data. It allows you to consolidate multiple simpler types into a single place, repeat types, or use types to describe other types.

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
```