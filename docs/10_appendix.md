# i: Appendix

## Kaitai Installation

There are several reasons that one might choose to install the `Kaitai-Struct-Compiler` directly onto their machines as opposed to using the Web IDE. The desktop and console versions can also be used when you're done using the Web IDE to compile the file for other programming languages. The different OS downloads are available [with this link](https://kaitai.io/#download).

After installation, you should have:
* `ksc` (`kaitai-struct-compiler`) - a command line Kaitai Struct Compiler which translates `.ksy` files into parsing libraries for a chosen target language.
* `ksv` (`kaitai-struct-visualizer`, optional) a console visualizer

## Additional Construct Installation

While not necessary for this lesson, if you wish to install all the supported modules alongside your Construct install, instead type or copy the following and hit enter:

```
pip install construct[extras]
``` 