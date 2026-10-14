-- apt install curl git tmux fonts-anonymous-pro fish fzf lazygit luarocks cargo ruby rubygems nodejs python3-pip kitty imagemagick npm
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Put into ~/.config/nvim/lua/config/options.lua
--   for better solution
--vim.o.fileencodings = "utf-8,ucs-bom,gbk,gb18030,cp936,latin1"
-- vim.opt.fileencodings = "ucs-bom,utf-8,gb18030,gbk,cp936,shift-jis,euc-jp,euc-kr,latin1"
vim.opt.fileencodings = "ucs-bom,utf-8,gb18030,gbk,cp936,shift-jis,euc-jp,euc-kr,latin1"
