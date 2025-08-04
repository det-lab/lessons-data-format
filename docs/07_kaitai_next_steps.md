# Describing the Data in Kaitai

Now that you have created a custom binary file, let's describe its structure using Kaitai Struct. This will allow you to parse and analyze your data with generated code.

If you don't have the [Kaitai Web IDE](https://ide.kaitai.io/) open, navigate there and create a new `.ksy` file (e.g., `wave_parser.ksy`). You can also reference the [example file](https://github.com/det-lab/lessons-data-format/blob/gh-pages/examples/wave_parser.ksy).

## Writing the Kaitai Description

We're about to create the `.ksy` files used to parse our example format, you are encouraged to try and create the file using what you've learned so far, but solutions will be provided for each section as well.

<details>
  <summary>You can also download the example ksy file to compare your work to by clicking here.</summary>
  <p><a href="../examples/wave_parser.ksy" download>Download wave_parser.ksy</a></p>
</details>

### Meta Section

The first step for creating our `.ksy` file will be to fill out the `meta` section. The `id` and file extension are often identical, and should be the same as what you entered as the file extension when writing the file. Then you will assert if the file is either in little-endian, `le`, or big-endian, `be`.

<details>
  <summary>Show solution</summary>
  <p>

```yaml
meta:
  id: test
  file-extension: test
  endian: le
```

  </p>
</details>

### Describing the File Structure

Recall that when saving your binary file, we wrote three unsigned 4-byte integers at the start, representing the lengths of each data section. We can start off by describing these numbers in a `type` before using that `type` definition in `seq`. While it may feel unnatural to write non-linearly, it is very common for working with Kaitai.

<details>
  <summary>Show solution</summary>
  <p>

```yaml
seq:
  - id: lengths
    type: full_mid_peak_lens

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
  </p>
</details>

Next, define the structure for each section of the data (full/mid/peak). Recall that when writing the data, we only used the length of one axis, but we need to capture both the x- and y-data. This capture will require us to use a `repeat-expr` which repeats the `f4` type as many times as the length of the axis. As an example, the syntax for a `repeat-expr` for `full_data` could be written as:
```yaml
repeat: expr
repeat-expr: _root.length.full_len
```
<details>
  <summary>Show solution</summary>
  <p>

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

  </p>
</details>

Finally, add all of these sections to the main `seq`.

<details>
  <summary>Show solution</summary>
  <p>

```yaml
  - id: f_data
    type: full_data
  - id: m_data
    type: mid_data
  - id: p_data
    type: peak_data
```
</p>
</details>

Your `.ksy` file should now fully describe the structure of your binary file.

## Parsing Raw Data with a .ksy File


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

You have now described and parsed your custom binary file using Kaitai Struct!  Continue to [Construct Next Steps](08_construct_next_steps.md) to parse your custom data with the Construct library.