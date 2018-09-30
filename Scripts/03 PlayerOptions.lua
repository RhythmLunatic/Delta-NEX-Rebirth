function table.shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--This defines the custom player options.
PlayerDefaults = {
	DetailedPrecision = false,
	JudgmentType = "Normal",
}

--Set tables so you can do ActiveModifiers["P1"] to get the table of custom player modifiers, ex ActiveModifiers["P1"]["JudgmentType"]
--No metatable because it was too hard to implement
--If you change this, make sure to change it at resetGame too
--[[ActiveModifiers = {
	P1 = table.shallowcopy(PlayerDefaults),
	P2 = table.shallowcopy(PlayerDefaults),
	MACHINE = table.shallowcopy(PlayerDefaults),
}]]

--Test
--[[local AM = { P1 = setmetatable({}, {JT = "Normal"})}
local AM = {{"Test"}, {"Test2"}}
local AM = { P1 = {JT = "Normal"}}
ActiveModifiers = {
	P1 = setmetatable({}, PlayerDefaults),
	P2 = setmetatable({}, PlayerDefaults),
	MACHINE = setmetatable({}, PlayerDefaults)
}
]]

--Requires string:split from Utils
function OptionRowAvailableNoteskins()
	local ns = NOTESKIN:GetNoteSkinNames();
	local disallowedNS = THEME:GetMetric("Common","NoteSkinsToHide"):split(",");
	for i = 1, #disallowedNS do
		for k,v in pairs(ns) do
			if v == disallowedNS[i] then
				table.remove(ns, k)
			end
		end;
	end;
	
	local t = {
		Name="NoteskinsCustom",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = ns,
		LoadSelections = function(self, list, pn)
			--This returns an instance of playerOptions, you need to set it back to the original
			local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			local curNS = playerOptions:NoteSkin();
			local found = false;
			for i=1,#list do
				if ns[i] == curNS then
					list[i] = true;
					found = true;
				end;
			end;
			if not found then
				assert(found,"There was no noteskin selected, but the player's noteskin should be "..curNS);
				list[1] = true;
			end;
		end,
		SaveSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			--list[1] = true;
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin(ns[i]);
						found = true
						--SCREENMAN:SystemMessage("NS set to "..ns[i]);
					end
				end
			end
		end,
	};
	setmetatable(t, t)
	return t
end

function OptionRowScreenFilter()
	--we use integers equivalent to the alpha value multiplied by 10
	--to work around float precision issues
	local choiceToAlpha = {0, 3, 6, 9}
	local alphaToChoice = {[0]=1, [3]=2, [6]=3, [9]=4}
	local t = {
		Name="Filter",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { THEME:GetString('OptionNames','Off'),
			THEME:GetString('OptionTitles', 'FilterDark'),
			THEME:GetString('OptionTitles', 'FilterDarker'),
			THEME:GetString('OptionTitles', 'FilterDarkest'),
		 },
		LoadSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local filterValue = getenv("ScreenFilter"..pName)

			if filterValue ~= nil then
				local val = alphaToChoice[filterValue] or 1
				list[val] = true
			else
				setenv("ScreenFilter"..pName,0)
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						setenv("ScreenFilter"..pName,choiceToAlpha[i])
						found = true
					end
				end
			end
		end,
	};
	setmetatable(t, t)
	return t
end

function OptionRowJudgmentType()
	local judgementNames = { "Normal", "Deviation", "NX", "FIESTA 2", "Delta LED"}
	local t = {
		Name="JudgmentType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = judgementNames,
		LoadSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local found = false;
			for i=1,#list do
				if judgementNames[i] == ActiveModifiers[pName]["JudgmentType"] then
					list[i] = true;
					found = true;
				end;
			end;
			if not found then
				list[1] = true;
				assert(found, "Should have defaulted to Normal judgement, but none was found")
			end;
		end,
		SaveSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						ActiveModifiers[pName]["JudgmentType"] = judgementNames[i];
						found = true
					end
				end
			end
		end,
	};
	setmetatable(t, t)
	return t
end