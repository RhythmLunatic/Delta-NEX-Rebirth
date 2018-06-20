function BasicOrFullMode()
	if ToEnumShortString(GAMESTATE:GetCoinMode()) == "Pay" then
		return "ScreenAP"
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
