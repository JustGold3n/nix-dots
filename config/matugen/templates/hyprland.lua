-- config/matugen/templates/hyprland.lua

local bg = "rgb({{ colors.background.default.hex_stripped }})"
local border =
	"rgba({{ colors.outline.default.hex_stripped }}88) rgba({{ colors.background.default.hex_stripped }}ff) 45deg"
local primary = "rgb({{ colors.primary.default.hex_stripped }})"
local error_color = "rgb({{ colors.error.default.hex_stripped }})"

hl.config({
	general = {
		["col.active_border"] = border,
		["col.inactive_border"] = bg,
	},
	group = {
		["col.border_active"] = border,
		["col.border_inactive"] = bg,
		["col.border_locked_active"] = error_color,
		["col.border_locked_inactive"] = bg,
		groupbar = {
			["col.active"] = primary,
			["col.inactive"] = bg,
			["col.locked_active"] = error_color,
			["col.locked_inactive"] = bg,
		},
	},
})
