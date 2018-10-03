local function obf(st)
	return base64decode(st)
end;

local function asdf()
	return _G[obf('VG9FbnVtU2hvcnRTdHJpbmc=')](_G[obf('R0FNRVNUQVRF')][obf('R2V0Q29pbk1vZGU=')](_G[obf('R0FNRVNUQVRF')]));
end;


function BasicOrFullMode()
	if asdf() == obf("UGF5") then
		return obf("U2NyZWVuQVA=")
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

function GameOverOrContinue()
	if THEME:GetMetric("ScreenContinue", "ContinueEnabled") then
		return "ScreenContinue"
	else
		return "ScreenEvaluationSummary"
	end
end

function UseLoadingScreen()

end
