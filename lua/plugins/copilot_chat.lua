return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "github/copilot.vim" },
	},
	cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatExplain" },
	keys = {
		{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
		{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Explain Code" },
	},
	config = function()
		require("CopilotChat").setup()
	end,
}
