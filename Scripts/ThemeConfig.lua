

function FailMode()
	if GetUserPref("UserPrefGameLevel") == "Ultimate" then
		return "FailImmediate"
	end
	if GetUserPref("UserPrefGameLevel") == "Pro" then
		return "FailImmediateContinue"
	end
	if GetUserPref("UserPrefGameLevel") == "Standard" then
		return "FailOff"
	end
	if GetUserPref("UserPrefGameLevel") == "Beginner" then
		return "FailOff"
	end
end


function scorecap(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end




function InitUserPrefs()
	if GetUserPref("UserPrefGameLevel") == nil then
		SetUserPref("UserPrefGameLevel", "Standard");
	end;
	
	if GetUserPrefB("UserPrefDetailedPrecision") == nil then
		SetUserPref("UserPrefDetailedPrecision", false);
	end;
	
	if GetUserPref("UserPrefJudgmentType") == nil then
		SetUserPref("UserPrefJudgmentType", "Normal");
	end;
	
	if GetUserPref("UserPrefScorePosition") == nil then
		SetUserPref("UserPrefScorePosition", "Off");
	end;
	
	if GetUserPrefB("UserPrefLite") == nil then
		SetUserPref("UserPrefLite", true);
	end;

		
end;


function SetPrefBranch()
		if GetUserPref("UserPrefSetPreferences") == "Yes" then
			return "ScreenTitleMenu"
		else
			return "ScreenPrefPrompt"
		end
end

--foi uma merda pra entender isso, então pra não esquecer eu vou comentar esse lixo.
function UserPrefGameLevel()
	local t = {
		Name = "UserPrefGameLevel";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "Beginner","Standard","Pro","Ultimate"};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefGameLevel") == nil then
				list[2] = true;
				WritePrefToFile("UserPrefGameLevel","Standard");

			else
				if GetUserPref("UserPrefGameLevel") == "Beginner" then
					list[1] = true;
				end

				if GetUserPref("UserPrefGameLevel") == "Standard" then
					list[2] = true;
				end

				if GetUserPref("UserPrefGameLevel") == "Pro" then
					list[3] = true;
				end			
				
				if GetUserPref("UserPrefGameLevel") == "Ultimate" then
					list[4] = true;
				end	

			end;
		end;
		SaveSelections = function(self, list, pn)
			local val;
				-- ao escolher uma opção, a string da escolha é é devidamente salva na preferência
				if list[1] then
					val = "Beginner"
				end

				if list[2] then
					val = "Standard"
				end

				if list[3] then
					val = "Pro"
				end
				
				if list[4] then
					val = "Ultimate"
				end
				
			WritePrefToFile("UserPrefGameLevel",val);
		end;
	};
	setmetatable( t, t );
	return t;
end






function UserPrefLite()
	local t = {
		Name = "UserPrefLite";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "Low", "High"};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefLite") == nil then
				list[2] = true;
				WritePrefToFile("UserPrefLite",true);
			else
				if GetUserPrefB("UserPrefLite") == true then
					list[2] = true;
				end

				if GetUserPrefB("UserPrefLite") == false then
					list[1] = true;
				end

			end;
		end;
		SaveSelections = function(self, list, pn)
			local val;
				-- ao escolher uma opção, a string da escolha é é devidamente salva na preferência
				if list[1] then
					val = false
				end

				if list[2] then
					val = true
				end
				
			WritePrefToFile("UserPrefLite",val);
		end;
	};
	setmetatable( t, t );
	return t;
end











function UserPrefDetailedPrecision()
	local t = {
		-- parâmetros auto-explicativos
		Name = "UserPrefDetailedPrecision";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		
		-- escolhas em strings
		Choices = { "Normal","Detailed" };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefDetailedPrecision") == nil then
				list[1] = true;
				WritePrefToFile("UserPrefDetailedPrecision",false);

			else
				if GetUserPrefB("UserPrefDetailedPrecision") == false then
					list[1] = true;
				end

				if GetUserPrefB("UserPrefDetailedPrecision") == true then
					list[2] = true;
				end			


			end;
		end;

		SaveSelections = function(self, list, pn)
			local val;
				-- ao escolher uma opção, a string da escolha é é devidamente salva na preferência
				if list[1] then
					val = false
				end

				if list[2] then
					val = true
				end

			-- cria a merda do arquivo
			WritePrefToFile("UserPrefDetailedPrecision",val);
		end;
	};

	-- faz umas merdas que não entendo, pra funcionar
	setmetatable( t, t );
	return t;
end





function UserPrefJudgmentType()
	local t = {
		-- parâmetros auto-explicativos
		Name = "UserPrefJudgmentType";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		
		-- escolhas em strings
		Choices = { "Normal","Deviation","NX","FIESTA 2","Delta LED"};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefJudgmentType") == nil then
				list[1] = true;
				WritePrefToFile("UserPrefJudgmentType","Normal");
			else
			
				if GetUserPref("UserPrefJudgmentType") == "Normal" then
					list[1] = true;
				end

				if GetUserPref("UserPrefJudgmentType") == "Deviation" then
					list[2] = true;
				end		
				
				if GetUserPref("UserPrefJudgmentType") == "NX" then
					list[3] = true;
				end	

				if GetUserPref("UserPrefJudgmentType") == "FIESTA2" then
					list[4] = true;
				end	
				
				if GetUserPref("UserPrefJudgmentType") == "DELTANEX" then
					list[5] = true;
				end					
				
			end;
		end;

		SaveSelections = function(self, list, pn)
			local val;
				-- ao escolher uma opção, a string da escolha é é devidamente salva na preferência
				if list[1] then
					val = "Normal";
				end

				if list[2] then
					val = "Deviation";
				end
				
				if list[3] then
					val = "NX";
				end

				if list[4] then
					val = "FIESTA2";
				end				

				if list[5] then
					val = "DELTANEX";
				end					
				
			-- cria a merda do arquivo
			WritePrefToFile("UserPrefJudgmentType",val);
		end;
	};

	-- faz umas merdas que não entendo, pra funcionar
	setmetatable( t, t );
	return t;
