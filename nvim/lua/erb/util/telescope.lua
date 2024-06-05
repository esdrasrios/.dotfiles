local M = {}

---@param bufnr number? default is current buffer
---@return string | nil
local function get_root_by_lsp(bufnr)
	bufnr = bufnr or 0
	local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
	local clients = get_clients({ bufnr = bufnr })
	if #clients == 0 or not clients[1].config or not clients[1].config.workspace_folders then
		return nil
	end
	return clients[1].config.workspace_folders[1].name
end

---@param bufnr number? default is current buffer
---@return string
function M.get_root(bufnr)
	bufnr = bufnr or 0

	-- get root by lsp
	local root = get_root_by_lsp(bufnr)
	if root then
		return root
	end

	-- get by pattern
	local patterns = {
		".git",
		".svn",
		"package.json",
		"Cargo.toml",
		"requirements.txt",
		"Makefile",
		"CMakeLists.txt",
		".gitignore",
	}
	local path = vim.api.nvim_buf_get_name(bufnr)
	if path == "" then
		path = vim.loop.cwd() --[[@as string]]
	end
	root = vim.fs.find(patterns, { path = path, upward = true })[1]
	root = root and vim.fs.dirname(root) or vim.loop.cwd() --[[@as string]]
	return root
end

-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
	local params = { builtin = builtin, opts = opts }
	return function()
		builtin = params.builtin
		opts = params.opts
		opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
		if builtin == "files" then
			if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
				opts.show_untracked = true
				builtin = "git_files"
			else
				builtin = "find_files"
			end
		end
		if opts.cwd and opts.cwd ~= vim.loop.cwd() then
			opts.attach_mappings = function(_, map)
				map("i", "<a-c>", function()
					local action_state = require("telescope.actions.state")
					local line = action_state.get_current_line()
					M.telescope(
						params.builtin,
						vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line })
					)()
				end)
				return true
			end
		end

		require("telescope.builtin")[builtin](opts)
	end
end

function M.extension(extension, opts)
	return function()
		local telescope = require('telescope')
		telescope.load_extension(extension)
		return telescope.extensions[extension](opts)
	end
end

return M
