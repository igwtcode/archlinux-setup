local wezterm = require("wezterm")
local act = wezterm.action
local config = {}
local font_name = "MesloLGM Nerd Font"

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.dpi = 144
config.scrollback_lines = 9000
config.audible_bell = "Disabled"
config.default_cursor_style = "BlinkingBar"
config.cursor_thickness = 3
config.force_reverse_video_cursor = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.window_background_opacity = 0.72
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.window_frame = { font_size = 16 }
config.window_padding = { left = 0, bottom = 0, top = 0, right = 0 }

-- config.line_height = 1.1
config.font_size = 17
config.font = wezterm.font_with_fallback({
	font_name,
	{ family = font_name, italic = true },
})

config.keys = {
	{ key = "f", mods = "CMD|CTRL", action = act.ToggleFullScreen },
}

config.mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

return config
