--https://stackoverflow.com/a/19263313
function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end

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