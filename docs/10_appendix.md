# Appendix

## Kaitai Installation

While the [Kaitai Web IDE](https://ide.kaitai.io/) is sufficient for most users, you may want to install the Kaitai Struct Compiler (`ksc`) locally if you need to:

- Generate parser code for use in your own projects (Python, Java, C#, etc.)
- Work offline or automate parser generation
- Use the Kaitai Struct Visualizer (`ksv`) for console-based visualization

You can download installers for your operating system from the [Kaitai Struct download page](https://kaitai.io/#download).

After installation, you should have access to:

- `ksc` (`kaitai-struct-compiler`): Command-line tool to compile `.ksy` files into parsing libraries for your chosen language.
- `ksv` (`kaitai-struct-visualizer`, optional): Console-based visualizer for Kaitai Struct files.

For usage instructions, see the [official Kaitai documentation](https://kaitai.io/docs/).

## Additional Construct Installation

The main Construct library is sufficient for this lesson. However, if you want to install all optional modules (for advanced features or additional protocol support), use:

```sh
pip install construct[extras]
```

For more details, refer to the [Construct documentation](https://construct.readthedocs.io/).

---

If you encounter installation issues, check the official documentation or community forums linked in the [conclusion](09_conclusion.md).