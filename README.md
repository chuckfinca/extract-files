# extract-files

A flexible utility for extracting files from directories based on extensions or filenames.

## Features
- Extract files by extension(s)
- Extract specific files by name
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
extract-files dir [-e ext1 ext2...] [-f file1 file2...] [-x exclude] [-X exclude_dir] [-o output_dir] [-t] [-s]
```

Options:
- `-e`: File extensions to extract (e.g., -e py java cpp)
- `-f`: Specific filenames to extract
- `-x`: Exclude specific files
- `-X`: Exclude specific directories
- `-o`: Output directory (default: ~/Desktop/extracted_files)
- `-t`: Update tree file
- `-s FILE`: Generate SQLite database schema from specified database file
- `--help`: Show help message

Examples:
```bash
# Extract all Python and Java files
extract-files ~/myproject -e py java

# Extract specific files
extract-files ~/myproject -f config.yaml data.json

# Extract to custom directory with tree
extract-files ~/myproject -e py -o ~/extracted -t

# Generate schema from a database without extracting it
extract-files ~/myproject -s ~/databases/images_db.db

# Extract Python files but exclude test directories
extract-files ~/myproject -e py -X tests test
```

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.