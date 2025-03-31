# Creating a custom data format
**Created by Adrian Fisher**

## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md               # The documentation homepage.
        setup.md               # Setting up kaitai and construct
        filetype.md            # Describing file formats and types
        kaitai_basics.md       # Describing the basics of using Kaitai
        construct_basics.md    # Describing the basics of using Construct
        putting_it_together.md # Creating fake data and learning to compile it
        conclusion.md          # Conclusion (TODO)
        advanced.md            # Section for advanced users
        ...       # Other markdown pages, images and other files.
