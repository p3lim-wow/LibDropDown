--[[ Button:header
Documentation for the [Button](Button) object.
Created with [LibDropDown:NewButton()](LibDropDown#libdropdownnewbuttonparent-name).

For all intents and purposes, this is the equivalent to [UIDropDownMenuButtonTemplate](https://www.townlong-yak.com/framexml/live/go/UIDropDownMenuButtonTemplate).
--]]
local lib = LibStub('LibDropDown')

local function OnEnter(self)
	local script = self:GetParent():GetScript('OnEnter')
	if(script) then
		script(self:GetParent())
	end
end

local function OnLeave(self)
	local script = self:GetParent():GetScript('OnLeave')
	if(script) then
		script(self:GetParent())
	end
end

local function OnClick(self)
	self:GetParent():Toggle()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

local function OnHide()
	lib:CloseAll()
end

local buttonMixin = {}
--[[ Button:Add(_..._)
See [Menu:AddLines()](Menu#menuaddlines).
--]]
function buttonMixin:Add(...)
	self.Menu:AddLines(...)
end

--[[ Button:Remove(_..._)
See [Menu:RemoveLine()](Menu#menuremoveline).
--]]
function buttonMixin:Remove(...)
	self.Menu:RemoveLine(...)
end

--[[ Button:Clear()
See [Menu:ClearLines()](Menu#menuclearlines)
--]]
function buttonMixin:Clear()
	self.Menu:ClearLines()
end

--[[ Button:Toggle()
See [Menu:Toggle()](Menu#menutoggle).
--]]
function buttonMixin:Toggle()
	self.Menu:Toggle()
end

--[[ Button:SetAnchor(_..._)
See [Menu:SetAnchor(_point, anchor, relativePoint, x, y_)](Menu#menusetanchorpointanchorrelativepointxy).
--]]
function buttonMixin:SetAnchor(...)
	self.Menu:SetAnchor(...)
end

--[[ Button:GetAnchor()
See [Menu:GetAnchor()](Menu#menugetanchor).
--]]
function buttonMixin:GetAnchor()
	return self.Menu:GetAnchor()
end

--[[ Button:SetAnchorCursor(_flag_)
See [Menu:SetAnchorCursor(_flag_)](Menu#menusetanchorcursorflag).
--]]
function buttonMixin:SetAnchorCursor(...)
	self.Menu:SetAnchorCursor(...)
end

--[[ Button:IsAnchorCursor()
See [Menu:IsAnchorCursor()](Menu#menuisanchorcursor).
--]]
function buttonMixin:IsAnchorCursor()
	return self.Menu:IsAnchorCursor()
end

--[[ Button:SetStyle(...)
See [Menu:SetStyle(_name_)](Menu#menusetstylename).
--]]
function buttonMixin:SetStyle(...)
	self.Menu:SetStyle(...)
end

--[[ Button:GetStyle()
See [Menu:GetStyle()](Menu#menugetstyle).
--]]
function buttonMixin:GetStyle()
	return self.Menu:GetStyle()
end

--[[ Button:SetTimeout(_timeout_)
See [Menu:SetTimeout(_timeout_)](Menu#menusettimeouttimeout).
--]]
function buttonMixin:SetTimeout(...)
	self.Menu:SetTimeout(...)
end

--[[ Button:GetTimeout()
See [Menu:GetTimeout()](Menu#menugettimeout).
--]]
function buttonMixin:GetTimeout()
	return self.Menu:GetTimeout()
end

--[[ Button:SetJustifyH(_..._)
See [Widget:SetJustifyH](http://wowprogramming.com/docs/widgets/FontInstance/SetJustifyH).
--]]
function buttonMixin:SetJustifyH(...)
	self.Text:SetJustifyH(...)
end

--[[ Button:GetJustifyH()
See [Widget:GetJustifyH](http://wowprogramming.com/docs/widgets/FontInstance/GetJustifyH).
--]]
function buttonMixin:GetJustifyH()
	return self.Text:GetJustifyH()
end

--[[ Button:SetText(_..._)
See [Widget:SetText](http://wowprogramming.com/docs/widgets/Button/SetText).
--]]
function buttonMixin:SetText(...)
	self.Text:SetText(...)
end

--[[ Button:GetText()
See [Widget:GetText](http://wowprogramming.com/docs/widgets/Button/GetText).
--]]
function buttonMixin:GetText()
	return self.Text:GetText()
end

--[[ Button:SetFormattedText(_..._)
See [Widget:SetFormattedText](http://wowprogramming.com/docs/widgets/Button/SetFormattedText).
--]]
function buttonMixin:SetFormattedText(...)
	self.Text:SetFormattedText(...)
end

--[[ LibDropDown:NewButton(_parent[, name]_)
Creates and returns a new menu button object.

* `parent`: parent for the new button _(string|object)_
* `name`: name for the new button _(string, default = derived from parent)_
--]]
function lib:NewButton(parent, name)
	assert(parent, 'A button requres a given parent')

	if(type(parent) == 'string') then
		parent = _G[parent]
	end

	local Button = Mixin(CreateFrame('Frame', (name or parent:GetDebugName() .. 'MenuButton'), parent), buttonMixin, CallbackRegistryBaseMixin or CallbackRegistryMixin)
	Button:SetSize(165, 32)
	Button:SetScript('OnHide', OnHide)
	Button.Menu = lib:NewMenu(Button)

	local Left = Button:CreateTexture('$parentLeft', 'ARTWORK')
	Left:SetPoint('TOPLEFT', 0, 17)
	Left:SetSize(25, 64)
	Left:SetTexture('Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame')
	Left:SetTexCoord(0, 0.1953125, 0, 1)
	Button.Left = Left

	local Right = Button:CreateTexture('$parentRight', 'ARTWORK')
	Right:SetPoint('TOPRIGHT', 0, 17)
	Right:SetSize(25, 64)
	Right:SetTexture('Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame')
	Right:SetTexCoord(0.8046875, 1, 0, 1)
	Button.Right = Right

	local Middle = Button:CreateTexture('$parentMiddle', 'ARTWORK')
	Middle:SetPoint('LEFT', Left, 'RIGHT')
	Middle:SetPoint('RIGHT', Right, 'LEFT')
	Middle:SetSize(115, 64)
	Middle:SetTexture('Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame')
	Middle:SetTexCoord(0.1953125, 0.8046875, 0, 1)
	Button.Middle = Middle

	local Text = Button:CreateFontString('$parentText', 'ARTWORK', 'GameFontHighlightSmall')
	Text:SetPoint('RIGHT', Right, -43, 2)
	Text:SetPoint('LEFT', Left, 27, 2)
	Text:SetSize(0, 10)
	Text:SetWordWrap(false)
	Text:SetJustifyH('RIGHT')
	Button.Text = Text

	local Icon = Button:CreateTexture('$parentIcon', 'OVERLAY')
	Icon:SetPoint('LEFT', 30, 2)
	Icon:SetSize(16, 16)
	Icon:Hide()
	Button.Icon = Icon

	local OpenButton = CreateFrame('Button', '$parentButton', Button)
	OpenButton:SetPoint('TOPRIGHT', Right, -16, -18)
	OpenButton:SetSize(24, 24)
	OpenButton:SetScript('OnEnter', OnEnter)
	OpenButton:SetScript('OnLeave', OnLeave)
	OpenButton:SetScript('OnClick', OnClick)
	OpenButton:SetMotionScriptsWhileDisabled(true)
	OpenButton:SetNormalTexture('Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up')
	OpenButton:GetNormalTexture():SetPoint('RIGHT')
	OpenButton:GetNormalTexture():SetSize(24, 24)
	OpenButton:SetPushedTexture('Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down')
	OpenButton:GetPushedTexture():SetPoint('RIGHT')
	OpenButton:GetPushedTexture():SetSize(24, 24)
	OpenButton:SetDisabledTexture('Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled')
	OpenButton:GetDisabledTexture():SetPoint('RIGHT')
	OpenButton:GetDisabledTexture():SetSize(24, 24)
	OpenButton:SetHighlightTexture('Interface\\Buttons\\UI-Common-MouseHilight')
	OpenButton:GetHighlightTexture():SetPoint('RIGHT')
	OpenButton:GetHighlightTexture():SetSize(24, 24)
	OpenButton:GetHighlightTexture():SetBlendMode('ADD')
	Button.Button = OpenButton

	return Button
end

--[[ ButtonStretch:header
Documentation for the [ButtonStretch](ButtonStretch) object.
Created with [LibDropDown:NewButtonStretch()](LibDropDown#libdropdownnewbuttonstretchparent-name).
--]]

local buttonStretchMixin = CreateFromMixins(buttonMixin)
buttonStretchMixin.SetJustifyH = nil
buttonStretchMixin.GetJustifyH = nil

function buttonStretchMixin:OnHide()
	lib:CloseAll()
	self:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
end

function buttonStretchMixin:OnEnable()
	self.Arrow:SetDesaturated(false)
	self:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
end

function buttonStretchMixin:OnDisable()
	self.Arrow:SetDesaturated(true)
	self:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
end

function buttonStretchMixin:OnMouseDown()
	if self:IsEnabled() then
		self:Toggle()
		self:SetTexture('Interface\\Buttons\\UI-Silver-Button-Down')
		self.Arrow:SetPoint('RIGHT', -4, -1)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end
end

function buttonStretchMixin:OnMouseUp()
	if self:IsEnabled() then
		self:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
		self.Arrow:SetPoint('RIGHT', -5, 0)
	end
end

--[[ ButtonStretch:Add(_..._)
See [Menu:AddLines()](Menu#menuaddlines).
--]]

--[[ ButtonStretch:Remove(_..._)
See [Menu:RemoveLine()](Menu#menuremoveline).
--]]

--[[ ButtonStretch:Clear()
See [Menu:ClearLines()](Menu#menuclearlines)
--]]

--[[ ButtonStretch:Clear()
See [Menu:ClearLines()](Menu#menuclearlines)
--]]

--[[ ButtonStretch:Toggle()
See [Menu:Toggle()](Menu#menutoggle).
--]]

--[[ ButtonStretch:SetAnchor(_..._)
See [Menu:SetAnchor(_point, anchor, relativePoint, x, y_)](Menu#menusetanchorpointanchorrelativepointxy).
--]]

--[[ ButtonStretch:GetAnchor()
See [Menu:GetAnchor()](Menu#menugetanchor).
--]]

--[[ ButtonStretch:SetAnchorCursor(_flag_)
See [Menu:SetAnchorCursor(_flag_)](Menu#menusetanchorcursorflag).
--]]

--[[ ButtonStretch:IsAnchorCursor()
See [Menu:IsAnchorCursor()](Menu#menuisanchorcursor).
--]]

--[[ ButtonStretch:SetStyle(...)
See [Menu:SetStyle(_name_)](Menu#menusetstylename).
--]]

--[[ ButtonStretch:GetStyle()
See [Menu:GetStyle()](Menu#menugetstyle).
--]]

--[[ ButtonStretch:SetTimeout(_timeout_)
See [Menu:SetTimeout(_timeout_)](Menu#menusettimeouttimeout).
--]]

--[[ ButtonStretch:GetTimeout()
See [Menu:GetTimeout()](Menu#menugettimeout).
--]]

--[[ ButtonStretch:SetText(_..._)
See [Widget:SetText](http://wowprogramming.com/docs/widgets/Button/SetText).
--]]

--[[ ButtonStretch:GetText()
See [Widget:GetText](http://wowprogramming.com/docs/widgets/Button/GetText).
--]]

--[[ ButtonStretch:SetFormattedText(_..._)
See [Widget:SetFormattedText](http://wowprogramming.com/docs/widgets/Button/SetFormattedText).
--]]

--[[ ButtonStretch:SetTexture(_texture_)
Sets the texture of the ButtonStretch.

* `texture` : texture to set _(string)_
--]]
function buttonStretchMixin:SetTexture(texture)
	self.TopLeft:SetTexture(texture)
	self.TopRight:SetTexture(texture)
	self.BottomLeft:SetTexture(texture)
	self.BottomRight:SetTexture(texture)
	self.TopMiddle:SetTexture(texture)
	self.MiddleLeft:SetTexture(texture)
	self.MiddleRight:SetTexture(texture)
	self.BottomMiddle:SetTexture(texture)
	self.MiddleMiddle:SetTexture(texture)
end

--[[ ButtonStretch:SetArrowShown(_state_)
Sets the visibility of the Arrow sub-widget.

* `state` : shows/hides the Arrow sub-widget _(boolean)_
--]]
function buttonStretchMixin:SetArrowShown(state)
	self.Arrow:SetShown(state)
end

--[[ LibDropDown:NewButtonStretch(_parent[, name]_)
Creates and returns a new menu button object.

* `parent`: parent for the new button _(string|object)_
* `name`: name for the new button _(string, default = derived from parent)_
--]]
function lib:NewButtonStretch(parent, name)
	assert(parent, 'A button requres a given parent')

	if(type(parent) == 'string') then
		parent = _G[parent]
	end

	local Button = Mixin(CreateFrame('Button', (name or parent:GetDebugName() .. 'MenuButtonStretch'), parent), buttonStretchMixin, CallbackRegistryBaseMixin or CallbackRegistryMixin)
	Button:SetSize(40, 26)
	Button:SetScript('OnDisable', Button.OnDisable)
	Button:SetScript('OnEnable', Button.OnEnable)
	Button:SetScript('OnHide', Button.OnHide)
	Button:SetScript('OnMouseDown', Button.OnMouseDown)
	Button:SetScript('OnMouseUp', Button.OnMouseUp)
	Button:SetHighlightTexture('Interface\\Buttons\\UI-Silver-Button-Highlight', 'ADD')
	Button:GetHighlightTexture():SetTexCoord(0, 1.0, 0.03, 0.7175)

	local Menu = lib:NewMenu(Button)
	Menu:SetAnchor('TOPLEFT', Button, 'TOPRIGHT', 20, -10)
	Menu:SetStyle('MENU')
	Button.Menu = Menu

	local TopLeft = Button:CreateTexture('$parentTopLeft', 'BACKGROUND')
	TopLeft:SetPoint('TOPLEFT', 0, 0)
	TopLeft:SetSize(12, 6)
	TopLeft:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
	TopLeft:SetTexCoord(0, 0.09375, 0, 0.1875)
	Button.TopLeft = TopLeft

	local TopRight = Button:CreateTexture('$parentTopRight', 'BACKGROUND')
	TopRight:SetPoint('TOPRIGHT', 0, 0)
	TopRight:SetSize(12, 6)
	TopRight:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
	TopRight:SetTexCoord(0.53125, 0.625, 0, 0.1875)
	Button.TopRight = TopRight

	local BottomLeft = Button:CreateTexture('$parentBottomLeft', 'BACKGROUND')
	BottomLeft:SetPoint('BOTTOMLEFT', 0, 0)
	BottomLeft:SetSize(12, 6)
	BottomLeft:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
	BottomLeft:SetTexCoord(0, 0.09375, 0.625, 0.8125)
	Button.BottomLeft = BottomLeft

	local BottomRight = Button:CreateTexture('$parentBottomRight', 'BACKGROUND')
	BottomRight:SetPoint('BOTTOMRIGHT', 0, 0)
	BottomRight:SetSize(12, 6)
	BottomRight:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
	BottomRight:SetTexCoord(0.53125, 0.625, 0.625, 0.8125)
	Button.BottomRight = BottomRight

	local TopMiddle = Button:CreateTexture('$parentTopMiddle', 'BACKGROUND')
	TopMiddle:SetPoint('TOPLEFT', TopLeft, 'TOPRIGHT', 0, 0)
	TopMiddle:SetPoint('BOTTOMRIGHT', TopRight, 'BOTTOMLEFT', 0, 0)
	TopMiddle:SetSize(56, 6)
	TopMiddle:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
	TopMiddle:SetTexCoord(0.09375, 0.53125, 0, 0.1875)
	Button.TopMiddle = TopMiddle

	local MiddleLeft = Button:CreateTexture('$parentMiddleLeft', 'BACKGROUND')
	MiddleLeft:SetPoint('TOPRIGHT', TopLeft, 'BOTTOMRIGHT', 0, 0)
	MiddleLeft:SetPoint('BOTTOMLEFT', BottomLeft, 'TOPLEFT', 0, 0)
	MiddleLeft:SetSize(12, 14)
	MiddleLeft:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
	MiddleLeft:SetTexCoord(0, 0.09375, 0.1875, 0.625)
	Button.MiddleLeft = MiddleLeft

	local MiddleRight = Button:CreateTexture('$parentMiddleRight', 'BACKGROUND')
	MiddleRight:SetPoint('TOPRIGHT', TopRight, 'BOTTOMRIGHT', 0, 0)
	MiddleRight:SetPoint('BOTTOMLEFT', BottomRight, 'TOPLEFT', 0, 0)
	MiddleRight:SetSize(12, 14)
	MiddleRight:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
	MiddleRight:SetTexCoord(0.53125, 0.625, 0.1875, 0.625)
	Button.MiddleRight = MiddleRight

	local BottomMiddle = Button:CreateTexture('$parentBottomMiddle', 'BACKGROUND')
	BottomMiddle:SetPoint('TOPLEFT', BottomLeft, 'TOPRIGHT', 0, 0)
	BottomMiddle:SetPoint('BOTTOMRIGHT', BottomRight, 'BOTTOMLEFT', 0, 0)
	BottomMiddle:SetSize(56, 6)
	BottomMiddle:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
	BottomMiddle:SetTexCoord(0.09375, 0.53125, 0.625, 0.8125)
	Button.BottomMiddle = BottomMiddle

	local MiddleMiddle = Button:CreateTexture('$parentMiddleMiddle', 'BACKGROUND')
	MiddleMiddle:SetPoint('TOPLEFT', TopLeft, 'BOTTOMRIGHT', 0, 0)
	MiddleMiddle:SetPoint('BOTTOMRIGHT', BottomRight, 'TOPLEFT', 0, 0)
	MiddleMiddle:SetSize(56, 14)
	MiddleMiddle:SetTexture('Interface\\Buttons\\UI-Silver-Button-Up')
	MiddleMiddle:SetTexCoord(0.09375, 0.53125, 0.1875, 0.625)
	Button.MiddleMiddle = MiddleMiddle

	local Text = Button:CreateFontString('$parentText', 'ARTWORK')
	Text:SetPoint('CENTER', 0, -0)
	Button.Text = Text

	Button:SetFontString(Text)
	Button:SetNormalFontObject(GameFontHighlightSmall)
	Button:SetHighlightFontObject(GameFontHighlightSmall)
	Button:SetDisabledFontObject(GameFontDisableSmall)

	local Arrow = Button:CreateTexture('$parentArrow', 'ARTWORK')
	Arrow:SetPoint('RIGHT', -5, 0)
	Arrow:SetSize(10, 12)
	Arrow:SetTexture('Interface\\ChatFrame\\ChatFrameExpandArrow')
	Button.Arrow = Arrow

	return Button
end
