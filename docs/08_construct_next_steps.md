### Objectives:
* Create Structs to describe our fabricated data using the Construct library.
* Combine our Structs in a final description of our custom file format.
* Parse our custom file format using our Struct.

# 8: Describing the data in Construct

If for some reason it might benefit your project to create a description of your file format using both Kaitai and Construct, I'd recommend first creating a Kaitai description and then basing your Construct file off of it, simply because the syntax for Kaitai is a little more straightforward. As before, there is an example file for this section on [this page's github](https://github.com/det-lab/lessons-data-format/blob/gh-pages/examples/example_struct.ipynb). With that being said, let's open up a new `.py` or `.ipynb` file and begin by importing the Construct module, matplotlib.pyplot, and numpy before defining our Structs. 
```
from construct import *
import matplotlib.pyplot as plt
import numpy as np
```
Next, as before, we'll want to capture the three numbers at the front of the file which tell us how long each array is. Our approach here will look much like our work in Kaitai, but there are still multiple different ways to perform this capture, and experimenting to see what feels most efficient for you is encouraged.

For this example, I'm going to start off with what will eventually be the final Struct and create a sub Struct which will capture those values.
```
test_struct = Struct(
  "lengths" / Struct(
    "full_data_len" / Int32ul,
    "mid_data_len" / Int32ul,
    "peak_data_len" / Int32ul
  )
)
```
This could be accomplished equivalently by creating the lengths `Struct` first, followed by using it in `test_struct`.

As mentioned previously, `test_struct` will be used at the final step of the description. This is a limitation of Python, as Python is unable to use variables or Structs that have yet to be declared. But, since the `Struct` that comes before this one will only be **used** when it's nested into `test_struct`, we'll be able to reference the `lengths` sub-Struct to capture the full, mid, and peak data lengths. Each of the data sections will select 4 bytes at a time and save them into an array of the given length.
```
data_sections = Struct(
    "full_x_data" / Array(
        this._root.lengths.full_data_len,
        Float32l
    ),
    "full_y_data" / Array(
        this._root.lengths.full_data_len,
        Float32l
    ),
    
    "mid_x_data" / Array(
        this._root.lengths.mid_data_len,
        Float32l
    ),
    "mid_y_data" / Array(
        this._root.lengths.mid_data_len,
        Float32l
    ),
    
    "peak_x_data" / Array(
        this._root.lengths.peak_data_len,
        Float32l
    ),
    "peak_y_data" / Array(
        this._root.lengths.peak_data_len,
        Float32l
    ),
)
```
Again, there are plenty of ways to do this. You could instead make a different `Struct` for each of the data captures and then put them altogether in `data_sects`. Or you could copy what we did with the `lengths` `Struct`, using only `test_struct` to define your data with everything else as a substruct. As it is though, we can add this Struct into `test_struct` as:
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
For selections that only have one defining `Struct`, like `data_sects`, there isn't necessarily a reason not to also name the sub `Struct` (`data_sects`) after the `Struct` that it's using (`data_sections`). In this case, it's simply a matter of shortening the name to reduce how much typing is necessary to call that attribute later. It's not uncommon to have a `Struct` with a very clear name which is then given a shortened name in the higher `Struct` which actually uses it. Remember when doing this that only the quoted name will be useable. If You try to reference `data_sections` instead of `data_sects`, you'll end up with a `KeyError`.

## 8.1: Parsing raw data using Construct

This process is much simpler than with Kaitai - you can do all of the work from the same file as where you set the Structs. 

Let's now create a function that parses our file and plots the results:
```
def parse_file(input_path):
  with open(input_path, 'rb') as input_f: # 'rb' ='read binary'
    raw_data = input_f.read()
    parsed_data = test_struct.parse(raw_data)

    # Select all relevant values
    full_x_data = parsed_data.data_sects.full_x_data
    full_y_data = parsed_data.data_sects.full_y_data

    mid_x_data = parsed_data.data_sects.mid_x_data
    mid_y_data = parsed_data.data_sects.mid_y_data

    peak_x_data = parsed_data.data_sects.peak_x_data
    peak_y_data = parsed_data.data_sects.peak_y_data

    # Plot all data
    plt.plot(full_x_data, full_y_data)
    plt.plot()
    plt.show()

    plt.scatter(mid_x_data, mid_y_data, s=1)
    plt.plot()
    plt.show()

    plt.scatter(peak_x_data, peak_y_data, s=1)
    plt.plot()
    plt.show()
```
Now all that's left is to call our `parse_file` function:
```
input_path = </your/path/to/wave_data.test>
parse_file(input_path)
```
And you have officially parsed your first file using Construct!