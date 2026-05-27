return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local group = vim.api.nvim_create_augroup("treesitter_features", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          if not pcall(vim.treesitter.start, args.buf) then
            return
          end

          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
