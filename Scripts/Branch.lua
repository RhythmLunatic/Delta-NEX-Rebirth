function BasicOrFullMode()
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

function SelectMusicOrCourse()
	if IsNetSMOnline() then
		return "ScreenNetSelectMusic"
	elseif GAMESTATE:IsCourseMode() then
		return "ScreenSelectCourse"
	else
		return BasicOrFullMode();
	end
end

function UseLoadingScreen()

end
