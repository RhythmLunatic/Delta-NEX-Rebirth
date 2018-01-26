function BasicOrFullMode()
	if ReadPrefFromFile("UserPrefBasicMode") == "Enabled" then
		SONGMAN:SetPreferredSongs("BasicMode")
		GAMESTATE:ApplyGameCommand("sort,preferred");
		return "ScreenSelectMusicBasic"
	else
		return "ScreenSelectMusic"
	end
end

function UseLoadingScreen()

end
