-- init.lua

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("core.options")
require("core.keymaps")
require("core.plugins")
require("core.plugin_config")
