# 6: Putting it all together

Now that we have the basics down, let's try putting it all together. To do this, let's fabricate some data, save that data in a binary file, and then define the structure for that data in both Kaitai and Construct. After that, we can compile our formats and begin to manipulate and work with this data.

## 6.1 Creating example data

Let's say that the data that we're taking comes as a waveform in a binary file. We can pretend that we're measuring vibrations through some material or that we're measuring light intensity in some complex electrical system. As we're fabricating data, not actually measuring it, the justification is immaterial. 

For this example we'll be working in Python, simply because it is necessary for Construct. If you would prefer to follow along using a different programming language, that shouldn't cause any issues as long as the Construct description is written using Construct. If you don't already have an IDE installed, simply follow the link in section [2.2 Python Setup](#22-python-setup) to install Spyder.

Let's say that we want to break our data into 3 different sections depending on the intensity. The first section can describe the entire wave form, the second can capture only the mid-range values, and the third section captures only the most intense values. 

First, we'll need to make sure that all of the necessary libraries are installed and imported. For this data, we'll need the numpy library and the struct (not Construct) library. Optionally, we can also include matplotlib in order to plot our simulated data. To check if you already have these libraries installed, open your IDE's terminal and enter:
```
pip list
```
This will return an alphabetical list of all modules currently installed packages/modules that your install of Python has access to, as well as their version numbers. Simply scroll through the result to see if `matplotlib`, `numpy`, and `python-struct` are installed, and if not, run:
```
pip install numpy
pip install matplotlib
pip install python_struct
```

You should now be free to create a new `.py` or `.ipynb` file, named whatever you'd prefer. You will have to save the file before most IDEs will allow you to run the file. 

At the beginning of your new file, import the necessary modules using the commands:
```
import numpy as np
import struct
import matplotlib.pyplot as plt
```
Now, let's define 6 different arrays, one for each x and y value that is being selected from each different section. The x-axis is only useful here if you also plan on plotting the data:
```
full_x = []
full_y = []

mid_x = []
mid_y = []

peak_x = []
peak_y = []
```
Next, we'll want to populate these arrays with their respective data. Let's create a `for loop` which will create a wave using an equation. For this example, I'll be creating a function that is defined from `x=-5` to `x=5`, creating a point every time x increases by `0.0001`, meaning the full data will contain 100000 points. The actual function chosen for this example doesn't matter much as long as it's possible to graph in two dimensions - you can simply plot a cosine or sin function with arbitrary limits without running into any issues (as long as your computer can handle the amount of data points):
```
for i in np.arange(-5,5,0.0001):
  n = (np.cos((2 * np.pi * i**2)/(i**2 + i))) * np.sin(i)

  # Put every calculated point in full_x and full_y
  full_x.append(i)
  full_y.append(n)

  # Select only mid range points
  if n**2 < 0.3:
    mid_x.append(i)
    mid_y.append(n)

  # Select only extrema
  if n**2 > 0.65:
    peak_x.append(i)
    peak_y.append(n)
```
You could now plot the three graphs if you wish to see what these produce by using:
```
plt.scatter(full_x, full_y, s=1)
plt.show()

plt.scatter(mid_x, mid_y, s=1)
plt.show()

plt.scatter(peak_x, peak_y, s=1)
plt.show()
```
The resulting graphs should look like:

![full](/images/full-graph.png)
![mid](/images/mid-graph.png)
![peak](/images/peak-graph.png)

Next, we'll want to load all of our wave data into separate arrays. This way, we'll be able to also record the length of each array for a later step. In order for the data to come back as useable, we'll also want to make sure that it's being written using `float` values, as opposed to integers. If we accidentally saved it as an integer instead, every value would be rounded to either -1, 0, or 1. Creating each of these arrays looks like:
```
# Use datatype to create arrays of data
full_data = np.array(full_y, dtype=np.float32)
mid_data = np.array(mid_y, dtype=np.float32)
peak_data = np.array(peak_y, dtype=np.float32)
```
The next and final step of creating our example data is to write everything we've done so far to a new `.test` file. As mentioned earlier, it is vital to include the length of each section somewhere in our final file. By storing the size of each array as a value, we can avoid having to calculate it by hand or having to eyeball where one section ends and another begins in the data. It's simplest to include the length at the beginning of the file, although there are multiple different ways you could manage this step. For instance, you could instead put a character such as "x" at the beginning or end of every section, and then use that as a marker to show when the section ends. You could put the length of each section before the corresponding section instead of all at once at the front. The deeper your understanding of Kaitai and Construct, the more options are open to you for this step. For the sake of simplicity, here's what it looks like to put the lengths at the beginning of the file:
```
with open('wave_data.test', 'wb') as f:
  # Provide lengths of each array
  f.write(struct.pack('I', len(full_data)))
  f.write(struct.pack('I', len(mid_data)))
  f.write(struct.pack('I', len(peak_data)))
  # Write each array onto the file
  full_data.tofile(f)
  mid_data.tofile(f)
  peak_data.tofile(f)
```
We now have a file titled "wave_data.test" saved in the same directory as our python program. The file type can be decided arbitrarily - it used to be the case that type extensions were required to be 3 characters or less, but that standard has since fallen out of use.

## 6.2 Describing the data in Kaitai

Now that we have our raw "experiment" data, we can begin working on writing the `.ksy` file which we'll be able to use later to compile our data into something useable. If you no longer have it open, navigate back to the [Kaitai web IDE](https://ide.kaitai.io/) and create a new `.ksy` file named something like "wave_parser.ksy". We're going to start by describing the `meta` section. Our example is pretty simple, so we'll only need to fill out the `id`, `file-extension` and `endian` sections. 

