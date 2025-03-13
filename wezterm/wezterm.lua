local wezterm = require("wezterm")

return {
	-- 基础配置
	color_scheme = "Builtin Solarized Dark", -- 选择你喜欢的配色方案
	enable_kitty_graphics = true, -- 启用真彩色支持
	default_prog = { "powershell.exe" }, -- 使用 login shell
	send_composed_key_when_left_alt_is_pressed = true,

	-- 鼠标支持
	enable_wayland = false,
	enable_scroll_bar = true,
	mouse_bindings = {
		{
			event = { Down = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = wezterm.action.SelectTextAtMouseCursor("Cell"),
		},
	},

	-- 滚动历史
	scrollback_lines = 10000,

	-- 键盘绑定
	disable_default_key_bindings = true,
	leader = { key = "s", mods = "CTRL" },
	keys = {
		-- 基础快捷键
		{ key = "s", mods = "CTRL", action = wezterm.action.SendKey({ key = "s", mods = "CTRL" }) },
		{ key = "r", mods = "LEADER", action = "ReloadConfiguration" },

		-- 窗格管理
		{ key = "v", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "p", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
		{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
		{ key = "H", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 3 }) },
		{ key = "J", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 3 }) },
		{ key = "K", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 3 }) },
		{ key = "L", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 3 }) },
		{ key = "q", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
		-- 标签页管理
		{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
		{ key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
		{ key = "n", mods = "ALT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
		{ key = "1", mods = "ALT", action = wezterm.action.ActivateTab(0) },
		{ key = "2", mods = "ALT", action = wezterm.action.ActivateTab(1) },
		{ key = "3", mods = "ALT", action = wezterm.action.ActivateTab(2) },
		{ key = "4", mods = "ALT", action = wezterm.action.ActivateTab(3) },
		{ key = "5", mods = "ALT", action = wezterm.action.ActivateTab(4) },
		{ key = "6", mods = "ALT", action = wezterm.action.ActivateTab(5) },
		{ key = "7", mods = "ALT", action = wezterm.action.ActivateTab(6) },
		{ key = "8", mods = "ALT", action = wezterm.action.ActivateTab(7) },
		{ key = "9", mods = "ALT", action = wezterm.action.ActivateTab(8) },

    { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
	},


	-- 外观配置
	font_size = 12.0,
	window_padding = {
		left = 2,
		right = 2,
		top = 2,
		bottom = 2,
	},
	window_frame = {
		active_titlebar_bg = "#333333",
		inactive_titlebar_bg = "#333333",
	},
	colors = {
		tab_bar = {
			active_tab = {
				bg_color = "#333333",
				fg_color = "#5eacd3",
			},
			inactive_tab = {
				bg_color = "#1e1e1e",
				fg_color = "#888888",
			},
		},
	},
}
