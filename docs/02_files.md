# What Makes a File

As we're about to begin exploring the mechanics of hardware and software on a more fundamental level than the average computer or phone user might be used to, it's important to remember that we are navigating culturally specific conventions and abstractions that have been built up over several decades. After nearly a century of refining our processes and methods, we now have access to almost unthinkably complex devices which we call things like "Graphics Processing Units" (GPUs), or "Random Access Memory" (RAM) cards, which can work together in a device small enough to fit into your pocket and is capable of delivering you pictures of cats from around the world. 

So, when we say a `.jpg` file "is a picture", a `.gif` file "is an animation", or a `.txt` file "is a text document", we're relying on conventions that help computers and humans organize and interpret data. But how does a computer actually know what to do with a file? Let's step back and explore how data is stored, and how we've managed to trick silicon and copper into turning electrons into something humans can understand and interact with.

Files often have an **extension** at the end of their name (such as `.jpg`, `.gif`, or `.txt`). This extension suggests to programs which **format** the actual structure and encoding of the data is organized in so that the program can effectively read the file.

Sometimes, the same file format can have multiple extensions (e.g., `.jpg` and `.jpeg`), and sometimes a single file extension can refer to many different formats (e.g., `.bin` for binary data). These conventions are not strict rules. If you try to open a file with the wrong program, the data may be misinterpreted or unreadable. 

As new needs arise, developers create new file formats to meet emerging needs, along with software that can interpret the underlying binary data and display it in a human-readable form. For example, word processors like Microsoft Word use the `.docx` format to save documents, which encodes text, formatting, and metadata in a structured way. While formats like this are essential for organizing data, most modern systems are designed to hide details about file formats from the user. When you take a photo on your phone and upload it to social media, you don't usually need to know whether or not the image is saved as a `.jpg`, `.png`, or `.tiff`—software handles those details for you. 

---

[Click here to continue to the next section](03_representation.md) where we will go over how computers are designed to represent and interpret data.