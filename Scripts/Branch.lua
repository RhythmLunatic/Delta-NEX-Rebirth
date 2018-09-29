local function tess(st)
	return ToEnumShortString(st)
end;

local gs = GAMESTATE;

local function gsgc()
	return gs:GetCoinMode()
end;


function BasicOrFullMode()
	if tess(gsgc()) == base64decode("VUdGNQ==") then
		return base64decode("U2NyZWVuQVA=")
	else
		if ReadPrefFromFile("UserPrefBasicMode") == "Enabled" then
			if ReadPrefFromFile("UserPrefBasicModeType") == "BasicModeGroup" then
				inBasicMode = true
				currentGroup = "BasicModeGroup"
			else
				SONGMAN:SetPreferredSongs("BasicMode")
				GAMESTATE:ApplyGameCommand("sort,preferred");
			end;
			return "ScreenSelectMusicBasic"
		else
			return "ScreenSelectMusic"
		end
	end
end

function SelectMusicOrCourse()
	if IsNetSMOnline() then
		return "ScreenNetSelectMusic"
	elseif GAMESTATE:IsCourseMode() then
		return "ScreenSelectCourse"
	else
		if inBasicMode then
			return "ScreenSelectMusicBasic"
		else
			return "ScreenSelectMusic"
		end;
	end
end

function UseLoadingScreen()

end
