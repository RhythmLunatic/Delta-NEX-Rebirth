

--[[function FailMode()
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
end]]




--[[function InitUserPrefs()
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

		
end;]]


function SetPrefBranch()
	if GetUserPref("UserPrefSetPreferences") == "Yes" then
		return "ScreenTitleMenu"
	else
		return "ScreenPrefPrompt"
	end
end

--foi uma merda pra entender isso, ent„o pra n„o esquecer eu vou comentar esse lixo.
--[[function UserPrefGameLevel()
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
				-- ao escolher uma opÁ„o, a string da escolha È È devidamente salva na preferÍncia
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
end]]

function BasicModeConfig()
	local t = {
		Name = "EnableBasicMode";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		--Write preference immediately when changing. (I'm not sure if false makes it write when exiting)
		ExportOnChange = true;
		--Get the text for the choices from language files (en.ini, es.ini, etc)
		Choices = {THEME:GetString("OptionNames","Disabled"), THEME:GetString("OptionNames","Enabled")};
		
		-- Used internally, this will set the selection on the screen when it is loaded.
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefBasicMode") == "Disabled" then
				list[1] = true;
			else
				list[2] = true;
			end;
		end;
		
		
		SaveSelections = function(self, list, pn)
			if list[2] then
				WritePrefToFile("UserPrefBasicMode","Enabled");
			else
				WritePrefToFile("UserPrefBasicMode","Disabled");
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;

function HiddenChannelsConfig()
	local t = {
		Name = "GroupSelectHiddenChannels";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		--Write preference immediately when changing. (I'm not sure if false makes it write when exiting)
		ExportOnChange = true;
		--Get the text for the choices from language files (en.ini, es.ini, etc)
		Choices = {THEME:GetString("OptionNames","Disabled"), THEME:GetString("OptionNames","Enabled")};
		
		-- Used internally, this will set the selection on the screen when it is loaded.
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefHiddenChannels") == "Disabled" then
				list[1] = true;
			else
				list[2] = true;
			end;
		end;
		
		
		SaveSelections = function(self, list, pn)
			if list[2] then
				WritePrefToFile("UserPrefHiddenChannels","Enabled");
			else
				WritePrefToFile("UserPrefHiddenChannels","Disabled");
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;


--This should probably be changed to true/false, with true being RFID and false/nil being USB
function GuestSaveConfig()
	local t = {
		Name = "GuestSaveType";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = {"USB", "RFID"};
		--Values = { true, false };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("GuestSaveType") == "USB" then
				list[1] = true;
			else
				list[2] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("GuestSaveType","USB");
			else
				WritePrefToFile("GuestSaveType","RFID");
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;

function BasicModeType()
	local t = {
		Name = "BasicModeType";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = {"Autogen", "BasicModeGroup"};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefBasicModeType") == "Autogen" then
				list[1] = true;
			else
				list[2] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("UserPrefBasicModeType","Autogen");
			else
				WritePrefToFile("UserPrefBasicModeType","BasicModeGroup");
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;


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
				-- ao escolher uma opÁ„o, a string da escolha È È devidamente salva na preferÍncia
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

function UserPrefBackgroundType()
	local t = {
		-- par‚metros auto-explicativos
		Name = "UserPrefBackgroundType";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		
		-- escolhas em strings
		Choices = { "Delta NEX","Prime"};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefBackgroundType") == nil then
				list[1] = true;
				WritePrefToFile("UserPrefBackgroundType","Delta NEX");
			else
			
				if GetUserPref("UserPrefBackgroundType") == "Delta NEX" then
					list[1] = true;
				end

				if GetUserPref("UserPrefBackgroundType") == "Prime" then
					list[2] = true;
				end		
			end;
		end;

		SaveSelections = function(self, list, pn)
			local val;
				-- ao escolher uma opÁ„o, a string da escolha ÅEÅEdevidamente salva na preferÍncia
				if list[1] then
					val = "Delta NEX";
				end

				if list[2] then
					val = "Prime";
				end
				
			-- cria a merda do arquivo
			WritePrefToFile("UserPrefBackgroundType",val);
		end;
	};

	-- faz umas merdas que n„o entendo, pra funcionar
	setmetatable( t, t );
	return t;
end

function UserPrefWheelPriority()
	local t = {
		-- par‚metros auto-explicativos
		Name = "UserPrefWheelPriority";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		
		-- escolhas em strings
		Choices = { "Banner", "Jacket", "Auto"};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefWheelPriority") == nil then
				list[3] = true;
				WritePrefToFile("UserPrefWheelPriority","Auto");
			else
			
				if GetUserPref("UserPrefWheelPriority") == "Banner" then
					list[1] = true;
				elseif GetUserPref("UserPrefWheelPriority") == "Jacket" then
					list[2] = true;
				else
					list[3] = true;
				end;
			end;
		end;

		SaveSelections = function(self, list, pn)
			local val;
			if list[1] then
				val = "Banner";
			elseif list[2] then
				val = "Jacket";
			else
				val = "Auto";
			end
			WritePrefToFile("UserPrefWheelPriority",val);
		end;
	};

	-- faz umas merdas que n„o entendo, pra funcionar
	setmetatable( t, t );
	return t;
end



function UserPrefScorePosition()
	local t = {
		-- par‚metros auto-explicativos
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
				-- ao escolher uma opÁ„o, a string da escolha È È devidamente salva na preferÍncia
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

	-- faz umas merdas que n„o entendo, pra funcionar
	setmetatable( t, t );
	return t;
end








function UserPrefSetPreferences()
	local t = {
		-- par‚metros auto-explicativos
		Name = "UserPrefSetPreferences";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		
		-- escolhas em strings
		Choices = { THEME:GetString("OptionNames","Yes"), THEME:GetString("OptionNames","No")};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefSetPreferences") == nil then
				list[1] = false;
				WritePrefToFile("UserPrefSetPreferences","No");
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
				-- ao escolher uma opÁ„o, a string da escolha È È devidamente salva na preferÍncia
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

	-- faz umas merdas que n„o entendo, pra funcionar
	setmetatable( t, t );
	return t;
end






--Rename back to Setup() to enable
function Setup_DISABLED()

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
		--PREFSMAN:SetPreference("AllowW1","AllowW1_Never");	
		PREFSMAN:SetPreference("OnlyDedicatedMenuButtons",false);	
		PREFSMAN:SetPreference("Premium","Premium_DoubleFor1Credit");
	
	
end;
