# Setup

This section will guide you through setting up the tools needed for this lesson: the Kaitai Web IDE (for describing binary formats) and the Construct Python library (for parsing them in Python). By the end, you'll be ready to follow along with all code examples.

## Kaitai IDE

**No installation is required** for most users. Simply open the [Kaitai Web IDE](https://ide.kaitai.io/) in your browser.  
- To get started:  
  1. Go to [https://ide.kaitai.io/](https://ide.kaitai.io/)  
  2. Click "New" to create a new .ksy file  
  3. Follow the instructions in [Section 3: Defining the Structure in Kaitai](04_kaitai_basics.md)

*Advanced users*: If you want to use Kaitai offline or generate parsers locally, see the [appendix](09_appendix.md) for installing `ksc` and `ksv`.

## Python and IDE Setup

To use Construct, you need Python 3.6 or newer.  

- Download Python from [python.org](https://www.python.org/downloads/) if you don't have it.

- Check your Python version:
```bash
python --version
```

We recommend using a Python virtual environment to keep your dependencies isolated.  
To set up a virtual environment using `virtualenv`:

1. Install `virtualenv` if you don't have it:
    ```bash
    pip install --user virtualenv
    ```
2. Create a new environment (replace `env` with your preferred name):
    ```bash
    python -m virtualenv env
    ```
3. Activate the environment:
    - On Linux/macOS:
        ```bash
        source env/bin/activate
        ```
    - On Windows:
        ```bash
        .\env\Scripts\activate
        ```

You can use any IDE (e.g., [VS Code](https://code.visualstudio.com/), [PyCharm](https://www.jetbrains.com/pycharm/), [Anaconda](https://www.anaconda.com/)), but we recommend [Spyder](https://www.spyder-ide.org/download) for beginners.

## Construct Setup

With your virtual environment activated, install Construct:
```bash
pip install construct
```
If you encounter installation issues, refer to the [Appendix](10_appendix.md) or consult the official documentation for [Construct](https://construct.readthedocs.io/).

---
Continue to [File types and formats](02_filetype.md) to learn how computers interpret and store different file types.