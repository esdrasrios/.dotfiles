local wezterm = require 'wezterm'
local mux = wezterm.mux
local project_dir = wezterm.home_dir .. '/code'

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end
config.window_padding = {
	left = '2.5cell',
	right = '2.5cell',
	top = '0.5cell',
	bottom = '1cell',
}
config.window_decorations = 'RESIZE'

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
-- config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular', italic = false })
--[[ config.font_rules = {
	{
		intensity = 'Bold',
		italic = false,
		font = wezterm.font('Iosevka Nerd Font', { weight = 'Bold', italic = false }),
	},
} ]]
--[[ config.font = wezterm.font('Iosevka Nerd Font', { weight = 'Regular', italic = false })
config.font_rules = {
	{
		intensity = 'Bold',
		italic = false,
		font = wezterm.font('Iosevka Nerd Font', { weight = 'Bold', italic = false }),
	},
} ]]
config.font = wezterm.font('Berkeley Mono Variable')
config.font_rules = {
	{
		intensity = 'Bold',
		italic = false,
		font = wezterm.font('Berkeley Mono')
	}
}
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.font_size = 20
config.line_height = 1.2

config.color_scheme = 'Framer'
config.colors = {
	cursor_bg = '#ffffff',
}
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}
config.window_background_opacity = 0.97
config.default_cursor_style = 'SteadyBlock'
-- config.window_background_opacity = 0.9
-- config.window_background_opacity = 1

-- config.macos_window_background_blur = 5
config.native_macos_fullscreen_mode = true
config.keys = {
	{
		key = 'w',
		mods = 'SUPER',
		action = wezterm.action.CloseCurrentPane { confirm = true },
	},
	{
		key = 'd',
		mods = 'SUPER',
		action = wezterm.action.SplitHorizontal,
	},
	{
		key = 'Enter',
		mods = 'SUPER',
		action = wezterm.action.SplitVertical,
	},
	{
		key = 'n',
		mods = 'SHIFT|CTRL',
		action = wezterm.action.Nop,
	},
}

--[[ wezterm.on('gui-startup', function(cmd)
	local tab, pane, window = mux.spawn_window {
		workspace = 'coding',
		cwd = project_dir,
	}
	window:gui_window():toggle_fullscreen()
end) ]]

wezterm.on('user-var-changed', function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == 'ZEN_MODE' then
		local incremental = value:find '+'
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

return config