end







function UserPrefScorePosition()
	local t = {
		-- parâmetros auto-explicativos
		Name = "UserPrefScorePosition";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		
		-- escolhas em strings
		Choices = { "Top","Bottom","Off"};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefScorePosition") == nil then
				list[3] = true;
				WritePrefToFile("UserPrefScorePosition","Off");
			else
			
				if GetUserPref("UserPrefScorePosition") == "Top" then
					list[1] = true;
				end

				if GetUserPref("UserPrefScorePosition") == "Bottom" then
					list[2] = true;
				end		
				
				if GetUserPref("UserPrefScorePosition") == "Off" then
					list[3] = true;
				end	

				
			end;
		end;

		SaveSelections = function(self, list, pn)
			local val;
				-- ao escolher uma opção, a string da escolha é é devidamente salva na preferência
				if list[1] then
					val = "Top";
				end

				if list[2] then
					val = "Bottom";
				end
				
				if list[3] then
					val = "Off";
				end

			-- cria a merda do arquivo
			WritePrefToFile("UserPrefScorePosition",val);
		end;
	};

	-- faz umas merdas que não entendo, pra funcionar
	setmetatable( t, t );
	return t;
end








function UserPrefSetPreferences()
	local t = {
		-- parâmetros auto-explicativos
		Name = "UserPrefSetPreferences";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		
		-- escolhas em strings
		Choices = { "Yes", "No"};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefSetPreferences") == nil then
				list[1] = true;
				WritePrefToFile("UserPrefSetPreferences","Yes");
			else
				if GetUserPref("UserPrefSetPreferences") == "Yes" then
					list[1] = true;
				end

				if GetUserPref("UserPrefSetPreferences") == "No" then
					list[2] = true;
				end		
				
				
			end;
		end;

		SaveSelections = function(self, list, pn)
			local val;
				-- ao escolher uma opção, a string da escolha é é devidamente salva na preferência
				if list[1] then
					val = "Yes";
				end

				if list[2] then
					val = "No";
				end


			-- cria a merda do arquivo
			WritePrefToFile("UserPrefSetPreferences",val);
		end;
	};

	-- faz umas merdas que não entendo, pra funcionar
	setmetatable( t, t );
	return t;
end







function Setup()

		PREFSMAN:SetPreference("TimingWindowSecondsW2",0.045);
		PREFSMAN:SetPreference("TimingWindowSecondsW3",0.09);
		PREFSMAN:SetPreference("TimingWindowSecondsW4",0.135);
		PREFSMAN:SetPreference("TimingWindowSecondsW5",0.18);
		PREFSMAN:SetPreference("TimingWindowSecondsMine",0.1);
		PREFSMAN:SetPreference("TimingWindowSecondsHold",0.25);

		if GetUserPref("UserPrefGameLevel") == "Beginner" then
		PREFSMAN:SetPreference("TimingWindowScale",1);
		SetGamePref("DefaultFail","FailOff");
		end

		if GetUserPref("UserPrefGameLevel") == "Standard" then
		PREFSMAN:SetPreference("TimingWindowScale",0.875);
		SetGamePref("DefaultFail","FailOff");
		end

		if GetUserPref("UserPrefGameLevel") == "Pro" then
		PREFSMAN:SetPreference("TimingWindowScale",0.6);
		SetGamePref("DefaultFail","FailImmediateContinue");
		end
		
		if GetUserPref("UserPrefGameLevel") == "Ultimate" then
		PREFSMAN:SetPreference("TimingWindowScale",0.425);
		SetGamePref("DefaultFail","FailImmediate");
		end

		
		SetUserPref("UserPrefScoringMode","");
		SetUserPref("UserPrefSpecialScoringMode","");
		
		local P1State = GAMESTATE:GetPlayerState(PLAYER_1);
		local P2State = GAMESTATE:GetPlayerState(PLAYER_2);
		local P1Options = P1State:GetPlayerOptionsString("ModsLevel_Preferred");
		local P2Options = P2State:GetPlayerOptionsString("ModsLevel_Preferred");
		P1State:SetPlayerOptions("ModsLevel_Preferred", P1Options..","..FailMode());
		P2State:SetPlayerOptions("ModsLevel_Preferred", P2Options..","..FailMode());
		
		PREFSMAN:SetPreference("ShowNativeLanguage",true);
		--PREFSMAN:SetPreference("EventMode",true);
		PREFSMAN:SetPreference("EditorNoteSkinP1","delta-note");
		PREFSMAN:SetPreference("EditorNoteSkinP2","delta-note");
		PREFSMAN:SetPreference("PercentageScoring",true);
		PREFSMAN:SetPreference("LifeDifficultyScale",0.4);
		--PREFSMAN:SetPreference("ProgressiveLifebar",true);
		PREFSMAN:SetPreference("AllowW1","AllowW1_Never");	
		PREFSMAN:SetPreference("OnlyDedicatedMenuButtons",false);	
		PREFSMAN:SetPreference("Premium","Premium_DoubleFor1Credit");
	
	
end;
