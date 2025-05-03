# Creating a custom data format
**Created by Adrian Fisher**

## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.
* `mkdocs gh-deploy` - Deploy changes to the project's github page

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md                    # The documentation homepage.
        01_introduction.md          # Explaining the purpose of the lesson
        02_setup.md                 # How to install and use Kaitai and Construct
        03_filetype.md              # Describing file formats, types, and the basics of computer language
        04_kaitai_basics.md         # Describing the basics of using Kaitai
        05_construct_basics.md      # Describing the basics of using Construct
        06_creating_example_data.md # Creating an example raw data file
        07_kaitai_next_steps.md     # Parsing the example data file with Kaitai
        08_construct_next_steps.md  # Parsing the example data file with Construct
        09_conclusion.md            # Final thoughts and resources
        10_appendix.md              # Installation resources and advanced options
        ...       # Other markdown pages, images and other files.
