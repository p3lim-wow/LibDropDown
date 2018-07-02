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

local function OnShow(self)
	if(not self.Menu) then
		self.Menu = lib:NewMenu(self)
	end
end

local function OnHide()
	lib:CloseAll()
end

local buttonMixin = {}
--[[
--]]
function buttonMixin:Add(...)
	self.Menu:AddLines(...)
end

--[[
--]]
function buttonMixin:Remove(...)
	self.Menu:RemoveLine(...)
end

--[[
--]]
function buttonMixin:Clear()
	self.Menu:ClearLines()
end

--[[
--]]
function buttonMixin:Toggle()
	self.Menu:Toggle()
end

--[[
--]]
function buttonMixin:SetAnchor(...)
	self.Menu:SetAnchor(...)
end

--[[
--]]
function buttonMixin:GetAnchor()
	return self.Menu:GetAnchor()
end

--[[
--]]
function buttonMixin:SetAnchorCursor(...)
	self.Menu:SetAnchorCursor(...)
end

--[[
--]]
function buttonMixin:IsAnchorCursor()
	return self.Menu:IsAnchorCursor()
end

--[[
--]]
function buttonMixin:SetStyle(...)
	self.Menu:SetStyle(...)
end

--[[
--]]
function buttonMixin:GetStyle()
	return self.Menu:GetStyle()
end

--[[
--]]
function buttonMixin:SetTimeout(...)
	self.Menu:SetTimeout(...)
end

--[[
--]]
function buttonMixin:GetTimeout()
	return self.Menu:GetTimeout()
end

--[[
--]]
function buttonMixin:SetJustifyH(...)
	self.Text:SetJustifyH(...)
end

--[[
--]]
function buttonMixin:GetJustifyH()
	return self.Text:GetJustifyH()
end

--[[
--]]
function buttonMixin:SetText(...)
	self.Text:SetText(...)
end

--[[
--]]
function buttonMixin:GetText()
	return self.Text:GetText()
end

--[[
--]]
function buttonMixin:SetFormattedText(...)
	self.Text:SetFormattedText(...)
end

function lib:NewButton(parent, name)
	assert(parent, 'A button requres a given parent')

	if(type(parent) == 'string') then
		parent = _G[parent]
	end

	local Button = Mixin(CreateFrame('Frame', (name or parent:GetDebugName() .. 'MenuButton'), parent), buttonMixin, CallbackRegistryBaseMixin)
	Button:SetSize(165, 32)
	Button:SetScript('OnShow', OnShow)
	Button:SetScript('OnHide', OnHide)

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

	local Text = Button:CreateFontString('$parentText', 'ARTWORK', nil, 'GameFontHighlightSmall')
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
