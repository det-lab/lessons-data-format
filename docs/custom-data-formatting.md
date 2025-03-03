# Custom Data Formatting Lesson
**Created by Adrian Fisher**
# Table of Contents:
- [1. Summary](#1-summary)
- [2. Setup](#2-setup)
    - [2.1 Kaitai Setup](#21-kaitai-setup)
    - [2.2 Construct Setup](#22-construct-setup)
- [3. Introduction: What is a filetype?](#3-introduction-what-is-a-filetype)
    - [3.1 Computer language and number systems](#31-computer-language-and-number-systems)
      - [3.1.1 Counting in binary and hexadecimals](#311-counting-in-binary-and-hexadecimals)
    - [3.2 Opening a file wrong](#32-opening-a-file-wrong)
- [4. Exploring the Structure in Kaitai](#4-exploring-the-structure-in-kaitai)
    - [4.1 meta and seq](#41-meta-and-seq)
    - [4.2 Types](#42-types)

# 1. Summary
It's common in the scientific community to record data in a custom format which might be unreadable to existing programming languages. This means that in the processes of data analysis, it can be necessary to create and describe a new filetype. This lesson will be exploring how Kaitai and Construct can be used to translate one's custom binary data in a way that makes it easier to work with. Construct is designed specifically for use with the Python programming language, while Kaitai can be used to work in Python, CSharp, Java, Javascript, Perl, PHP, or Ruby. 
# 2. Setup
Installation isn't strictly necessary for working with Kaitai, but is required for working with Construct.
## 2.1 Kaitai Setup
For Kaitai, the [Web IDE](https://ide.kaitai.io/) is the simplest way to get started. You can jump straight in to describing your data set, ideally after reading through some of the [documentation](https://doc.kaitai.io/user_guide.html) of which these instructions are referencing. You can directly upload a file that you wish to parse and create a new `.ksy` file to describe it. 

If for any reason you would prefer to avoid the in browser version, you could instead install the desktop/console version. The desktop and console versions can also be used when you're done using the Web IDE to compile the file for other programming languages. The different OS downloads are available [here](https://kaitai.io/#download).

After installation, you should have:
* `ksc` (`kaitai-struct-compiler`) - a command line Kaitai Struct Compiler which translates `.ksy` files into parsing libraries for a chosen target language.
* `ksv` (`kaitai-struct-visualizer`, optional) a console visualizer
## 2.2 Construct Setup
Construct is installable from Pypi, using the standard command-line. There aren't hard dependencies, but all supported modules can be installed as well. You can either run:
* `pip install construct` for the basic installation, or
* `pip install construct[extras]` to install all supported modules.
# 3 Introduction: What is a filetype?
While it's easy to say that a `.jpg` "is a picture", a `.gif` "is an animation", or a `.txt` "is a text document" let's back up and think about how data is stored on a computer and translated into something that we can read and understand. 

While humans have pretty familiar systems in place now for interacting with computers, it's important to remember that we interact with computers through several layers of culturally specific translations, abstractations, and conveniences that exist as barriers between our world of symbols and the laws of electromagnetism. Humans have spent much of the last century learning to shape metals and electricity into these incredibly complex devices which we call things like "processing units" and "graphics cards". These tools can then deliver us images of "cats" and graphs of "the economy" when they're combined with a monitor of some kind. The point being that *every* filetype is a custom filetype which someone, somewhere, had to teach a computer to interpret. As file types become more niche and specific to a project, it then becomes someone else's job to create a description that will allow a computer to be able to read a string of `1`s and `0`s and return something that humans can understand again. 

## 3.1 Computer language and number systems

That string of `1`s and `0`s mentioned earlier - where do they come from, anyway? What do people mean when they say that our computers "think" or "read" in binary?

Let's say you want to take some data using an existing filetype, such as writing your results down in a `.txt` document. When you type a character on your keyboard, the mechanical action presses conductive material into place against a complex printed circuit laying underneath the key, allowing for a current to flow through a distinct path. The current will then enter the keyboard's microcontroller, its "brain", where the resulting signal is converted into a binary representation of `1`s and `0`s. However, even this familiar numerical representation is a convenient abstraction used to explain the physical system comprised of transistors and capacitors which exist inside of a computer's memory cells.

The circuit completed by pressing a key on a keyboard allows for electricity to flow from a power source and throughout different systems in your computer, eventually charging a series of capacitors in its memory cells. When a capacitor is charged, we call it a `1`, and when it's discharged, we call it a `0`, representing the binary states available to it of charged and uncharged. The series of charged/uncharged cells is then held and written from a specific location inside of the computer's RAM chip until the file is saved, at which point it is moved onto the computer's hard drive. Even if you save something on what has become known as "the cloud", it still must stored physically on a set of capacitors by some computer server somewhere. Normally, if you're paying for a "cloud" service, the servers are owned and operated by the company which you are paying, hopefully with layers of encryption and security to protect your data.

It's in this way that the typed character `a` gets translated into the binary representation `01100001`. Each character's binary representation can also be said to represent where in your computer's systems a current was and wasn't allowed to pass through specific paths. Each character one can type is thus represented by a `byte`, a number 8 digits long as represented in the binary numerical system. As binary is a base 2 counting system, this means that one byte can represent any value between `00000000` and `11111111`, or 0-256 in decimal representation.

Ok, but what is a "base 2" counting system?

# 3.1.1 Counting in binary and hexadecimals

To understand counting systems, remember that the number system humans are used to is derived almost solely from the fact that our species happens to have 10 fingers. As a result, in our number system the number "3125" could be interpreted as there being a 3 in the "thousands" or $10^3$ place, a 1 in the "hundreds" or $10^2$ place, a 2 in the "tens" or $10^1$ place and a 5 in the "ones" or $10^0$ place, so: $$3125 = (3 \cdot 10^3) + (1 \cdot 10^2) + (2 \cdot 10^1) + (5 \cdot 10^0)$$

The same is true for a binary counting system, only instead of the places being determined by powers of 10, they're instead determined by powers of 2. Binary is pretty simplistic as such, as any 1 or 0 simply means that there is or isn't a number in that place. So `01100001` becomes: $$(0 \cdot 2^7) + (1 \cdot 2^6) + (1 \cdot 2^5) + (0 \cdot 2^4) + (0 \cdot 2^3) + (0 \cdot 2^2) + (0 \cdot 2^1) + (1 \cdot 2^0)$$

Which when represented in decimal (base 10) becomes 97. As every byte is 8 digits long, this means that any byte can represent a value between `00000000` and `11111111`, or 0-256 in decimal representation. However, another common numerical system that one should be familiar with when working with raw binary data is hexadecimals. While binary shortens the number of allowed digits to 2, 0 & 1, hexadecimals is a base 16 counting system, extending our usual 1st digit options from 0-9 to include A-F, where A = 10, B = 11, ..., F = 15.

It's only through UTF-8 encoding that when you open your `.txt` file in Notepad, it knows to represent `01100001` as `a`. But Notepad doesn't have the instructions to open every filetype, and will give some illustrative results if you use it to try and open non-text files.

## 3.2 Opening a file wrong

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