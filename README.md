## projects.nvim

A simple plugin to manually register projects in Neovim.

`projects.nvim` is a lightweight project registry that allows you to manually add, view, and switch between your projects. It stores your project list locally in a JSON file and uses Neovim's built-in `vim.ui.select` for project selection.

### ✨ Features

- **Manual Registration**: Only tracks the projects you explicitly add. No magic auto-discovery that clutters your workspace.
- **Easy Switching**: Switch your working directory (`cwd`) to a project instantly.
- **Persisted Storage**: Saves projects into a `project_registry.json` file in your Neovim data directory.
- **Sorted by Recent**: Projects are automatically sorted so the most recently accessed projects appear at the top.

### ⚡️ Requirements

- Neovim >= 0.8.0

### 📦 Installation

```lua
-- lua with lazy.nvim
return {
    "nhattVim/projects.nvim",
    cmd = {
        "ProjectList",
        "ProjectAdd",
        "ProjectRemove",
    },
    opt = {},
}
```

### 🚀 Usage

`projects.nvim` provides the following user commands out of the box:

- `:ProjectAdd [name]` - Add the current working directory to the project registry. If `[name]` is not provided, the folder's name is used.
- `:ProjectList` - Show the list of registered projects. Selecting a project will change the Neovim `cwd` to that project's path.
- `:ProjectRemove` - Open the project list to select a project and remove it from the registry.

### 🗄️ Data Storage

The project list is stored as a JSON file at your standard Neovim data path (`vim.fn.stdpath("data")`):

- **Windows**: `~\AppData\Local\nvim-data\project_registry.json`
- **Linux/macOS**: `~/.local/share/nvim/project_registry.json`
