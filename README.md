# extract-files

A flexible utility for extracting files from directories based on extensions or filenames.

## Features
- Extract files by extension(s) - specify multiple extensions
- Extract specific files by name - specify multiple files  
- Support for relative paths in file specifications
- Exclude specific files or directories
- Customize output directory
- Optional tree structure generation
- Generate SQLite database schema for .db files

## Installation

```bash
# Clone the repository
git clone https://github.com/username/extract-files
cd extract-files

# Make the script executable
chmod +x bin/extract-files

# Optional: Add to your PATH
sudo ln -s "$(pwd)/bin/extract-files" /usr/local/bin/
```

## Usage

```bash
extract-files SOURCE_DIR [OPTIONS]
```

### Options:
- `-e EXT [EXT...]`: File extensions to extract (can specify multiple)
- `-f FILE [FILE...]`: Specific filenames to extract (can specify multiple)
- `-x FILE`: Exclude specific files
- `-X DIR [DIR...]`: Exclude specific directories (can specify multiple)
- `-o DIR`: Output directory (default: ~/Desktop/extracted_files)
- `-t`: Update tree file
- `-s FILE`: Generate SQLite database schema from specified database file
- `--help`: Show help message

### File and Extension Matching
The `-e` and `-f` options are **additive** - files matching ANY specified extension OR ANY specified filename will be extracted.

For `-f`, you can specify:
- Just the filename: `-f config.yaml` (matches any file named config.yaml in any directory)
- Relative path: `-f src/config.yaml` (matches exactly src/config.yaml from the source directory)

## Examples

```bash
# Extract all Python and Java files
extract-files ~/myproject -e py java

# Extract multiple specific files in one command
extract-files ~/myproject -f config.yaml data.json package.json

# Extract files with relative paths
extract-files ~/myproject -f src/main.py tests/test_config.py

# Mix extensions and specific files (additive)
extract-files ~/myproject -e py java -f config.yaml README.md

# Extract to custom directory with tree
extract-files ~/myproject -e py -o ~/extracted -t

# Generate schema from a database without extracting other files
extract-files ~/myproject -s ~/databases/images_db.db

# Extract Python files but exclude test directories and specific files
extract-files ~/myproject -e py -X tests test -x debug.py

# Multiple ways to specify the same files
extract-files ~/myproject -f file1.txt file2.py -f file3.java  # Multiple files after -f
extract-files ~/myproject -f file1.txt -f file2.py -f file3.java  # Multiple -f options
```

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.