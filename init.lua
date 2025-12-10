
-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- [[ Setting options ]] See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:help option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

-- Print the line number in front of each line
vim.o.number = true

-- Use relative line numbers, so that it is easier to jump with j, k. This will affect the 'number'
-- option above, see `:h number_relativenumber`
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight the line where the cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Show <tab> and trailing spaces
vim.o.list = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s) See `:help 'confirm'`
vim.o.confirm = true

vim.o.splitbelow = true
vim.o.splitright = true
vim.o.wrap = false
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true

vim.o.cindent = true
vim.o.cinoptions = "(0"

vim.g.editorconfig = false

vim.g.have_nerd_font = true

-- Example Neovide settings
if vim.g.neovide then
  --vim.o.guifont = "LiterationMono Nerd Font Mono:h12" -- font
  vim.o.guifont = "Google Sans Code NF,Noto Color Emoji:h15" -- font
  vim.g.neovide_scale_factor = 0.8
  vim.g.neovide_fullscreen = false
  vim.g.neovide_scroll_animation_length = 0.15
  vim.g.neovide_cursor_animation_length = 0.05
end

-- make sure sign gutter is visible to remove jitter
vim.opt.signcolumn = 'yes'

-- [[ Set up keymaps ]] See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- Map jk to <Esc>
vim.keymap.set({ 't', 'i' }, 'jk', '<Esc>')

-- [[ Basic Autocommands ]].
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Create user commands ]]
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.fn.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }))
end, { desc = 'Print the git blame for the current line' })

-- [[ Add optional packages ]]
-- Nvim comes bundled with a set of packages that are not enabled by
-- default. You can enable any of them by using the `:packadd` command.

