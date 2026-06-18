return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local codelens_group = vim.api.nvim_create_augroup("lsp-codelens-refresh", { clear = true })
      local open_diagnostic_float = function()
        vim.diagnostic.open_float({
          border = "rounded",
          source = "if_many",
          max_width = math.max(40, vim.api.nvim_win_get_width(0) - 8),
        })
      end

      vim.diagnostic.config({
        severity_sort = true,
        update_in_insert = false,
        underline = true,
        signs = true,
        virtual_text = false,
        virtual_lines = {
          current_line = true,
        },
        float = {
          border = "rounded",
          source = "if_many",
          max_width = 100,
        },
      })

      vim.lsp.config("roslyn", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        settings = {
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
          },
          ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true,
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local opts = { buffer = event.buf }

          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gR", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gl", open_diagnostic_float, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
            vim.lsp.codelens.refresh({ bufnr = event.buf })

            vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
              group = codelens_group,
              buffer = event.buf,
              callback = function()
                vim.lsp.codelens.refresh({ bufnr = event.buf })
              end,
            })
          end
        end,
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = { preset = "default" },
    },
  },
  {
    "seblyng/roslyn.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {},
  },
}