Since we didn't explicitly define the endianness while creating our raw data file, it was written using your operating system's native endianness. If you are unsure what endianness your system uses, simply search "(your OS) byte order." You could also rewrite the code generating the example data to force a specific endianness. To do that, change the lines which create the arrays from:
```
full_data = np.array(full_y, dtype=np.float32)
mid_data = np.array(mid_y, dtype=np.float32)
peak_data = np.array(peak_y, dtype=np.float32)
```
To instead say:
```
# For little-endian
full_data = np.array(full_y, dtype='<float32') # or '<f4'
mid_data = np.array(mid_y, dtype='<float32')
peak_data = np.array(peak_y, dtype='<float32')

# For big-endian
full_data = np.array(full_y, dtype='>float32') # or '>f4'
mid_data = np.array(mid_y, dtype='>float32')
peak_data = np.array(peak_y, dtype='>float32')
```

Now in our `meta` section, let's add:
```
meta:
  id: test
  file-extension: test
  endian: le # or be
```
When creating our file, we used the line `f.write(struct.pack('I', len(full_data)))` to add the size of each section to the beginning of the file. In this line `I` stands for an unsigned 4-byte integer. In Kaitai, this is captured by `type: u4`, so we define a `type` called `full_mid_peak_lens` which grabs `full_len`, `mid_len`, and `peak_len` as `u4`s so that they can be used elsewhere.
```
types:
  full_mid_peak_lens:
    seq:
      - id: full_len
        type: u4
      - id: mid_len
        type: u4
      - id: peak_len
        type: u4
```
Now we can go above the `types` section to the main `seq` and create an object to store these lengths so that we can retrieve them later:
```
seq:
  - id: lengths
    type: full_mid_peak_lens
```
And finally, we can use these lengths to capture the data from each section in the main `seq` without spilling anything we want to capture into the wrong section. Remember: each value was saved in 4 bytes, and the `size` statement only captures one byte at a time. So if we were to try something like:
```
  - id: full_data
    size: lengths.full_len
```
We would select only a quarter of the necessary bytes. Instead, we'll have to use a repeat expression alongside setting the type to `u4` to accurately select our data. This looks like:
```
  - id: full_data
    type: u4
    repeat: expr
    repeat-expr: lengths.full_len
    
  - id: mid_data
    type: u4
    repeat: expr
    repeat-expr: lengths.mid_len
    
  - id: peak_data
    type: u4
    repeat: expr
    repeat-expr: lengths.peak_len
```

And just like that, we've described our first file format using Kaitai! Make sure to save your file, and we can move on to using our .ksy file to parse the raw data into something useable.

## 6.3 Parsing raw data with a .ksy file

## 6.4 Describing the data in Construct

If for some reason it's useful for your project to create a description of your file format using both Kaitai and Construct, I'd recommend first creating a Kaitai description and then basing your Construct file off of it, simply because the syntax for Kaitai is much more straightforward. With that being said, let's open up a new `.py` or `.ipynb` file and begin by importing the Construct module, matplotlib.pyplot (in order to later graph our arrays), and numpy (to help with graphing our arrays) before defining our Structs. 
```
from construct import *
import matplotlib.pyplot as plt
import numpy as np
```
Next, as before, we'll want to capture the three numbers at the front of the file which tell us how long each array is. Our approach here will look much like our Kaitai version, but there are still multiple different ways to perform this capture, and experimenting to see what feels most efficient for you is definitely encouraged. 

For this example, I'm going to start off with what will eventually be the final Struct and create a sub Struct which will capture the lengths.
```
test_struct = Struct(
  "lengths" / Struct(
    "full_data_len" / Int32ul,
    "mid_data_len" / Int32ul,
    "peak_data_len" / Int32ul
  )
)
```
As mentioned previously, this Struct will come last. This is a limitation of Python more than of Construct, as Python is unable to use variables or Structs that have yet to be declared. But since the Struct that comes before this one will only be **used** when it's later nested into `test_struct`, we'll be able to reference the `lengths` Struct to capture the full, mid, and peak data sections. Each of the data sections will select 4 bytes at a time and save them into an array of the stated length.
```
data_sections = Struct(
    "full_data" / Array(
        this._root.lengths.full_data_len,
        Float32l
    ),
    "mid_data" / Array(
        this._root.lengths.mid_data_len,
        Float32l
    ),
    "peak_data" / Array(
        this._root.lengths.peak_data_len,
        Float32l
    )
)
```
Now we can simply add this Struct into `test_struct` as:
```
test_struct = Struct(
    "lengths" / Struct(
        "full_data_len" / Int32ul,
        "mid_data_len" / Int32ul,
        "peak_data_len" / Int32ul
    ),
    "data_sects" / data_sections
)
```
It's important to note that `lengths` and `data_sects` will be the ways we'll select the data captured when writing our Python code to recreate our graphs. For selections that only have one defining Struct, like `data_sects`, there isn't really a reason not to also name the sub Struct (`data_sects`) after the Struct that it's using (`data_sections`). In this case, it's simply a matter of shortening the name to reduce how much typing is necessary to reference that data. It's not uncommon to have a Struct with a very clear name which is then given a shorter name in the Struct that uses it. Remember when doing this that only the quoted name will be useable. If You try to reference `data_sections` instead of `data_sects`, you'll end up with a `KeyError`.

## 6.5 Parsing raw data using Construct

This process is much simpler than with Kaitai - you can do all of the work from the same file as before if you want to, especially if you're using a `.ipynb` file instead of `.py`, which will allow you to simply add a new cell to work from. 