-- For example, to add the "nohlsearch" package to automatically turn off search highlighting after
-- 'updatetime' and when going to insert mode
vim.cmd('packadd! nohlsearch')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },

    { 'neovim/nvim-lspconfig',
      dependencies = {
        -- Useful status updates for LSP.
        { 'j-hui/fidget.nvim',
          opts = {
            notification = {
              --override_vim_notify = true,
            }
          }
        },

        -- Allows extra capabilities provided by blink.cmp
        {
          'saghen/blink.cmp',
          -- NOTE: sometimes lazy.vim doesn't build automatically, run this command in stdpath('data')/blink.cmp/ manually
          build = 'cargo build --release',
          opts = {
            keymap = { preset = 'super-tab' },
            sources = {
                default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },
            fuzzy = { implementation = "prefer_rust" }
          }
        },
      },
      config = function()
          vim.api.nvim_create_autocmd('LspAttach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
              callback = function(event)
                  -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                  -- to define small helper and utility functions so you don't have to repeat yourself.
                  --
                  -- In this case, we create a function that lets us more easily define mappings specific
                  -- for LSP related items. It sets the mode, buffer and description for us each time.
                  local map = function(keys, func, desc, mode)
                      mode = mode or 'n'
                      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                  end

                  -- Rename the variable under your cursor.
                  --  Most Language Servers support renaming across files, etc.
                  map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

                  -- Execute a code action, usually your cursor needs to be on top of an error
                  -- or a suggestion from your LSP for this to activate.
                  map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

                  -- Find references for the word under your cursor.
                  map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                  -- Jump to the implementation of the word under your cursor.
                  --  Useful when your language has ways of declaring types without an actual implementation.
                  map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                  -- Jump to the definition of the word under your cursor.
                  --  This is where a variable was first declared, or where a function is defined, etc.
                  --  To jump back, press <C-t>.
                  map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                  map('<m-j>', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                  -- WARN: This is not Goto Definition, this is Goto Declaration.
                  --  For example, in C this would take you to the header.
                  map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                  -- Fuzzy find all the symbols in your current document.
                  --  Symbols are things like variables, functions, types, etc.
                  map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

                  -- Fuzzy find all the symbols in your current workspace.
                  --  Similar to document symbols, except searches over your entire project.
                  map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

                  -- Jump to the type of the word under your cursor.
                  --  Useful when you're not sure what type a variable is and you want to see
                  --  the definition of its *type*, not where it was *defined*.
                  map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
              end
          })
      end
    },

    'NMAC427/guess-indent.nvim',

    { -- Adds git related signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
    },

    {
      -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
      'folke/tokyonight.nvim',
      priority = 1000, -- Make sure to load this before all the other start plugins.
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('tokyonight').setup {
            styles = {
                comments = { italic = false }, -- Disable italics in comments
            },
        }

        -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
        --vim.cmd.colorscheme 'tokyonight-storm'
      end,
    },

    {
      'sainnhe/gruvbox-material',
      lazy = false,
      priority = 1000,
      config = function()
        vim.g.gruvbox_material_enable_italic = false
        vim.o.background = 'dark' -- 'dark' or 'light'
        vim.g.gruvbox_material_background = 'medium' -- 'soft', 'medium' or 'hard'
        --vim.g.gruvbox_material_better_performance = 1
      end
    },

    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    { -- Collection of various small independent plugins/modules
      'echasnovski/mini.nvim',

      config = function()
        --local statusline = require 'mini.statusline'
        -- set use_icons to true if you have a Nerd Font
        -- statusline.setup { use_icons = vim.g.have_nerd_font }

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        --statusline.section_location = function()
        --  return '%2l:%-2v'
        --end

        -- ... and there is more!
        --  Check out: https://github.com/echasnovski/mini.nvim
      end,
    },

    'beyondmarc/hlsl.vim',
    'nvim-telescope/telescope-project.nvim',

    {
      'folke/snacks.nvim',
      priority = 1000,
      lazy = false,
      opts = {
        lazygit = {
          enabled = true,
          configure = true,
          -- Theme for lazygit
          theme = {
              [241]                      = { fg = "Special" },
              activeBorderColor          = { fg = "MatchParen", bold = true },
              cherryPickedCommitBgColor  = { fg = "Identifier" },
              cherryPickedCommitFgColor  = { fg = "Function" },
              defaultFgColor             = { fg = "Normal" },
              inactiveBorderColor        = { fg = "FloatBorder" },
              optionsTextColor           = { fg = "Function" },
              searchingActiveBorderColor = { fg = "MatchParen", bold = true },
              selectedLineBgColor        = { bg = "CursorLine" }, -- set to `default` to have no background colour
              unstagedChangesColor       = { fg = "DiagnosticError" },
          },
          win = {
              style = "lazygit",
          },
        },
        dashboard = {
          enabled = true,

          preset = {
              keys = {
                  { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                  { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                  { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                  { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                  { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                  { icon = "🗁", key = "p", desc = "Projects", action = function()
                      require("persistence").select()
                  end},
                  { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                  { icon = " ", key = "q", desc = "Quit", action = ":qa" },
              },
          },
        },
        notifier = {
        },
      }
    },

    {
      "folke/persistence.nvim",
      event = "BufReadPre", -- this will only start session saving when an actual file was opened
      opts = {
        -- add any custom options here
      },
    },

    {
      'folke/which-key.nvim',
      event = "VeryLazy",
      opts = {
      },
    },

    {
        'mfussenegger/nvim-dap',
    },

    {
        'rcarriga/nvim-dap-ui',
        dependencies = {'nvim-neotest/nvim-nio'},
    },

    'theHamsta/nvim-dap-virtual-text',

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local HEIGHT_RATIO = 0.8  -- You can change this
            local WIDTH_RATIO = 0.5   -- You can change this too

            require('nvim-tree').setup({
                view = {
                    float = {
                        enable = true,
                        open_win_config = function()
                            local screen_w = vim.opt.columns:get()
                            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                            local window_w = screen_w * WIDTH_RATIO
                            local window_h = screen_h * HEIGHT_RATIO
                            local window_w_int = math.floor(window_w)
                            local window_h_int = math.floor(window_h)
                            local center_x = (screen_w - window_w) / 2
                            local center_y = ((vim.opt.lines:get() - window_h) / 2)
                            - vim.opt.cmdheight:get()
                            return {
                                border = 'rounded',
                                relative = 'editor',
                                row = center_y,
                                col = center_x,
                                width = window_w_int,
                                height = window_h_int,
                            }
                        end,
                    },
                    width = function()
                        return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                    end,
                },
            })
        end,
    },
  },

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "gruvbox-material" } },
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false },
})

require('telescope').setup{
  defaults = {
    file_ignore_patterns = { ".cache", ".git" }
  },
}

vim.lsp.enable('clangd')
vim.lsp.enable('lua_ls')


local signs = {
    Error = " ",
    Warn = " ",
    Hint = "󰌵 ",
    Info = " "
}

local signConf = {
  text = {},
  texthl = {},
  numhl = {},
}

for type, icon in pairs(signs) do
  local severityName = string.upper(type)
  local severity = vim.diagnostic.severity[severityName]
  local hl = "DiagnosticSign" .. type
  signConf.text[severity] = icon
  signConf.texthl[severity] = hl
  signConf.numhl[severity] = hl
end

