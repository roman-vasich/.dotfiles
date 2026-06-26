# AGENTS.md

Guidance for agents working in this Neovim configuration repository.

## Goal

Keep the configuration modular, predictable, and easy to debug. Prefer a clean
target structure over preserving the current layout when adding new code.

## Target Structure

Use this structure for new or substantially rewritten configuration:

```text
.
├── init.lua
├── lua/
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── options.lua
│   │   └── lazy.lua
│   ├── plugins/
│   │   ├── init.lua
│   │   ├── lsp.lua
│   │   ├── completion.lua
│   │   ├── formatting.lua
│   │   ├── treesitter.lua
│   │   └── ui.lua
│   ├── local/
│   │   └── example_plugin.lua
│   └── util/
│       └── init.lua
├── lsp/
│   ├── lua_ls.lua
│   ├── gopls.lua
│   └── terraformls.lua
└── after/
    └── ftplugin/
```

### File Responsibilities

- `init.lua`: only bootstraps the config. Keep it small: load options,
  keymaps, autocmds, and the plugin manager.
- `lua/config/options.lua`: global editor options only.
- `lua/config/keymaps.lua`: user keymaps only. Prefer descriptive `desc`
  values.
- `lua/config/autocmds.lua`: autocmds only. Always create named augroups.
- `lua/config/lazy.lua`: plugin manager bootstrap and setup.
- `lua/plugins/*.lua`: Lazy plugin specs. Group specs by feature area, not by
  random plugin order.
- `lua/local/*.lua`: custom-written local plugins or substantial local modules.
  Keep implementation code here and expose it through a small Lazy spec in
  `lua/plugins/` when it should be loaded as a plugin.
- `lsp/*.lua`: one native Neovim LSP config per server. File names must match
  server names, for example `terraformls.lua`, not `terraform.lua`.
- `after/ftplugin/*.lua`: filetype-local options, mappings, or commands.
- `lua/util/`: small shared helpers. Do not add utility modules until at least
  two call sites need them.

## Neovim Conventions

- Use Lua for configuration.
- Prefer Neovim native APIs over compatibility wrappers.
- Keep module return values simple: plugin spec tables, config functions, or
  LSP config tables.
- Avoid global variables. If a global is required by a plugin, name it clearly
  and keep it near the plugin setup.
- Keep comments sparse and useful. Explain non-obvious decisions, not ordinary
  Lua syntax.
- Use ASCII unless a file already uses non-ASCII for a clear reason.

## Lua Typing

- Type configuration as much as practical using standard LuaLS annotation
  comments.
- Prefer concrete annotations for plugin specs, setup options, callbacks, and
  LSP config tables. Examples include `---@type LazySpec`,
  `---@param opts table`, and `---@type vim.lsp.ClientConfig`.
- Add local type aliases with `---@class` or `---@alias` only when they clarify
  repeated structured data.
- Do not add noisy annotations for obvious scalar locals.
- Keep annotations accurate when moving or rewriting modules. Incorrect types
  are worse than missing types.

## Plugin Management

- Use `lazy.nvim` specs under `lua/plugins/`.
- Keep `lua/plugins/` for plugin specifications only. Do not put substantial
  custom plugin implementation code there.
- Put custom-written plugins and reusable local modules under `lua/local/`.
- When a local module needs plugin-style loading, create a small Lazy spec in
  `lua/plugins/` that loads the implementation from `lua/local/`.
- Prefer `opts = { ... }` when plugin setup is simple.
- Use `config = function(_, opts) ... end` only when setup needs logic.
- Keep plugin-specific keymaps in the plugin spec when they lazy-load that
  plugin.
- Keep global, always-available keymaps in `lua/config/keymaps.lua`.
- Do not add plugins for functionality Neovim already handles well.
- All external tools that can be managed from inside Neovim should be
  explicitly declared in configuration. This includes LSP servers, formatters,
  linters, debug adapters, Treesitter parsers, and similar tooling installed
  through plugins such as Mason or Treesitter.

## LSP

- Use Neovim's native LSP configuration:
  - define server configs in `lsp/<server>.lua`;
  - call `vim.lsp.config()` only for explicit overrides;
  - enable servers through the chosen LSP setup path.
- Server config files should return `vim.lsp.ClientConfig` tables.
- Use correct server names from `nvim-lspconfig` and Mason. Examples:
  - Terraform: `terraformls`
  - Lua: `lua_ls`
  - Go: `gopls`
  - Python: `pylsp` or `pyright`, depending on the chosen stack
- Mason should install external tools, but LSP behavior should live in LSP
  config files.
- Do not rely on manual, undocumented system installs for language tooling when
  a Neovim-managed installer can declare that dependency.
- Do not mix server setup styles for the same server.

## Formatting and Linting

- Prefer a single formatting path for each filetype.
- Keep formatters and linters separate from language servers unless the server
  is intentionally the formatter.
- Use formatter names that match the package manager or plugin integration.
- Avoid format-on-save changes unless the repository already uses that workflow
  or the user explicitly asks for it.

## Treesitter

- Configure parsers by language, not by incidental file extension.
- Add parser installs only when the related filetype is actively configured.
- Declare parser installs explicitly in the Treesitter configuration.
- Keep textobjects, incremental selection, and highlighting options in the
  Treesitter plugin spec.

## Keymaps

- Every non-trivial keymap should have a `desc`.
- Prefer `<leader>` mappings for user commands.
- Avoid overwriting common defaults unless the mapping is clearly intentional.
- Buffer-local LSP mappings belong in `LspAttach`.

## Autocmds

- Always use `vim.api.nvim_create_augroup`.
- Keep autocmd callbacks small. Move reusable logic into a local function.
- Use `after/ftplugin` for filetype-local settings when no autocmd logic is
  needed.

## Validation

Before finishing meaningful changes, run the smallest useful checks:

```sh
nvim --headless "+Lazy! sync" +qa
nvim --headless "+checkhealth vim.lsp" +qa
```

For Lua syntax checks, use:

```sh
nvim --headless -u init.lua +qa
```

If a check cannot be run because it needs network access, GUI access, or missing
system tools, report that clearly.

## Documentation

- If a feature requires system-wide configuration or tools that cannot be
  managed from inside Neovim, document that requirement clearly in
  `README.md` under the `Prerequisites` section.

## Change Discipline

- Keep changes scoped to the user request.
- Do not reorganize unrelated files during a feature or bug fix.
- When introducing the target structure, migrate one feature area at a time.
- Preserve user behavior unless the request explicitly asks for a redesign.
- Do not delete existing config without confirming it is unused or obsolete.
