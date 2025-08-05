# Custom Binary Data Formats
This lesson discusses the problem of analyzing data which is stored in custom binary formats and describes how to go about parsing such data using **Kaitai Struct** and **Construct**. It is structured to give readers an understanding of the creation of custom file types and what operations computers and their programs perform to translate file types into a human-readable format.
# Lesson Outline
This lesson is broken into the following sections:
## Introduction (`index.md`)
A brief overview of Kaitai Struct, Construct, and the problem that they exist to solve.
## Setup (`01_setup.md`)
Instructions for configuring Python for Construct as well as showing how to access the Kaitai IDE
## File types (`02_filetype.md`)
A discussion of file types, computer number systems, counting with binary and hexadecimals, and endianness.
## Computer Representation (`03_representation.md`)
A discussion of how computers interpret binary data.
## Kaitai basics (`04_kaitai_basics.md`)
An overview of how to use Kaitai, along with descriptions of the IDE and the different sections of the Kaitai editor and important keywords using the .gif filetype as an example.
## Construct basics (`05_construct_basics.md`)
An overview of how to use Construct, along with explanations of imporant keywords using the .gif filetype as an example.
## Creating Example Data (`06_creating_example_data.md`)
Showing the creation of example data and an example filetype that will be used in later sections. The example is created using Python to generate data in the form of an arbitrary function that is separated into different sections.
## Kaitai Next Steps (`07_kaitai_next_steps.md`)
Demonstrating how to use Kaitai to extract the data from the example file. Walks through the creation of a .ksy file, the generation of a Python parser from that file, and the use of the parser inside a Python environment to return the example data.
## Construct Next Steps (`08_construct_next_steps.md`)
Demonstrating how to use Construct to extract the data from the example file. Walks through the creation and combination of Structs to describe and load the file data before visualizing it in Python.
## Conclusion (`09_conclusion.md`)
Provides additional resources for Kaitai and Construct, such as documentation, forum communities, and mailing lists.
## Appendix (`10_appendix.md`)
Provides installation advice and advanced options for users of both Kaitai and Construct.
# Goals
By the end of this lesson, you should be able to:

* Understand filetypes and file formats as custom binary data formats

* Have a basic understanding of how to use Kaitai and Construct to parse custom data formats
# Requirements

* Python 3.6+

* Construct 2.10+