# Introduction
In scientific computing, data is often stored in custom *binary* formats. These formats might be tailored for specific instruments, simulations, or to optimize for storage space or read/write speed. However, a major drawback is that standard analysis software and programming language libraries usually cannot interpret these specialized binary structures directly.

This lack of interoperability creates a hurdle: before the data can be analyzed or shared effectively, its binary layout must be explicitly defined and parsed. This lesson addresses this common challenge. We will explore how to set up and use two powerful tools:

1.  **Kaitai Struct:** A YAML based declarative language for describing binary data structures, which can generate parser code in various languages (Python, C#, Java, JavaScript, Perl, PHP, Ruby).
2.  **Construct:** A Python library for parsing and building binary data structures.

We will guide you through installing these tools and then show you how to use them in your analysis workflow.

>If you are new to programming, it's recommended that you first take a few minutes to go over [this short lesson](https://det-lab.github.io/reading-documentation/) talking about how to read technical documentation.

---

Continue to [Setup](01_setup.md) to get your environment ready.