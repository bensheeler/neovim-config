return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.cmd("Neotree filesystem reveal left")
			end,
		})

		vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle left<CR>", {})
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
	end,
}
