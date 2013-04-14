MODULE.name="GUI"
local GUIBUTTON
local GUICHECKBOX
function CreateCommandButton(a, b)
    GUIBUTTON = vgui.Create("DButton")
    GUIBUTTON:SetSize(100, 20)
    GUIBUTTON:SetText(a)
    GUIBUTTON.DoClick = function()
        RunConsoleCommand(b)
    end 
    CategoryList:AddItem(GUIBUTTON)
end     
function CreateCommandCheckbox(cvarData)
	GUICHECKBOX = vgui.Create("DCheckBoxLabel")
	GUICHECKBOX:SetText(cvarData.name)
	GUICHECKBOX:SetConVar(cvarData.cvar)
	GUICHECKBOX:SetValue(GetConVarNumber(cvarData.cvar))
	GUICHECKBOX:SizeToContents()
	CategoryList:AddItem(GUICHECKBOX)
end     
function createGUI()
	DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos( 50,50 )
	DermaPanel:SetSize( 500, 500 )
	DermaPanel:SetTitle( "Continuum GUI" )
	DermaPanel:SetVisible( true )
	DermaPanel:SetDraggable( true )
	DermaPanel:ShowCloseButton( true )
	DermaPanel:MakePopup()
	 
	local SomeCollapsibleCategory = vgui.Create("DCollapsibleCategory", DermaPanel)
	SomeCollapsibleCategory:SetPos( 5,30 )
	SomeCollapsibleCategory:SetSize( 400, 300 ) -- Keep the second number at 50
	SomeCollapsibleCategory:SetExpanded( 0 ) -- Expanded when popped up
	SomeCollapsibleCategory:SetLabel( "ConVars" )
	 
	CategoryList = vgui.Create( "DPanelList" )
	CategoryList:SetAutoSize( true )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPos(20, 0)
	CategoryList:EnableHorizontal( false )
	CategoryList:EnableVerticalScrollbar( true )
	 
	SomeCollapsibleCategory:SetContents( CategoryList ) -- Add our list above us as the contents of the collapsible category

	for _,cvarData in pairs(cvars) do
		if(cvarData.maxValue == 1) then
			CreateCommandCheckbox(cvarData)
		else
			CreateCommandButton(cvarData.name, cvarData.cvar.."_toggle")
		end
		local label = vgui.Create("DLabel")
		label:SetSize(100, 20)
		label:SetText(cvarData.description)
		CategoryList:AddItem(label)
	end
end
concommand.Add("hacks_gui", function()
	if(DermaPanel ~= nil and DermaPanel ~= NULL and DermaPanel:IsVisible()) then
		DermaPanel:Close()
	else
		createGUI()
	end
end)