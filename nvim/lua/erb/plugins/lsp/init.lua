local runtime_path = vim.split(package.path, ';')

table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local path = {
    '/Users/esdrasriosbaia/.config/nvim',
    '/Users/esdrasriosbaia/.local/share/nvim/store/neodev.nvim',
    '/Users/esdrasriosbaia/.local/share/nvim/store/hlchunk.nvim',
}

return {
    { 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim' },
    { 'onsails/lspkind.nvim' },
    -- { 'nvimdev/lspsaga.nvim' },
    {
        'mrcjkb/rustaceanvim',
        -- enabled = false,
        version = '^4',
        ft = { 'rust' },
        opts = {
            tools = {
                hover_actions = {
                    auto_focus = true,
                },
                autoSetHints = true,
                hover_with_actions = true,
                runnables = {
                    use_telescope = true,
                },
                inlay_hints = {
                    only_current_line = false,
                    refresh_timeout = 1000,
                },
                type_inlay_hints = {
                    show_parameter_hints = true,
                    parameter_hints_prefix = '<-',
                    other_hints_prefix = '=>',
                },
            },
            server = {
                on_attach = function(client, bufnr)
                    require('erb.plugins.lsp.on_attach').on_attach(
                        client,
                        bufnr
                    )
                    vim.keymap.set('n', '<leader>a', function()
                        vim.cmd.RustLsp 'codeAction'
                    end, { silent = true, buffer = bufnr })
                end,
                settings = {
                    ['rust-analyzer'] = {
                        procMacro = {
                            enable = true,
                        },
                        assist = {
                            importEnforceGranularity = true,
                            importPrefix = 'crate',
                        },
                        cargo = { allFeatures = true },
                        inlayHints = {
                            lifetimeElisionHints = {
                                enable = true,
                                useParameterNames = true,
                            },
                        },
                        checkOnSave = {
                            allFeatures = true,
                            command = 'clippy',
                            extraArgs = { '--no-deps' },
                        },
                        diagnostics = {
                            disabled = { 'inactive-code' },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            vim.g.rustaceanvim = vim.tbl_deep_extend('force', {}, opts or {})
        end,
    },
    {
        'neovim/nvim-lspconfig',
        -- enabled = false,
        dependencies = {
            'joechrisellis/lsp-format-modifications.nvim',
            'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim',
            'jose-elias-alvarez/typescript.nvim',
            'pmizio/typescript-tools.nvim',
            'marilari88/twoslash-queries.nvim',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            -- "simrat39/rust-tools.nvim",
        },
        opts = {
            inlay_hints = {
                enable = true,
                only_current_line = true,
            },
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                version = 'LuaJIT',
                                path = runtime_path,
                            },
                            diagnostics = {
                                globals = { 'vim' },
                            },
                            workspace = {
                                library = path,
                                checkThirdParty = true,
                            },
                        },
                    },
                },
                typescript = {
                    settings = {
                        separate_diagnostic_server = true,
                        publish_diagnostic_on = 'insert_leave',
                        expose_as_code_action = 'all',
                        tsserver_plugins = {},
                        disable_member_code_lens = true,
                        tsserver_file_preferences = {
                            includeInlayParameterNameHints = 'literals',
                            includeInlayVariableTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            quotePreference = 'single',
                        },
                        tsserver_format_options = {
                            allowIncompleteCompletions = false,
                            allowRenameOfImportPath = false,
                            quotePreference = 'single',
                        },
                    },
                },
                typescript_tools = {
                    settings = {},
                },
                tsserver = {
                    disable_commands = false,
                    debug = false,
                    go_to_source_definition = {
                        fallback = true,
                    },
                    settings = {
                        javascript = {
                            inlayHints = {
                                includeInlayEnumMemberValueHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayParameterNameHints = 'all',
                                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayVariableTypeHints = true,
                            },
                        },
                        typescript = {
                            inlayHints = {
                                includeInlayEnumMemberValueHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayParameterNameHints = 'all',
                                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayVariableTypeHints = true,
                            },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            require('neodev').setup()
            local servers = opts.servers
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            require('mason').setup()
            require('mason-lspconfig').setup {
                -- ensure_installed = { "prettier", "eslint", "eslint_d" },
                handlers = {
                    function(server)
                        local server_opts = vim.tbl_deep_extend('force', {
                            on_attach = function(client, bufnr)
                                require('erb.plugins.lsp.on_attach').on_attach(
                                    client,
                                    bufnr
                                )
                            end,
                            capabiltiies = capabilities,
                        }, servers[server] or {})

                        if server == 'tsserver' then
                            return require('typescript').setup {
                                server = {
                                    on_attach = function(client, bufnr)
                                        require('erb.plugins.lsp.on_attach').on_attach(
                                            client,
                                            bufnr
                                        )
                                    end,
                                    settings = {
                                        javascript = {
                                            inlayHints = {
                                                includeInlayEnumMemberValueHints = true,
                                                includeInlayFunctionLikeReturnTypeHints = true,
                                                includeInlayFunctionParameterTypeHints = true,
                                                includeInlayParameterNameHints = 'all',
                                                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                                includeInlayPropertyDeclarationTypeHints = true,
                                                includeInlayVariableTypeHints = true,
                                            },
                                        },
                                        typescript = {
                                            inlayHints = {
                                                includeInlayEnumMemberValueHints = true,
                                                includeInlayFunctionLikeReturnTypeHints = true,
                                                includeInlayFunctionParameterTypeHints = true,
                                                includeInlayParameterNameHints = 'all',
                                                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                                includeInlayPropertyDeclarationTypeHints = true,
                                                includeInlayVariableTypeHints = true,
                                            },
                                        },
                                    },
                                },
                                disable_commands = false,
                                debug = false,
                                go_to_source_definition = {
                                    fallback = true,
                                },
                            }

                            --[[ return require('typescript-tools').setup({
								on_attach = function(client, bufnr)
									require('erb.plugins.lsp.on_attach').on_attach(client, bufnr)
								end,
								capabilities = capabilities,
								settings = {
									separate_diagnostic_server = true,
									-- "change"|"insert_leave" determine when the client asks the server about diagnostic
									publish_diagnostic_on = 'insert_leave',
									expose_as_code_action = 'all',
									tsserver_plugins = {},
									-- complete_function_calls = true,
									-- include_completions_with_insert_text = true,
									-- CodeLens
									-- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
									-- possible values: ("off"|"all"|"implementations_only"|"references_only")
									-- code_lens = 'all',
									-- by default code lenses are displayed on all referencable values and for some of you it can
									-- be too much this option reduce count of them by removing member references from lenses
									disable_member_code_lens = true,
									tsserver_file_preferences = {
										includeInlayParameterNameHints = 'literals',
										includeInlayVariableTypeHints = true,
										includeInlayFunctionLikeReturnTypeHints = true,
										quotePreference = 'single',
									},
									tsserver_format_options = {
										allowIncompleteCompletions = false,
										allowRenameOfImportPath = false,
										quotePreference = 'single',
									},
								}
							}) ]]
                        end

                        if server == 'rust_analyzer' then
                            return
                        end

                        require('lspconfig')[server].setup(server_opts)
                    end,
                },
            }
        end,
    },
}
