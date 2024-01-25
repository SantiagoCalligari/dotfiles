return {
	"adalessa/laravel.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"tpope/vim-dotenv",
		"MunifTanjim/nui.nvim",
		"windwp/nvim-ts-autotag",
	},
	cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
	keys = {
		{ "<leader>la", ":Sail artisan<cr>" },
		{ "<leader>lr", ":Sail routes<cr>" },
		{ "<leader>lm", ":Sail related<cr>" },
		{
			"<leader>lt",
			function()
				require("laravel.tinker").send_to_tinker()
			end,
			mode = "v",
			desc = "Laravel Application Routes",
		},
	},
	event = { "VeryLazy" },
	config = function()
		require("laravel").setup()
		require("telescope").load_extension("laravel")
	end,
}
