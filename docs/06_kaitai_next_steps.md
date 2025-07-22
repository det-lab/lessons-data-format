# Describing the Data in Kaitai

Now that you have created a custom binary file, let's describe its structure using Kaitai Struct. This will allow you to parse and analyze your data with generated code.

If you don't have the [Kaitai Web IDE](https://ide.kaitai.io/) open, navigate there and create a new `.ksy` file (e.g., `wave_parser.ksy`). You can also reference the [example file](https://github.com/det-lab/lessons-data-format/blob/gh-pages/examples/wave_parser.ksy).

## Writing the Kaitai Description

### Setting Endianness

By default, the binary data you created was written using your operating system's native endianness. If you want to ensure consistency, you can explicitly set the endianness when generating your arrays in Python:

```python
# For little-endian
full_x_data = np.array(full_x, dtype='<float32')  # or '<f4'

# For big-endian
full_x_data = np.array(full_x, dtype='>float32')  # or '>f4'
```

In your `.ksy` file, specify the endianness in the `meta` section:

```yaml
meta:
  id: test
  file-extension: test
  endian: le  # or 'be' for big-endian
```

### Describing the File Structure

Recall that when saving your binary file, you wrote three unsigned 4-byte integers at the start, representing the lengths of each data section. In Kaitai, you can capture these using `u4` types:

```yaml
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

In the main `seq` section, reference this type to read the lengths:

```yaml
seq:
  - id: lengths
    type: full_mid_peak_lens
```

Next, define the structure for each data section. Since each section contains two arrays (`x_data` and `y_data`) of `float32` values, and you know the length from the header, you can use `repeat-expr`:

```yaml
  full_data:
    seq:
      - id: x_data
        type: f4
        repeat: expr
        repeat-expr: _root.lengths.full_len
      - id: y_data
        type: f4
        repeat: expr
        repeat-expr: _root.lengths.full_len

  mid_data:
    seq:
      - id: x_data
        type: f4
        repeat: expr
        repeat-expr: _root.lengths.mid_len
      - id: y_data
        type: f4
        repeat: expr
        repeat-expr: _root.lengths.mid_len

  peak_data:
    seq:
      - id: x_data
        type: f4
        repeat: expr
        repeat-expr: _root.lengths.peak_len
      - id: y_data
        type: f4
        repeat: expr
        repeat-expr: _root.lengths.peak_len
```

Finally, add these sections to the main `seq`:

```yaml
  - id: f_data
    type: full_data
  - id: m_data
    type: mid_data
  - id: p_data
    type: peak_data
```

Your `.ksy` file should now fully describe the structure of your binary file.

## Parsing Raw Data with a .ksy File

To parse your data outside the Web IDE, you need to generate code using the Kaitai Struct Compiler (`ksc`). If you haven't installed it, see the [appendix](09_appendix.md).

From your terminal, generate the parser (for Python):

```sh
ksc -t <language> --outdir <new_foldername> <path/to/your/file.ksy>
```

Replacing the parts in the brackets accordingly. For language, the options are: `cpp_stl`, `csharp`, `java`, `javascript`, `perl`, `php`, `python`, `ruby`, or `all`. For this example, we'll be running:

```sh
ksc -t python --outdir wave_test wave_parser.ksy
```

This will create a folder (`wave_test`) containing a Python file (`test.py`).

## Loading and Using the Parser in Python

Make sure your generated parser and your binary data file are in the same directory or update your import paths accordingly.

Example usage in Python:

```python
from pathlib import Path
from wave_test.test import *  # Replace with the actual class name from your .ksy meta:id
import matplotlib.pyplot as plt

raw_data = Path('wave_data.test')
wave_data = Test.from_file(raw_data)

# Access lengths
f_length = wave_data.lengths.full_len
m_length = wave_data.lengths.mid_len
p_length = wave_data.lengths.peak_len
print(f_length, m_length, p_length)

# Access and plot full data
full_x = wave_data.f_data.x_data
full_y = wave_data.f_data.y_data
plt.plot(full_x, full_y)
plt.title("Full Data")
plt.show()
```

Repeat for `m_data` and `p_data` as needed.

---

You have now described and parsed your custom binary file using Kaitai Struct!  Continue to [Construct Next Steps](07_construct_next_steps.md) to parse your custom data with the Construct library.