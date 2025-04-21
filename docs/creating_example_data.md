### Objectives:
* Create fake data on which to practice our understandings of Kaitai and Construct.

# 6: Creating Example Data

Now that we have the basics down, let's try putting it all together. To do this, let's fabricate some data, save that data in a binary file, and then define the structure for that data in both Kaitai and Construct. After that, we can compile our formats and begin to manipulate and work with this data.

Let's say that the data that we're taking comes as a waveform in a binary file. We can pretend that we're measuring vibrations through some material, or current intensity in some electrical system, or something like that. As we're fabricating data, not actually taking measurements, the justification doesn't really matter. 

For this example we'll be working in Python as it is necessary for using Construct. If you have yet to install an IDE, a link and some instructions were provided in the [setup section (2.2)](/setup/) to install the Spyder environment.

Let's say that for some reason we want to break our data into 3 different sections depending on the intensity. The first section can describe the entire wave form, the second can capture only some mid-range values, and the third section captures only the most intense values. In real life, this could translate to three different sensors that each have different sensitivities being used to gather our data.

First, we'll need to make sure that all of the necessary libraries are installed and imported. For this data, we'll need the numpy library and the struct (which is different from Construct) library. Optionally, we can also include matplotlib in order to plot our simulated data. To check if you already have these libraries installed, open your IDE's terminal and enter:
```
pip list
```
This will return an alphabetical list of all currently installed packages/modules that your install of Python has access to, as well as their version numbers. Simply scroll through the result to see if `matplotlib`, `numpy`, and `python-struct` are installed, and if not, run:
```
pip install numpy
pip install matplotlib
pip install python_struct
```

You should now be free to create a new `.py` or `.ipynb` file, named something like "example_data". Feel free to take a look at the final product of this section to follow along with at [this page's github](https://github.com/det-lab/lessons-data-format/blob/gh-pages/examples/example_data.ipynb).  

At the beginning of your new file, import the necessary modules using the commands:
```
import numpy as np
import struct
import matplotlib.pyplot as plt
```
Keep in mind that most IDEs will require you to save the file before allowing you to run it. Now, let's create 6 different arrays, one for each x and y value that is being selected from each desired section.
```
full_x = []
full_y = []

mid_x = []
mid_y = []

peak_x = []
peak_y = []
```
We'll then want to populate these arrays with their respective data. Let's create a `for` loop which will create data points for a wave using an equation. For this example, I'll be creating a function that is defined from `x=-5` to `x=5`, creating a y data point every increment of `0.0001` on the x axis, meaning the full data will contain 100000 points. 

The actual function chosen for this example doesn't matter much as long as it's valid within the range you choose. You should be able to simply plot a cosine or sin function with arbitrary limits without running into any issues as long as your computer can handle the number of data points you create. In fact, mixing things up a bit and trying a different equation than is shown here is encouranged! Doing so while referencing the documentation pages for Construct and Kaitai will allow you to find any holes in what this lesson has the space to offer while allowing you to fill them using your own troubleshooting abilities.

For my function, we have:
```
for i in np.arange(-5,5,0.0001):
  # Function that is being plotted
  n = (np.cos((2 * np.pi * i**2)/(i**2 + i))) * np.sin(i)

  # Put every point in full_x and full_y
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
plt.plot(full_x, full_y)
plt.show()

plt.plot(mid_x, mid_y)
plt.show()

plt.scatter(peak_x, peak_y, s=1)
plt.show()
```
The resulting graphs should look like:

![full](images/full-graph.png)
![mid](images/mid-graph.png)
![peak](images/peak-graph.png)

Next, we'll want to load all of our wave data into separate numpy arrays. This allows us to set the datatype so each x and y value can be saved across a custom number of bytes. 

Feel free to experiment with the byte size choices as well. You can save the data across 8 bytes by using `float64` for high resolution, 4 bytes by using `float32`, `float16` for 2 bytes, or `float8` for 1 byte. Maybe it would make sense for your "experiment" if the full_x and full_y data were saved with the highest resolution, with each successive drop in sample size also dropping the resolution. You could even decide to flatten every point into integers if you wish by using `uint64`, `uint32`, and so on. Even imaginary numbers can be captured if you choose to visualize a complex equation, with the options beginning at `complex64` and doubling until `complex256`. In any case, your arrays should hopefully look similar to:
```
# Save data to numpy arrays
full_y_data = np.array(full_y, dtype=np.float32)
full_x_data = np.array(full_x, dtype=np.float32)

mid_y_data = np.array(mid_y, dtype=np.float32)
mid_x_data = np.array(mid_x, dtype=np.float32)

peak_y_data = np.array(peak_y, dtype=np.float32)
peak_x_data = np.array(peak_x, dtype=np.float32)
```
The next and final step of creating our example data is to write everything we've done so far to a new `.test` (or whatever extension you choose) file. It is also often useful to include the length of each section somewhere in our final file to make it easier to select the full arrays when compiling. The simplest choice is to include the length of every array at the beginning of the file, but you could also put each length before its respective section. There are other ways to manage this kind of data, but including the lengths this way avoids some of the more convoluted methods, such as giving each array a specific signature or creating termination strings. 

Here's what it looks like to write our data in this way:
```
# Save data to binary file
with open('wave_data.test', 'wb') as f:
  # Write array lengths to file as integers
  f.write(struct.pack('I', len(full_y_data)))
  f.write(struct.pack('I', len(mid_y_data)))
  f.write(struct.pack('I', len(peak_y_data)))
  
  # Write each array to the file
  full_x_data.tofile(f)
  full_y_data.tofile(f)

  mid_x_data.tofile(f)
  mid_y_data.tofile(f)

  peak_x_data.tofile(f)
  peak_y_data.tofile(f)
```
We now have a file titled "wave_data.test" saved in the same directory as our python program. The file type can be decided arbitrarily - it used to be the case that type extensions were required to be 3 characters or less, but that standard has since fallen out of use.