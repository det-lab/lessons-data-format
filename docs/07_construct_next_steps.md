### Objectives:
* Create Structs to describe our example data using the Construct library.
* Combine our Structs in a final description of our custom file format.
* Parse our custom file format using our Struct.

# 8: Describing the Data in Construct

Now that you've described your custom binary file in Kaitai, let's do the same using the [Construct](https://construct.readthedocs.io/) library in Python. This section will guide you through building Structs to match your file layout, parsing the data, and visualizing the results.

If you want to compare with a working example, see the [example_struct.ipynb](https://github.com/det-lab/lessons-data-format/blob/gh-pages/examples/example_struct.ipynb) notebook.

## 8.1: Setting Up and Defining Structs

Start by importing the required libraries:

```python
from construct import *
import matplotlib.pyplot as plt
import numpy as np
```

Recall that your binary file starts with three 4-byte unsigned integers, giving the lengths of the full, mid, and peak data arrays. We'll define a Struct to capture these:

```python
lengths_struct = Struct(
    "full_data_len" / Int32ul,
    "mid_data_len" / Int32ul,
    "peak_data_len" / Int32ul
)
```

Next, define a Struct for the data arrays. Each section contains two arrays (`x` and `y`), each of length specified in the header:

```python
data_sections = Struct(
    "full_x_data" / Array(this._root.lengths.full_data_len, Float32l),
    "full_y_data" / Array(this._root.lengths.full_data_len, Float32l),
    
    "mid_x_data" / Array(this._root.lengths.mid_data_len, Float32l),
    "mid_y_data" / Array(this._root.lengths.mid_data_len, Float32l),
    
    "peak_x_data" / Array(this._root.lengths.peak_data_len, Float32l),
    "peak_y_data" / Array(this._root.lengths.peak_data_len, Float32l),
)
```

Finally, combine these into the top-level Struct:

```python
test_struct = Struct(
    "lengths" / lengths_struct,
    "data_sects" / data_sections
)
```

> **Tip:** You can name your sub-Structs however you like, but be consistent. The quoted names (e.g., `"data_sects"`) are the keys you'll use to access the parsed data.

## 8.2: Parsing and Visualizing the Data

Parsing with Construct is straightforward. You can do everything in the same script or notebook:

```python
def parse_file(input_path):
    with open(input_path, 'rb') as input_f:
        raw_data = input_f.read()
        parsed_data = test_struct.parse(raw_data)

    # Extract arrays
    full_x = parsed_data.data_sects.full_x_data
    full_y = parsed_data.data_sects.full_y_data
    mid_x = parsed_data.data_sects.mid_x_data
    mid_y = parsed_data.data_sects.mid_y_data
    peak_x = parsed_data.data_sects.peak_x_data
    peak_y = parsed_data.data_sects.peak_y_data

    # Plot full data
    plt.plot(full_x, full_y)
    plt.title("Full Data")
    plt.show()

    # Plot mid-range data
    plt.plot(mid_x, mid_y)
    plt.title("Mid-range Data")
    plt.show()

    # Plot peak data
    plt.scatter(peak_x, peak_y, s=1)
    plt.title("Peak Data")
    plt.show()
```

Call your function with the path to your binary file:

```python
parse_file("wave_data.test")
```

You should see the same plots as when you generated the data, confirming that your Structs correctly describe the file format.

---

You have now parsed your custom binary file using Construct! This approach mirrors the Kaitai description from the previous section, and you can adapt it for more complex formats as needed.

Continue to the [conclusion](08_conclusion.md) for final thoughts and resources.