themeInfo = {
	Name = "Ultimate",
	Version = "0.3.0 - 20170708",
};

--//================================================================

Navigation = {
	{ Icon = 1, 	Name = "Play",		Screen = "ScreenProfileLoad" },
	{ Icon = 4, 	Name = "Home",		Screen = "ScreenTitleMenu" },
	{ Icon = 2, 	Name = "Profiles",	Screen = "ScreenOptionsManageProfiles" },
	{ Icon = 3, 	Name = "Reload",	Screen = "ScreenReloadSongs" },
	{ Icon = 5, 	Name = "Options",	Screen = "ScreenOptionsService" },
	{ Icon = 6, 	Name = "Quit",		Screen = "ScreenExit" },
}

--//================================================================

function VersionBranch(ver)
	local search = string.find(string.lower(ProductVersion()), string.lower(ver));
	return search == 1;
end;

--//================================================================

function GetPreviousScreen()
	if Global.screen == "ScreenSelectMusicCustom" then
		return "ScreenTitleMenu"
	else
		return Global.screen
	end;
end;

--//================================================================

function HoldWeight()
	if Game() == "Pump" then
		if PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Never' then
			return THEME:GetMetric("ScoreKeeperNormal", "PercentScoreWeightW2");
		else
			return THEME:GetMetric("ScoreKeeperNormal", "PercentScoreWeightW1");
		end;
	else
		return 0
	end;
end;

--//================================================================

function RedirCheckpointTNS()
	if PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Never' then
		return "TapNoteScore_W2"
	else
		return "TapNoteScore_W1"
	end;
end;

--//================================================================

function Game()
	local game = string.upper(GAMESTATE:GetCurrentGame():GetName());
	local temp1 = string.sub(string.lower(game), 2);
	local text = string.gsub(string.upper(game),string.upper(temp1),temp1);
	return text
end;

--//================================================================

function NavigationAction(index)
	if GAMESTATE:GetNumSidesJoined() == 0 then
		GAMESTATE:JoinPlayer(PLAYER_1);
	end;
	SCREENMAN:SetNewScreen(Navigation.Screen[index]);
end;


--//================================================================

function GetEntry(element, list)
	if not list or #list < 1 then return 1 end
    local entry;
    if element ~= nil then
        for entry=1,#list do
            if list[entry] == element then
                return entry;
            end;
        end;
    end
    return 1;
end;

--//================================================================

function SideJoined(pn)
    if GAMESTATE:IsSideJoined(pn) then
        if IsRoutine() then
            return Global.master == pn;
        else
            return true;
        end; 
    else
        return false;
    end;
end;

--//================================================================

function pnAlign(pn) if pn == PLAYER_1 or pn == 1 then return left elseif pn == PLAYER_2 or pn == 2 then return right else return nil end; end;
function pnSide(pn) if pn == PLAYER_1 or pn == 1 then return -1 elseif pn == PLAYER_2 or pn == 2 then return 1 else return nil end; end;
function pnFade(pn,self,amount) if pn == PLAYER_1 or pn == 1 then self:faderight(amount) elseif pn == PLAYER_2 or pn == 2 then self:fadeleft(amount) end; end;
function pnCrop(pn,self,amount) if pn == PLAYER_1 or pn == 1 then self:cropright(amount) elseif pn == PLAYER_2 or pn == 2 then self:cropleft(amount) end; end;

--//================================================================

function Setup()
	PREFSMAN:SetPreference("EventMode", true);
	PREFSMAN:SetPreference("MenuTimer", false);
	PREFSMAN:SetPreference("PercentageScoring", true);
end

--//================================================================

function ToInit() 
	if GAMESTATE:GetCoinMode() == 'CoinMode_Home' then 
		return "ScreenInit" 
	else 
		return "ScreenExit" 
	end; 
end;

function ToTitleMenu() 
	if GAMESTATE:GetCoinMode() == 'CoinMode_Home' then 
		return "ScreenTitleMenu" 
	else 
		return "ScreenExit" 
	end 
end;

function ToSelectMusic() 
	if GAMESTATE:GetCoinMode() == 'CoinMode_Home' then 
		if SONGMAN:GetNumSongs() == 0 and SONGMAN:GetNumAdditionalSongs() == 0 then
			return "ScreenHowToInstallSongs"
		else
			if IsRoutine() then return "ScreenUnjoin" end;
			return "ScreenSelectMusicCustom" 
		end
	else 
		return "ScreenExit" 
	end; 
end;

function ToGameplay()
	if GAMESTATE:GetCoinMode() == 'CoinMode_Home' then 
		return IsRoutine() and "ScreenGameplayShared" or "ScreenGameplay"
	else 
		return "ScreenExit" 
	end 
end

function AfterGameplay() 
	if GAMESTATE:GetCoinMode() == 'CoinMode_Home' then 
		return "ScreenProfileSave"
	else 
		return "ScreenExit" 
	end; 
end;

function ToEvaluation()
	if GAMESTATE:GetCoinMode() == 'CoinMode_Home' then 
		return "ScreenEvaluationCustom" 
	else 
		return "ScreenExit" 
	end 
end

--//================================================================

function LuaError(str)
	lua.ReportScriptError(str);
end;

--//================================================================

function scorecap(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

--//================================================================

function TextBannerAfterSet(self,param) 
	local Title=self:GetChild("Title"); 
	local Subtitle=self:GetChild("Subtitle"); 
	local Artist=self:GetChild("Artist"); 
	
	if Subtitle:GetText() == "" then 
		(cmd(maxwidth,660;zoom,0.425;shadowlength,1;settext,Title:GetText()))(Title);
		else
		(cmd(maxwidth,660;zoom,0.425;shadowlength,1;settext,Title:GetText().." "..Subtitle:GetText()))(Title);
	end
	(cmd(visible,false))(Subtitle);
	(cmd(visible,false))(Artist);
end

--//================================================================

function EditMenuTransform(self,offsetFromCenter,itemIndex,numItems) 
	local indexOffset = itemIndex-(numItems-1)/2; 
	self:zoom(0.7);
	self:x(numItems-itemIndex);
	self:y( SCREEN_CENTER_Y + indexOffset * 17 ); 
end

function EditHelpTransform(self,offsetFromCenter,itemIndex,numItems) 
	local indexOffset = itemIndex-(numItems-1)/2; 
	self:y( SCREEN_CENTER_Y + indexOffset * 17 ); 
end

