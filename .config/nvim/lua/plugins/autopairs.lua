return {
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true,
		opts = {
			check_ts = true,
		}
	},
	{
		'windwp/nvim-ts-autotag',
		event = { 'BufReadPre', 'BufNewFile' },
		config = true,
	}
}

