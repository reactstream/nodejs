# ReactStream Project Structure

```
reactstream/
├── index.js                  # Main CLI entry point
├── src/
│   ├── reactstream.js        # Main implementation file
│   ├── analyze.js            # Analysis module
│   └── index.js              # Development server module
├── commands/                 # CLI command implementations
│   ├── analyze.js            # React component analysis command
│   └── serve.js              # Development server command
├── img/                      # Images for documentation
├── package.json              # Project dependencies and metadata
├── README.md                 # Project documentation
├── DOCS.md                   # Detailed documentation
├── CONTRIBUTING.md           # Contribution guidelines
└── node_modules/             # Dependencies (generated by npm)
```

## File Purposes

### Core Files

- **index.js**: Main CLI entry point that processes commands and routes to the appropriate modules
- **src/reactstream.js**: Central implementation file that coordinates functionality
- **src/analyze.js**: Contains the React component analysis logic
- **src/index.js**: Contains the development server logic

### Command Files

- **commands/analyze.js**: Implements the `analyze` subcommand
- **commands/serve.js**: Implements the `serve` subcommand

### Documentation

- **README.md**: Overview, installation, and basic usage
- **DOCS.md**: Detailed documentation and advanced usage
- **CONTRIBUTING.md**: Guidelines for contributing to the project

## Installation Instructions

1. Clone the repository:
   ```
   git clone https://github.com/reactstream/cli
   cd reactstream
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Make the CLI globally available:
   ```
   npm link
   ```

## Development Workflow

### Setting Up for Development

```bash
# Clone the repository
git clone https://github.com/reactstream/cli
cd reactstream

# Install dependencies
npm install

# Link the CLI for development
npm link

# Test the CLI
reactstream help
```

### Making Changes

1. Edit the source files in `src/` or command files in `commands/`
2. Test your changes locally
3. Write or update tests for new functionality
4. Commit your changes with meaningful commit messages

### Publishing a New Version

```bash
# Update version in package.json
npm version [patch|minor|major]

# Publish to npm
npm publish

# Push changes to GitHub
git push origin main
git push origin --tags
```

## Command Structure

The ReactStream CLI uses a command-based structure:

- **Main Command**: `reactstream`
- **Subcommands**: `analyze`, `serve`, `help`
- **Options**: Command-specific options such as `--debug`, `--fix`, `--port`

### Example Command Flow

```
reactstream analyze MyComponent.js --debug
↓
index.js (parses command and options)
↓
commands/analyze.js (loads the analyze module)
↓
src/analyze.js (performs the actual analysis)
```

## Component Dependencies

- **chalk**: Terminal string styling
- **minimist**: Command-line argument parsing
- **esprima, escodegen, estraverse**: JavaScript parsing and analysis
- **eslint**: Code quality checking
- **webpack, babel**: Build system for development server

This structure provides a modular approach that allows for easy maintenance and extension of the ReactStream toolkit.