vim.diagnostic.config({
  signs = signConf,
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', function()
    if vim.fn.isdirectory(vim.fn.getcwd()..'/code') ~= 0 then
        builtin.find_files { cwd = vim.fn.getcwd()..'/code' }
    else
        builtin.find_files { cwd = vim.fn.getcwd() }
    end
end, { desc = 'Telescope find files in code folder' })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope keymaps' })
vim.keymap.set('n', '<leader>fv', function()
    builtin.find_files { cwd = vim.fn.stdpath('config') }
end, { desc = 'Telescope find vim config files' })

vim.keymap.set('n', '<leader>gg', function()
    Snacks.lazygit.open({})
end, { desc = 'open lazygit' })
vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Telescope git commits' })
vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = 'Telescope git branches' })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Telescope git status' })
vim.keymap.set('n', '<m-k>', '<C-o>', { desc = 'jump back' })

vim.keymap.set('n', '<leader>dt', function()
    vim.cmd('NvimTreeToggle')
end, { desc = 'Nvim-tree toggle' })
vim.keymap.set('n', '<leader>df', function()
    vim.cmd('NvimTreeFindFile')
end, { desc = 'Nvim-tree find file' })

require('which-key').add({
  { '<leader>f', group = 'find' },
  { '<leader>g', group = 'git' },
  { '<leader>d', group = 'nvim-tree' },
})

vim.diagnostic.config({
  virtual_text = true,
})

-- edit-compile-edit loop
function BuildProject()
  vim.cmd("wa")  -- save all files
  vim.fn.setqflist({})  -- clear quickfix
  vim.cmd("botright copen") -- open quickfix
  vim.cmd("wincmd p") -- get cursor out of quickfix window 

  --vim.notify("⏳ Build started ...", vim.log.levels.INFO)

  local build_script
  local os_name = vim.loop.os_uname().sysname
  if string.find(os_name, 'Windows') ~= nil then
      build_script = "./code/build.bat"
  else
      build_script = "./code/build.sh"
  end

  vim.fn.jobstart({ build_script }, {
    --cwd = parent_folder,
    stdout_buffered = false,
    stderr_buffered = false,

    on_stdout = function(_, data)
      if data then
        vim.fn.setqflist({}, 'a', { lines = data })
        --vim.cmd("cwindow")
      end
    end,

    on_stderr = function(_, data)
      if data then
        vim.fn.setqflist({}, 'a', { lines = data })
        --vim.cmd("cwindow")
      end
    end,

    on_exit = function(_, code)
      local errorCount = 0
      for k, v in pairs(vim.fn.getqflist()) do
          if v.valid == 1 then
              errorCount = errorCount + 1
          end
      end
      if code == 0 and errorCount == 0 then
        vim.notify("✅ Build succeeded", vim.log.levels.INFO)
      else
        vim.notify("❌ Build failed", vim.log.levels.ERROR)
      end
    end
  })
end
vim.keymap.set("n", "<m-m>", BuildProject, { noremap = true, silent = true, desc = "Build Project" })
vim.keymap.set('n', '<m-n>', ':cn<CR>', { desc = "go to next quickfix error" })
vim.keymap.set('n', '<m-p>', ':cp<CR>', { desc = "go to previous quickfix error" })
vim.keymap.set('n', '<m-,>', ':cclose<CR>', { desc = "close quickfix window" })

-- https://emojipedia.org/en/stickers/search?q=circle
vim.fn.sign_define('DapBreakpoint',
{
    text = '🔴',
    texthl = 'DapBreakpointSymbol',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
})

vim.fn.sign_define("DapStopped",
{
    text = "➡️",
    texthl = "DiagnosticWarn",
    linehl = "",
    numhl = "",
})

vim.fn.sign_define('DapBreakpointRejected',
{
    text = '⭕',
    texthl = 'DapStoppedSymbol',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
})

vim.keymap.set('n', '<m-o>', ':LspClangdSwitchSourceHeader<CR>', { desc = "clangd switch header" })
vim.lsp.config('clangd', {
    cmd = { 'clangd', '--header-insertion=never' }
})

-- LSP for neovim scripting purposes
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

-- interactive terminal
vim.keymap.set('n', '<leader>t', function()
    vim.cmd('botright 15split | term')
    vim.cmd('startinsert')
end, { desc = "open terminal" })

-- project (old)
--[[
vim.keymap.set('n', '<leader>po', function()
    require('telescope').extensions.project.project{}
end, { desc = "project picker" })
]]--

-- select a session to load
vim.keymap.set("n", "<leader>p", function()
    require("persistence").select()
end, { desc = "project session picker" })

