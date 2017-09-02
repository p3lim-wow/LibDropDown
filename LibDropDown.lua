local MAJOR, MINOR = 'LibDropDown', 1
assert(LibStub, MAJOR .. ' requires LibStub')

local lib, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if(not lib) then
	return
end

local styles = {}
local dropdowns = {}

--[[### LDD:NewMenu(_parent_, _name_)

Creates a new, empty dropdown.

- `parent`: Frame for parenting. _(frame/string)_
- `name`: Global name for the menu. Falls back to `parent` name with suffix. _(string)_

#### Returns
- `Menu`: Menu object
--]]
function lib:NewMenu(parent, name)
	assert(parent, 'A menu requires a given parent')

	if(type(parent) == 'string') then
		parent = _G[parent]
	end

	local Menu = CreateFrame('Button', (name or parent:GetDebugName() .. 'Menu'), parent, 'LibDropDownMenuTemplate')
	LibDropDownMenuMixin.OnLoad(Menu)

	dropdowns[Menu] = true
	return Menu
end

--[[### LDD:CloseAll(_ignore_)

Closes all open dropdowns, even ones made with [Blizzard voodoo](https://www.townlong-yak.com/framexml/live/UIDropDownMenu.lua).

- `ignore`: Menu to ignore when hiding _(frame/string)_
--]]
function lib:CloseAll(ignore)
	if(type(ignore) == 'string') then
		ignore = _G[ignore]
	end

	-- hide blizzard's
	securecall('CloseDropDownMenus')

	-- hide ours
	for menu in next, dropdowns do
		if(menu ~= ignore) then
			menu:Hide()
		end
	end
end

--[[### LDD:RegisterStyle(_name, data_)

Register a style for use with `Button:SetStyle(name)` and `Menu:SetStyle(name)`.

- `name`: Any name _(string)_
- `data`: Table containing (all optional) values:
	- `gap`: space between submenus _(number)_
	- `padding`: space between menu contents and backdrop border _(number)_
	- `spacing`: space between lines in menus _(number)_
	- `backdrop`: standard [Backdrop](http://wowprogramming.com/docs/widgets/Frame/SetBackdrop) _(table)_
	- `backdropColor`: color object, see notes _(object)_
	- `backdropBorderColor`: color object, see notes _(object)_
	- `normalFont`: font object, see notes _(object/string)_
	- `highlightFont`: font object, see notes _(object/string)_
	- `disabledFont`: font object, see notes _(object/string)_
	- `titleFont`: font object, see notes _(object/string)_
	- `highlightTexture`: texture path to replace the highlight texture _(string)_
	- `radioTexture`: texture path to replace the radio/checkbox texture _(string)_
	- `expandTexture`: texture path to replace the expand arrow texture _(string)_
#### Notes
- All fonts must be [font objects](http://wowprogramming.com/docs/widgets/Font) (by reference or name).  
  See [CreateFont](http://wowprogramming.com/docs/api/CreateFont), and [SharedXML/SharedFontStyles.xml](https://www.townlong-yak.com/framexml/ptr/SharedFontStyles.xml).
- All colors must be color objects (by reference).  
  See [CreateColor](https://www.townlong-yak.com/framexml/live/go/CreateColor).
- `radioTexture` is dependant on texture coordinates, see [Interface/Common/UI-DropDownRadioChecks](https://github.com/Gethe/wow-ui-textures/blob/live/COMMON/UI-DropDownRadioChecks.PNG).
--]]
function lib:RegisterStyle(name, data)
	styles[name] = data
end

--[[### LDD:IsStyleRegistered(name)

Returns whether a style with the given name is already registered or not _(boolean)_
--]]
function lib:IsStyleRegistered(name)
	return not not styles[name]
end


-- our templated button
LibDropDownButtonMixin = {}
function LibDropDownButtonMixin:OnShow()
	if(not self.Menu) then
		self.Menu = lib:NewMenu(self)
	end
end

function LibDropDownButtonMixin:OnHide()
	lib:CloseAll()
end

--[[### LibDropDownButtonTemplate:Add(...)

See [LibDropDownMenuTemplate:AddLines()]().
--]]
function LibDropDownButtonMixin:Add(...)
	self.Menu:AddLines(...)
end

--[[### LibDropDownButtonTemplate:Remove(...)

See [LibDropDownMenuTemplate:RemoveLine()]().
--]]
function LibDropDownButtonMixin:Remove(...)
	self.Menu:RemoveLine(...)
end

--[[### LibDropDownButtonTemplate:Clear(...)

See [LibDropDownMenuTemplate:ClearLines()]().
--]]
function LibDropDownButtonMixin:Clear()
	self.Menu:ClearLines()
end

--[[### LibDropDownButtonTemplate:Toggle()

See [LibDropDownMenuTemplate:Toggle()]().
--]]
function LibDropDownButtonMixin:Toggle()
	self.Menu:Toggle()
end

--[[### LibDropDownButtonTemplate:SetAnchor(_point, anchor, relativePoint, x, y_)

See [LibDropDownMenuTemplate:SetAnchor(_point, anchor, relativePoint, x, y_)]().
--]]
function LibDropDownButtonMixin:SetAnchor(...)
	self.Menu:SetAnchor(...)
end

--[[### LibDropDownButtonTemplate:GetAnchor()

See [LibDropDownMenuTemplate:GetAnchor()]().
--]]
function LibDropDownButtonMixin:GetAnchor()
	return self.Menu:GetAnchor()
end

--[[### LibDropDownButtonTemplate:SetAnchorCursor(_flag_)

See [LibDropDownMenuTemplate:SetAnchorCursor(_flag_)]().
--]]
function LibDropDownButtonMixin:SetAnchorCursor(...)
	self.Menu:SetAnchorCursor(...)
end

--[[### LibDropDownButtonTemplate:IsAnchorCursor()

See [LibDropDownMenuTemplate:IsAnchorCursor()]().
--]]
function LibDropDownButtonMixin:IsAnchorCursor()
	return self.Menu:IsAnchorCursor()
end

--[[### LibDropDownButtonTemplate:SetStyle(_name_)

See [LibDropDownMenuTemplate:SetStyle(_name_)]().
--]]
function LibDropDownButtonMixin:SetStyle(...)
	self.Menu:SetStyle(...)
end

--[[### LibDropDownButtonTemplate:GetStyle(_name_)

See [LibDropDownMenuTemplate:GetStyle(_name_)]().
--]]
function LibDropDownButtonMixin:GetStyle()
	return self.Menu:GetStyle()
end

--[[### LibDropDownButtonTemplate:SetTimeout(_timeout_)

See [LibDropDownMenuTemplate:SetTimeout(_timeout_)]().
--]]
function LibDropDownButtonMixin:SetTimeout(...)
	self.Menu:SetTimeout(...)
end

--[[### LibDropDownButtonTemplate:GetTimeout()

See [LibDropDownMenuTemplate:GetTimeout()]().
--]]
function LibDropDownButtonMixin:GetTimeout()
	return self.Menu:GetTimeout()
end

--[[### LibDropDownButtonTemplate:SetJustifyH(...)

See [Widget:SetJustifyH](http://wowprogramming.com/docs/widgets/FontInstance/SetJustifyH).
]]
function LibDropDownButtonMixin:SetJustifyH(...)
	self.Text:SetJustifyH(...)
end

--[[### LibDropDownButtonTemplate:GetJustifyH()

See [Widget:GetJustifyH](http://wowprogramming.com/docs/widgets/FontInstance/GetJustifyH).
]]
function LibDropDownButtonMixin:GetJustifyH()
	return self.Text:GetJustifyH()
end

--[[### LibDropDownButtonTemplate:SetText(...)

See [Widget:SetText](http://wowprogramming.com/docs/widgets/Button/SetText).
]]
function LibDropDownButtonMixin:SetText(...)
	self.Text:SetText(...)
end

--[[### LibDropDownButtonTemplate:GetText()

See [Widget:GetText](http://wowprogramming.com/docs/widgets/Button/GetText).
]]
function LibDropDownButtonMixin:GetText()
	return self.Text:GetText()
end

--[[### LibDropDownButtonTemplate:SetFormattedText(...)

See [Widget:SetFormattedText](http://wowprogramming.com/docs/widgets/Button/SetFormattedText).
]]
function LibDropDownButtonMixin:SetFormattedText(...)
	self.Text:SetFormattedText(...)
end


-- our templated menu
LibDropDownMenuMixin = {}
function LibDropDownMenuMixin:OnLoad()
	self.parent = self:GetParent().parent or self
	self.lines = {}
	self.menus = {}

	self:SetStyle()

	table.insert(UIMenus, self:GetDebugName())

	self.anchor = {'TOP', self:GetParent(), 'BOTTOM', 0, -12} -- 8, 22
	self.anchorCursor = false
	self:SetClampRectInsets(-20, 20, 20, -20)

	if(self.parent == self) then
		-- create auto-hide timer on first menu
		local animations = self:CreateAnimationGroup()
		animations:CreateAnimation():SetDuration(self.timeout or 5)
		animations:SetScript('OnFinished', function()
			lib:CloseAll()
		end)
		self.timer = animations
	end
end

function LibDropDownMenuMixin:OnShow()
	-- gather some size data
	local padding = self.parent.padding
	local spacing = self.parent.spacing
	local width = 0
	local height = -spacing

	for _, Line in next, self.lines do
		if(Line:IsShown()) then
			local lineWidth = Line.Text:GetWidth() + 50
			lineWidth = math.max(lineWidth, 100)
			if(lineWidth > width) then
				width = lineWidth
			end

			height = height + (16 + spacing)
		end
	end

	-- make sure all lines are the same width
	for _, Line in next, self.lines do
		Line:SetWidth(width)
	end

	-- resize the entire frame
	self:SetSize(width, height)
	self.Backdrop:SetSize(width + padding * 2, height + padding * 2)

	-- positioning
	self:ClearAllPoints()
	if(self.parent == self) then
		-- this is the first menu
		if(self.parent.anchorCursor) then
			local x, y = GetCursorPosition()
			local scale = UIParent:GetScale()
			self:SetPoint('TOP', UIParent, 'BOTTOMLEFT', x / scale, (y / scale) + 8) -- 8 to let the cursor end up on the first line
		else
			self:SetPoint(unpack(self.parent.anchor))
		end
	else
		-- submenu
		self:SetPoint('TOPLEFT', self:GetParent(), 'TOPRIGHT', self.parent.gap, 0)
	end

	-- start auto-hide timer
	self.parent.timer:Play()
end

function LibDropDownMenuMixin:OnHide()
	-- stop auto-hide timer
	self.parent.timer:Stop()
end

function LibDropDownMenuMixin:OnEnter()
	-- stop auto-hide timer
	self.parent.timer:Stop()
end

function LibDropDownMenuMixin:OnLeave()
	-- start auto-hide timer
	self.parent.timer:Play()
end

--[[### LibDropDownMenuTemplate:Toggle()

Toggles the dropdown menu, closing all others.
--]]
function LibDropDownMenuMixin:Toggle()
	-- hide everything first
	lib:CloseAll(self)

	-- toggle this
	self:SetShown(not self:IsShown())
end

function LibDropDownMenuMixin:UpdateLine(index, data)
	local Line = self.lines[index]
	if(not Line) then
		Line = CreateFrame('Button', nil, self, 'LibDropDownLineTemplate')
		Line:SetPoint('TOPLEFT', 0, -((16 + self.parent.spacing) * (index - 1)))
		Line:OnLoad()

		-- load customization
		Line:SetNormalFontObject(self.parent.normalFont)
		Line:SetHighlightFontObject(self.parent.highlightFont)
		Line:SetDisabledFontObject(self.parent.disabledFont)

		Line.Radio:SetTexture(self.parent.radioTexture)
		Line.Expand:SetTexture(self.parent.expandTexture)
		Line.Highlight:SetTexture(self.parent.highlightTexture)

		table.insert(self.lines, Line)
	end

	Line.func = data.func
	Line.args = data.args
	Line.tooltip = data.tooltip
	Line.tooltipTitle = data.tooltipTitle
	Line.checked = nil
	Line.isRadio = nil
	Line.keepShown = data.keepShown

	Line.Radio:Hide()
	Line.Expand:Hide()
	Line.ColorSwatch:Hide()
	Line.Texture:Hide()

	if(data.isSpacer) then
		Line.Spacer:Show()
		Line:EnableMouse(false)
		return Line
	elseif(data.isTitle) then
		local text = data.text
		assert(text and type(text) == 'string', 'Missing required data "text"')
		Line:SetText(text)
		Line:EnableMouse(false)
		Line:SetNormalFontObject(self.parent.titleFont)
	else
		Line:EnableMouse(true)
		Line.Spacer:Hide()

		if(data.font) then
			Line.Text:SetFont(data.font, data.fontSize or 12, data.fontFlags)
		elseif(data.fontObject) then
			Line:SetNormalFontObject(data.fontObject)
			Line:SetHighlightFontObject(data.fontObject)
			Line:SetDisabledFontObject(data.fontObject)
		else
			Line:SetNormalFontObject(self.parent.normalFont)
			Line:SetHighlightFontObject(self.parent.highlightFont)
			Line:SetDisabledFontObject(self.parent.disabledFont)
		end

		local text = data.text
		assert(text and type(text) == 'string', 'Missing required data "text"')

		Line:SetText(text)
		Line:SetTexture(data.texture, data.textureColor)

		if(data.icon) then
			local width = data.iconWidth or 16
			local height = data.iconHeight or 16
			local fileWidth = data.iconFileWidth or width
			local fileHeight = data.iconFileHeight or height

			local left, right, top, bottom = 0, 1, 0, 1
			if(data.iconTexCoords) then
				left, right, top, bottom = unpack(data.iconTexCoords)
			end

			Line:SetIcon(data.icon, fileWidth, fileHeight, width, height, left, right, top, bottom)
		end

		if(data.atlas) then
			local exists, atlasWidth, atlasHeight = GetAtlasInfo(data.atlas)
			assert(exists, 'No atlas \'' .. exists .. '\' exists')

			local width = data.atlasWidth
			local height = data.atlasHeight

			if(not height) then
				-- default to line height
				height = 16
			end

			if(not width) then
				-- keeping aspect ratio of the atlas
				width = (atlasWidth / atlasHeight) * height
			end

			local x = data.atlasOffsetX or data.atlasOffset or 0
			local y = data.atlasOffsetY or data.atlasOffset or 0

			Line:SetAtlas(data.atlas, height, width, x, y)
		end

		if(data.disabled) then
			Line:Disable()
			Line:SetMotionScriptsWhileDisabled(data.forceMotion)
		else
			Line:Enable()
		end

		if(data.menu) then
			Line.Expand:Show()
		else
			if(data.isColorPicker) then
				local r, g, b, a = data.colorR, data.colorG, data.colorB, data.colorOpacity
				local callback = data.colorPickerCallback
				assert(r and type(r) == 'number', 'Missing required data "colorR"')
				assert(g and type(g) == 'number', 'Missing required data "colorG"')
				assert(b and type(b) == 'number', 'Missing required data "colorB"')
				assert(callback and type(callback) == 'function', 'Missing required data "colorPickerCallback"')

				if(not Line.colors) then
					Line.colors = CreateColor(r, g, b, a)
				else
					Line.colors:SetRGBA(r, g, b, a)
				end

				Line.colorPickerCallback = callback
				Line.ColorSwatch.Swatch:SetVertexColor(r, g, b, a or 1)
				Line.ColorSwatch:Show()
			else
				if(data.checked ~= nil) then
					Line.Radio:Show()

					if(type(data.checked) == 'function') then
						Line.checked = data.checked
						Line.isRadio = data.isRadio
					else
						if(data.isRadio) then
							Line:SetRadioState(data.checked)
						else
							Line:SetCheckedState(data.checked)
						end
					end
				end
			end
		end

		-- TODO: slider
		-- TODO: editbox
		-- TODO: scrolling
	end

	Line:Show()
	return Line
end

--[[### LibDropDownMenuTemplate:AddLines(_..._)

See [LibDropDownMenuTemplate:AddLine(_data_)], this one does the exact same thing, except  
this one can add more than one line at a time.

- `...`: One or more tables containing line information.
--]]
function LibDropDownMenuMixin:AddLines(...)
	for index = 1, select('#', ...) do
		self:AddLine(select(index, ...))
	end
end

--[[### LibDropDownMenuTemplate:AddLine(_data_)

Adds a line using the given data to the menu menu.  
Everything™ is optional, some are exclusive with others.

- `data`:
	- `text`: Text to show on the line _(string)_
	- `isTitle`: Turns the `text` into a title _(boolean)_
	- `isSpacer`: Turns the line into a spacer _(boolean)_
	- `func`: Function to execute when clicking the line _(function)_  
	  Arguments passed: `button`, `args` (unpacked).
	- `keepShown`: Keeps the dropdown shown after clicking the line _(boolean)_
	- `args`: Table of arguments to pass through to the click function _(table)_
	- `tooltip`: Tooltip contents _(string)_
	- `tooltipTitle`: Tooltip title _(string)_
	- `tooltipWhileDisabled`: Enable tooltips while disabled _(boolean)_
	- `checked`: Show or hide a checkbox _(boolean/function)_
	- `isRadio`: Turns the checkbox into a radio button _(boolean)_
	- `isColorPicker`: Adds a color picker to the line _(boolean)_
	- `colorR`: Red color channel, 0-1 _(number)_
	- `colorG`: Green color channel, 0-1 _(number)_
	- `colorB`: Blue color channel, 0-1 _(number)_
	- `colorOpacity`: Alpha channel, 0-1 _(number)_
	- `colorPickerCallback`: Callback function for the color picker _(function)_  
	  Arguments passed: `color`, see [SharedXML\Util.lua's ColorMixin](https://www.townlong-yak.com/framexml/live/go/ColorMixin).
	- `icon`: Texture path for the icon to embed into the start of `text` _(string)_
	- `iconTexCoords`: Texture coordinates for cropping the `icon` _(array)_
	- `iconWidth`: Width of the displayed `icon` _(number)_
	- `iconHeight`: Height of the displayed `icon` _(number)_
	- `iconFileWidth`: File width of the `icon` _(number)_
	- `iconFileHeight`: File height of the `icon` _(number)_
	- `atlas`: Atlas to embed into the start of `text` _(string)_
	- `atlasWidth`: Width of the displayed `atlas` _(number)_
	- `atlasHeight`: Height of the displayed `atlas` _(number)_
	- `atlasOffsetX`: Horizontal offset for `atlas` _(number)_
	- `atlasOffsetY`: Vertical offset for `atlas` _(number)_
	- `atlasOffset`: Common offset for both axis for `atlas` _(number)_
	- `disabled`: Disables the whole line _(boolean)_
	- `texture`: Sets background texture that spans the line _(string)_
	- `textureColor`: Sets the color of the background texture _([ColorMixin object](https://www.townlong-yak.com/framexml/live/go/ColorMixin))_
	- `font`: Font to use for the line _(string)_
	- `fontSize`: Font size to use for the line, requires `font` to be set _(number)_
	- `fontFlags`: Font flags to use for the line, requires `font` to be set _(string)_
	- `fontObject`: Font object to use for the line _(string/[FontInstance](http://wowprogramming.com/docs/widgets/FontInstance))_
	- `menu`: Sub-menu for the current menu line _(array)_  
	  This needs to contain one or more tables of `data` (all of the above) in an  
	  indexed array. Can be chained.
#### Notes
The following are exclusive options, only one can be used at a time:
- isSpacer
- isTitle
- menu
- isColorPicker
- checked
- font
- fontObject
--]]
function LibDropDownMenuMixin:AddLine(data)
	if(not self.data) then
		self.data = {}
	end

	table.insert(self.data, data)
	local Line = self:UpdateLine(#self.data, data)

	if(data.menu) then
		local Menu = lib:NewMenu(Line)
		Menu:AddLines(unpack(data.menu))

		if(#data.menu == 0) then
			error('Sub-menu created but no entries found.')
		end

		table.insert(self.menus, Menu)
		Line.Menu = Menu
	else
		Line.Menu = nil
	end
end

--[[### LibDropDownMenuTemplate:RemoveLine(_index_)

Removes a specific line by index.

- `index`: Number between 1 and [LibDropDownMenuTemplate:NumLines()]()
--]]
function LibDropDownMenuMixin:RemoveLine(index)
	assert(index >= 1 and index <= self:NumLines(), 'index out of scope')
	table.remove(self.data, index)
	self.lines[index]:Hide()
end

--[[### LibDropDownMenuTemplate:ClearLines()

Removes all lines in the menu.
--]]
function LibDropDownMenuMixin:ClearLines()
	if(self.data) then
		table.wipe(self.data)

		for index, Line in next, self.lines do
			Line:Hide()
		end
	end
end

--[[### LibDropDownMenuTemplate:NumLines()

#### Returns
- `numLines`: Number of lines in the menu
--]]
function LibDropDownMenuMixin:NumLines()
	return #self.lines
end

--[[### LibDropDownMenuTemplate:SetStyle(_name_)

Sets the active style for all menus related to this one.

- `name`: Name of registered style (see [LDD:RegisterStyle]())
--]]
function LibDropDownMenuMixin:SetStyle(name)
	if(not name) then
		name = self.parent.style or 'DEFAULT'
	elseif(not styles[name]) then
		error('Style "' .. name .. '" does not exist.')
	end

	self.parent.style = name

	local data = styles[name]
	self.parent.spacing = data.spacing or 0
	self.parent.padding = data.padding or 10
	self.parent.gap = data.gap or 10
	self.parent.normalFont = data.normalFont or 'GameFontHighlightSmallLeft'
	self.parent.highlightFont = data.highlightFont or self.parent.normalFont
	self.parent.disabledFont = data.disabledFont or 'GameFontDisableSmallLeft'
	self.parent.titleFont = data.titleFont or 'GameFontNormal'
	self.parent.radioTexture = data.radioTexture or [[Interface\Common\UI-DropDownRadioChecks]]
	self.parent.highlightTexture = data.highlightTexture or [[Interface\QuestFrame\UI-QuestTitleHighlight]]
	self.parent.expandTexture = data.expandTexture or [[Interface\ChatFrame\ChatFrameExpandArrow]]

	self.Backdrop:SetBackdrop(data.backdrop)
	self.Backdrop:SetBackdropColor((data.backdropColor or HIGHLIGHT_FONT_COLOR):GetRGBA())
	self.Backdrop:SetBackdropBorderColor((data.backdropBorderColor or HIGHLIGHT_FONT_COLOR):GetRGBA())
end

--[[### LibDropDownMenuTemplate:GetStyle()

Gets the active style for this menu, and all menus related to this one.

#### Returns
- `name`: Name of registered style (see [LDD:RegisterStyle]())
--]]
function LibDropDownMenuMixin:GetStyle()
	return self.parent.style
end

--[[### LibDropDownMenuTemplate:SetAnchor(_point, anchor, relativePoint, x, y_)

Replaces the default anchor with a custom one.
Exact same parameters as in [Widgets:SetPoint](http://wowprogramming.com/docs/widgets/Region/SetPoint), read that documentation instead.
--]]
function LibDropDownMenuMixin:SetAnchor(point, anchor, relativePoint, x, y)
	self.parent.anchor[1] = point
	self.parent.anchor[2] = anchor
	self.parent.anchor[3] = relativePoint
	self.parent.anchor[4] = x
	self.parent.anchor[5] = y
end

--[[### LibDropDownMenuTemplate:GetAnchor()

Gets the registered anchor.

#### Returns
- `point`: Point on the menu the menu is anchored to the anchor.
- `anchor`: The region the menu is anchored to.
- `relativePoint`: Point on the anchor the menu is anchored to.
- `x`: Horizontal offset, positive means shifted to the right.
- `y`: Vertical offset, positive means shifted upwards.
--]]
function LibDropDownMenuMixin:GetAnchor()
	return unpack(self.parent.anchor)
end

--[[### LibDropDownMenuTemplate:SetAnchorCursor(_state_)

Allows the anchor to be overridden and places the menu on the cursor.

- `state`: Enables/disables cursor anchoring _(boolean)_
--]]
function LibDropDownMenuMixin:SetAnchorCursor(state)
	self.parent.anchorCursor = state
end

--[[### LibDropDownMenuTemplate:IsAnchorCursor()

States if the menu should be anchored to the cursor or not.

#### Returns
- `state`: `true`/`false` if the menu should be anchored to the cursor.
--]]
function LibDropDownMenuMixin:IsAnchorCursor()
	return self.parent.anchorCursor
end

--[[### LibDropDownMenuTemplate:SetTimeout(_timeout_)

Sets the amount of time before the menu automatically hides.

- `timeout`: Sets the timeout in seconds before hiding the menu(s) _(number)_
--]]
function LibDropDownMenuMixin:SetTimeout(timeout)
	self.parent.timeout = timeout

	local timer = self.parent.timer
	timer:GetAnimations()[1]:SetDuration(timeout)

	if(timer:IsPlaying()) then
		-- restart the current timer
		timer:Stop()
		timer:Play()
	end
end

--[[### LibDropDownMenuTemplate:GetTimeout()

Gets the amount of time before the menu automatically hides.

#### Returns
- `timeout`: The timeout in seconds before the menu hides
--]]
function LibDropDownMenuMixin:GetTimeout()
	return self.parent.timeout
end


-- our templated menu lines
LibDropDownLineMixin = {}
function LibDropDownLineMixin:OnLoad()
	self:SetFrameLevel(self:GetParent():GetFrameLevel() + 2)
	self.parent = self:GetParent().parent
end

function LibDropDownLineMixin:OnShow()
	if(self.checked) then
		if(self.isRadio) then
			self:SetRadioState(self:checked())
		else
			self:SetCheckedState(self:checked())
		end
	end
end

function LibDropDownLineMixin:OnEnter()
	-- hide all submenues for the current menu
	for _, Menu in next, self:GetParent().menus do
		Menu:Hide()
	end

	if(self.Expand:IsShown()) then
		-- show this line's submenu
		self.Menu:Show()
	end

	self.Highlight:Show()

	if(self.tooltip) then
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')

		if(self.tooltipTitle) then
			GameTooltip:AddLine(self.tooltipTitle, 1, 1, 1)
		end

		GameTooltip:AddLine(self.tooltip, nil, nil, nil, true)
		GameTooltip:Show()
	end

	-- cancel auto-hide timer
	self:GetParent().parent.timer:Stop()
end

function LibDropDownLineMixin:OnLeave()
	self.Highlight:Hide()

	if(self.tooltip) then
		GameTooltip:Hide()
	end

	-- start auto-hide timer
	self:GetParent().parent.timer:Play()
end

function LibDropDownLineMixin:OnClick(button)
	if(self.ColorSwatch:IsShown()) then
		ColorPickerFrame.func = function()
			local r, g, b = ColorPickerFrame:GetColorRGB()
			local a = ColorPickerFrame.hasOpacity and (1 - OpacitySliderFrame:GetValue()) or 1
			self.colorPickerCallback(CreateColor(r, g, b , a))
		end

		ColorPickerFrame.opacityFunc = ColorPickerFrame.func
		ColorPickerFrame.cancelFunc = function()
			self.colorPickerCallback(self.colors)
		end

		local r, g, b, a = self.colors:GetRGBA()
		ColorPickerFrame.hasOpacity = not not a
		ColorPickerFrame.opacity = a
		-- BUG: ColorSelect not reacting to SetColorRGB in build 24015
		ColorPickerFrame:SetColorRGB(r, g, b)

		ShowUIPanel(ColorPickerFrame)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	else
		pcall(self.func, self, button, unpack(self.args or {}))
	end

	if(not self.keepShown) then
		lib:CloseAll()
	end
end

--[[### LibDropDownLineTemplate:SetRadioState(_state_)

Sets the state of a radio button.

- `state`: Enables/disables a radio button _(boolean)_
--]]
function LibDropDownLineMixin:SetRadioState(state)
	self.Radio.state = state

	if(state) then
		self.Radio:SetTexCoord(0, 0.5, 0.5, 1)
	else
		self.Radio:SetTexCoord(0.5, 1, 0.5, 1)
	end
end

--[[### LibDropDownLineTemplate:GetRadioState()

Gets the state of a radio button.

#### Returns
- `state`: `true`/`false` state of the radio button _(boolean)_
--]]
function LibDropDownLineMixin:GetRadioState()
	return self.Radio.state
end

--[[### LibDropDownLineTemplate:SetCheckedState(_state_)

Sets the state of a checkbutton.

- `state`: Enables/disables a checkbutton _(boolean)_
--]]
function LibDropDownLineMixin:SetCheckedState(state)
	self.Radio.state = state

	if(state) then
		self.Radio:SetTexCoord(0, 0.5, 0, 0.5)
	else
		self.Radio:SetTexCoord(0.5, 1, 0, 0.5)
	end
end

--[[### LibDropDownLineTemplate:GetCheckedState()

Gets the state of a checkbutton.

#### Returns
- `state`: `true`/`false` state of the checkbutton _(boolean)_
--]]
function LibDropDownLineMixin:GetCheckedState()
	return self.Radio.state
end

--[[### LibDropDownLineTemplate:SetIcon(_..._)

See [FrameXML/Util.lua's CreateTextureMarkup](https://www.townlong-yak.com/framexml/live/go/CreateTextureMarkup)
--]]
function LibDropDownLineMixin:SetIcon(...)
	local markup = CreateTextureMarkup(...)
	self.__icon = markup
	self:UpdateText()
end

--[[### LibDropDownLineTemplate:GetIcon()

See [FrameXML/Util.lua's CreateTextureMarkup](https://www.townlong-yak.com/framexml/live/go/CreateTextureMarkup)
--]]
function LibDropDownLineMixin:GetIcon()
	return self.__icon
end

--[[### LibDropDownLineTemplate:SetAtlas(_..._)

See [FrameXML/Util.lua's CreateAtlasMarkup](https://www.townlong-yak.com/framexml/live/go/CreateAtlasMarkup)
--]]
function LibDropDownLineMixin:SetAtlas(...)
	local markup = CreateAtlasMarkup(...)
	self.__atlas = markup
	self:UpdateText()
end

--[[### LibDropDownLineTemplate:GetAtlas()

See [FrameXML/Util.lua's CreateAtlasMarkup](https://www.townlong-yak.com/framexml/live/go/CreateAtlasMarkup)
--]]
function LibDropDownLineMixin:GetAtlas()
	return self.__atlas
end

function LibDropDownLineMixin:SetText(text)
	self:SetFormattedText('%s%s', self.__icon or self.__atlas or '', text)
end

function LibDropDownLineMixin:UpdateText()
	local text = self:GetText():gsub('|T.*|t'):gsub('|A.*|a')
	self:SetText(text)
end

function LibDropDownLineMixin:SetTexture(texture, color)
	self.Texture:SetTexture(texture)
	if(color) then
		self.Texture:SetVertexColor(color:GetRGBA())
	else
		self.Texture:SetVertexColor(1, 1, 1, 1)
	end

	self.Texture:Show()
end
