-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup(
    {
        {
            "joshdick/onedark.vim",
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd([[colorscheme onedark]])
            end,
        },
        {
            "neovim/nvim-lspconfig",
            config = function()
                local lspconfig = require("lspconfig")

                lspconfig.lua_ls.setup({
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                        },
                    },
                })
                lspconfig.zls.setup({})
                lspconfig.dartls.setup({})
            end,
        },
        {
            "L3MON4D3/LuaSnip",
        },
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-nvim-lsp",
                "saadparwaiz1/cmp_luasnip",
            },
        },
        {
            "vim-airline/vim-airline",
        },
        {
            "dstein64/vim-startuptime",
        },
    }
)

-- Autocomplete
vim.opt.completeopt = { "menu", "menuone", "noselect" }

require("luasnip.loaders.from_vscode").lazy_load();

local cmp = require("cmp")
local luasnip = require("luasnip")

local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.expand(args.body)
        end,
    },
    sources = {
        {name = "path"},
        {name = "nvim_lsp", keyword_length = 1},
        {name = "buffer", keyword_lenght = 3},
        {name = "luasnip", keyword_length = 2},
    },
    window = {
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        fields = { "menu", "abbr", "kind" },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = "λ",
                luasnip = "⋗",
                buffer = "Ω",
                path = "",
            }

            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
    mapping = {
        ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
        ["<Down>"] = cmp.mapping.select_next_item(select_opts),
        ["<CR>"] = cmp.mapping.confirm({select = false}),
        ["<C-Space>"] = cmp.mapping.confirm({select = true}),
    },
})

-- Vars
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.o.textwidth = 80 -- Wrap at 80 chars
vim.opt.formatoptions:remove { "t" } -- Only wrap comments
vim.o.number = true -- Line numbers
