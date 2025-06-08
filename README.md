# JavaScript & React Course Notes

A comprehensive documentation site built with MkDocs Material for JavaScript and React learning materials.

## Features

- 🎨 Beautiful Material Design theme with teal color scheme
- 🌙 Dark/Light mode toggle
- 📱 Responsive design
- 🔍 Search functionality
- 📖 Organized sections for JavaScript and React
- 💻 Code syntax highlighting
- 📝 Interactive content with tabs and admonitions

## Quick Start

### Prerequisites

- Python 3.12+ installed
- Virtual environment set up (already configured)

### Running the Development Server

**Option 1: Using the convenience script**

```bash
./serve.sh
```

**Option 2: Using VS Code tasks**

- Open Command Palette (`Ctrl+Shift+P`)
- Run: `Tasks: Run Task`
- Select: `MkDocs: Serve Development Site`

**Option 3: Manual activation**

```bash
source mkdocs-env/bin/activate
mkdocs serve --dev-addr 127.0.0.1:8001
```

The site will be available at: **http://127.0.0.1:8001/notes/**

### Building for Production

```bash
source mkdocs-env/bin/activate
mkdocs build
```

## Project Structure

```
notes/
├── docs/                    # Documentation source files
│   ├── index.md            # Homepage
│   ├── javascript/         # JavaScript section
│   │   ├── js-basics/     # Basic concepts
│   │   ├── intermediate/  # Advanced topics
│   │   └── snippets/      # Code snippets
│   └── react/              # React section
├── mkdocs.yml              # MkDocs configuration
├── requirements.txt        # Python dependencies
├── mkdocs-env/            # Python virtual environment
└── serve.sh               # Development server script
```

## Content Sections

### JavaScript

- **Basics**: Variables, operators, data types
- **Intermediate**: Destructuring, spread/rest operators, logical operators
- **Snippets**: Practical code examples and utilities

### React

- Coming soon - ready for expansion

## Development

### Adding New Content

1. Create markdown files in the appropriate `docs/` subdirectory
2. Update `mkdocs.yml` navigation if needed
3. The development server will automatically reload changes

### Customizing

- **Theme**: Edit `mkdocs.yml` under the `theme` section
- **Navigation**: Modify the `nav` section in `mkdocs.yml`
- **Extensions**: Add markdown extensions in the `markdown_extensions` section

## Dependencies

All dependencies are managed in `requirements.txt`:

- mkdocs>=1.5.0
- mkdocs-material>=9.4.0
- mkdocs-awesome-pages-plugin>=2.9.0
- pymdown-extensions>=10.0

## Contributing

1. Add your content in the appropriate section
2. Follow the existing markdown structure
3. Test locally using the development server
4. Commit your changes

---

_Built with ❤️ using MkDocs Material_
