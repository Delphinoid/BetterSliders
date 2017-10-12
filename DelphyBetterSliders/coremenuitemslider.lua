core:module("CoreMenuItemSlider")
core:import("CoreMenuItem")

local DEFAULT_STEP = 0.01
local DEFAULT_DECIMAL_COUNT = 2
local STATIC_STEP = 0.0001
local STATIC_DECIMAL_COUNT = 4

function ItemSlider:init(data_node, parameters)
	CoreMenuItem.Item.init(self, data_node, parameters)
	self._type = "slider"
	self._min = 0
	self._max = 1
	self._step = DEFAULT_STEP
	self._show_value = true
	self._is_percentage = false
	self._show_slider_text = true
	self._decimal_count = DEFAULT_DECIMAL_COUNT
	if data_node then
		self._min = data_node.min or self._min
		self._max = data_node.max or self._max
	end
	self._min = tonumber(self._min)
	self._max = tonumber(self._max)
	self._step = tonumber(self._step)
	self._decimal_count = tonumber(self._decimal_count)
	self._slider_color = _G.tweak_data.screen_colors.button_stage_3
	self._slider_color_highlight = _G.tweak_data.screen_colors.button_stage_2
	self._value = self._min
end

function ItemSlider:set_value(value)
	self._value = tonumber(string.format("%." .. self._decimal_count .. "f", value))
	self:dirty()
end

function ItemSlider:set_value_granular(value)
	self._value = value
	self:dirty()
end

function ItemSlider:set_step(value)
	self._step = STATIC_STEP
end

function ItemSlider:set_decimal_count(value)
	self._decimal_count = STATIC_DECIMAL_COUNT
end

function ItemSlider:increase()
	self:set_value(self._value + self._step)
end

function ItemSlider:decrease()
	self:set_value(self._value - self._step)
end

function ItemSlider:reload(row_item, node)
	if not row_item then
		return
	end
	local value = self._value
	row_item.gui_slider_text:set_text(value)
	row_item.gui_slider_text:set_visible(self._show_slider_text)
	local where = row_item.gui_slider:left() + row_item.gui_slider:w() * (self:percentage() / 100)
	row_item.gui_slider_marker:set_center_x(where)
	row_item.gui_slider_gfx:set_w(row_item.gui_slider:w() * (self:percentage() / 100))
	row_item.gui_slider_gfx:set_gradient_points({
		0,
		self:slider_color(),
		1,
		self:slider_color()
	})
	return true
end