-- DAP debugger
local dap = require('dap')
dap.adapters.codelldb = {
    type = 'executable',
    command = 'codelldb',
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            local target_filepath = vim.fn.getcwd()..'/nvim-dap-cpp-target.txt'
            local target_file = io.open(target_filepath, 'r')
            if target_file then
                local target_path = target_file:read()
                target_file:close()
                vim.notify("using exe path: "..target_path, vim.log.levels.INFO)
                return target_path
            else
                local target_path = vim.fn.input('Path to exe: ', vim.fn.getcwd() .. '/', 'file')
                local f = io.open(target_filepath, 'w')
                if f then
                    f:write(target_path)
                    f:close()
                else
                    vim.notify("failed to save choice of exe path to "..target_filepath, vim.log.levels.WARN)
                end
                return target_path
            end
        end,
        args = {},
        cwd = function()
            return vim.fn.getcwd() .. "/build"
        end,
        stopOnEntry = false,
    }
}

vim.keymap.set('n', '<F5>', dap.continue, { desc = "DAP: continue" })
vim.keymap.set('n', '<s-F5>', dap.terminate, { desc = "DAP: terminate" })
vim.keymap.set('n', '<F10>', dap.step_over, { desc = "DAP: step over" })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = "DAP: step into" })
vim.keymap.set('n', '<F12>', dap.step_out, { desc = "DAP: step out" })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = "DAP: toggle breakpoint" })

local dapui = require('dapui')
dapui.setup({
    controls = { enabled = false, },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = "rounded",
      mappings = { close = { "q", "<Esc>" } }
    },
    force_buffers = true,
    icons = {
      collapsed = "",
      current_frame = "",
      expanded = ""
    },
    layouts = { {
        elements = { {
            id = "watches",
            size = 0.5
          }, {
            id = "stacks",
            size = 0.5
          }, },
        position = "right",
        size = 40
      },
      {
        elements = { {
            id = "console",
            size = 1.0
          }, },
        position = "bottom",
        size = 10
      },
    },
    mappings = {
      edit = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      repl = "r",
      toggle = "t"
    },
    render = {
      indent = 1,
      max_value_lines = 100
    }
})

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

vim.keymap.set('n', '<leader>?', function()
    dapui.eval()
    dapui.eval()
end, { desc = "DAP: eval expression" })

require("nvim-dap-virtual-text").setup()

require('lualine').setup {
    options = {
        theme = 'gruvbox-material',
    }
}

--vim.cmd.colorscheme('gruvbox-material')

-- my colorscheme
--local hm_default = "#D5B98F"
local hm_default = "#CDAA7D"
local hm_bg = "#1F1F1F"
local hm_red = "#CF5555"
local hm_green = "#7B9E33"
local hm_light_green = "#40FF40"
local hm_gold = "#DDAD3C"
vim.api.nvim_set_hl(0, 'Normal', { fg = hm_default, bg = hm_bg })
vim.api.nvim_set_hl(0, 'NormalFloat', { fg = hm_default, bg = hm_bg })
vim.api.nvim_set_hl(0, 'Comment', { fg = "#7F7F7F" })
vim.api.nvim_set_hl(0, 'Identifier', { fg = hm_default })
vim.api.nvim_set_hl(0, 'Function', { fg = hm_default })
vim.api.nvim_set_hl(0, '@variable', { fg = hm_default })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = hm_default })
vim.api.nvim_set_hl(0, 'Constant', { fg = hm_green })
vim.api.nvim_set_hl(0, 'String', { link = "Constant" })
vim.api.nvim_set_hl(0, 'Statement', { fg = hm_gold })
vim.api.nvim_set_hl(0, 'PreProc', { fg = hm_gold })
vim.api.nvim_set_hl(0, 'Operator', { fg = hm_gold })
vim.api.nvim_set_hl(0, 'Type', { fg = hm_gold })
vim.api.nvim_set_hl(0, 'Special', { fg = hm_gold })
vim.api.nvim_set_hl(0, 'Directory', { fg = hm_gold })
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = "#DD5555" })
vim.api.nvim_set_hl(0, 'Title', { fg = hm_default })

vim.api.nvim_set_hl(0, 'TodoBgTODO', { fg = hm_bg, bg = "#DD5555" })
vim.api.nvim_set_hl(0, 'TodoFgTODO', { fg = "#DD5555" })

-- TODO:
-- segmentation fault message is absent when crashing in DAP
-- get dap-virtual-text to work
-- build notification should be closer to active panel
