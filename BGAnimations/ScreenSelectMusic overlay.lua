local isSelectingDifficulty = false;
local ScreenSelectMusic;

local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	if not pn or isSelectingDifficulty then return end

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	--Keytester
	--SCREENMAN:SystemMessage(button.." "..tostring(isSelectingDifficulty));
	--I'm sorry, but this was the easiest way to get it to move the musicwheel when a folder was closed/opened...
	if button == "Center" then
		MESSAGEMAN:Broadcast("CurrentSongChanged");
	end

	--If basic mode, don't allow them to close the folder.
	if ScreenSelectMusic:GetName() == "ScreenSelectMusic" then
		if button == "UpRight" or button == "UpLeft" then
			if ScreenSelectMusic:CanOpenOptionsList(pn) then --If options list isn't currently open
				ScreenSelectMusic:StartTransitioningScreen("SM_GoToPrevScreen");
				
				
				--Yes, this is actually how the StepMania source does it. It's pretty buggy.
				--local MusicWheel = ScreenSelectMusic:GetChild('MusicWheel');
				--local sectionName = MusicWheel:GetSelectedSection("");
				--Unfortunately not lua accessible...
				--MusicWheel:SelectSection(sectionName);
				--SCREENMAN:SystemMessage(MusicWheel:GetCurrentIndex());
				--It's broken???
				--MusicWheel:Move(5);
				--MusicWheel:SetOpenSection("");
				
				--And this is the new function that's far less buggy.
				--ScreenSelectMusic:CloseCurrentSection();
				
				--Debugging stuff
				
			end
		end;
	end;
	
	if button == "MenuUp" then
		--SCREENMAN:SystemMessage(button.." "..tostring(isSelectingDifficulty));
		local groupName = ScreenSelectMusic:GetChild('MusicWheel'):GetSelectedSection();
		local jacket = GetSongGroupJacketPath(groupName)
		if jacket then
			SCREENMAN:SystemMessage(jacket);
		else
			SCREENMAN:SystemMessage("none");
		end;
	elseif button == "MenuDown" then
		--[[local groupName = ScreenSelectMusic:GetChild('MusicWheel'):GetSelectedSection();
		local banner = SONGMAN:GetSongGroupBannerPath(groupName);
		SCREENMAN:SystemMessage(banner);]]
		local MusicWheel = ScreenSelectMusic:GetChild('MusicWheel');
		SCREENMAN:SystemMessage(MusicWheel:GetWheelItem(MusicWheel:GetCurrentIndex()):GetType());
	end
	
end;

local t = Def.ActorFrame{
	OnCommand=function(self)
	
		
        --Custom input code that isn't confusing at all /s
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		--SCREENMAN:set_input_redirected(PLAYER_1,false);
		
		ScreenSelectMusic = SCREENMAN:GetTopScreen();
		--CurrentGroup comes from the group select overlay (It's a global variable hack!)
		if currentGroup ~= nil then
			SCREENMAN:SystemMessage(currentGroup);
			ScreenSelectMusic:GetChild('MusicWheel'):SetOpenSection(currentGroup);
		end;
	end;
	
	CodeMessageCommand=function(self, params)
		if params.Name == "GoFullMode" then
			ScreenSelectMusic:lockinput(3);
			--SCREENMAN:SystemMessage("Full Mode triggered!");
			GAMESTATE:ApplyGameCommand("sort,group");
			ScreenSelectMusic:StartTransitioningScreen("SM_GoToPrevScreen");
		else
			SCREENMAN:SystemMessage("WTF? "..params.Name);
		end;
	end;
	
	--I guess this might as well be here since all the musicwheel stuff is here already
	--Handle group descriptions.
	LoadFont("frutiger/frutiger 24px")..{
		InitCommand=cmd(Center;addy,150;--[[diffusebottomedge,Color("Red")]]);
		
		--Handle moving the MusicWheel;
		CurrentSongChangedMessageCommand=function(self)
			local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
			local song = GAMESTATE:GetCurrentSong();
			if song then
				MusicWheel:y(SCREEN_CENTER_Y+120);
				MESSAGEMAN:Broadcast("SelectingSong");
				self:settext("");
				--self:settext(song:GetTranslitMainTitle())
			--if no song, but there's a song next to the currently selected one, a folder is probably still open or has been opened
			elseif song == nil and MusicWheel:GetWheelItem(MusicWheel:GetCurrentIndex()):GetType() == 2 then
				MusicWheel:y(SCREEN_CENTER_Y+120);
				MESSAGEMAN:Broadcast("SelectingSong");
				self:settext("");
			--if no song and no song next to it, the folder is probably closed
			else
				--inGroupSelect = true;
				MESSAGEMAN:Broadcast("SelectingGroup");
				MusicWheel:y(SCREEN_CENTER_Y);
				local groupName = MusicWheel:GetSelectedSection();
				if groupName then
					local fir = SONGMAN:GetSongGroupBannerPath(groupName);
					local dir = gisub(fir,'banner.png','info/text.ini');
					--SCREENMAN:SystemMessage(dir);
					if FILEMAN:DoesFileExist(dir) then
						local tt = lua.ReadFile(dir);
						self:settext(tt);
						(cmd(stoptweening;zoom,.7;shadowlength,0;wrapwidthpixels,420/1;))(self);
					else
						self:settext("");
					end;
					--TODO: This should be a theme setting for sound priority.
					--Right now it's Announcer -> info folder but some people might like info folder -> announcer
					--Or possibly even info only?
					if not ANNOUNCER_PlaySound("Song Category Names", groupName) then
						--If ANNOUNCER_PlaySound() didn't find a sound or there isn't an announcer enabled, it will return false.
						local snd = string.gsub(dir, "text.ini", "sound")
						--SCREENMAN:SystemMessage(snd);
						PlaySound(snd)
					end;
				else
					self:settext("");
				end;
			end
		end;
	};
	
	
	--Needs to sleep because without it, isSelectingDifficulty will be false while they close the difficulty select instead of after.
	TwoPartConfirmCanceledMessageCommand=function(self)
		local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		MusicWheel:accelerate(.2);
		MusicWheel:y(SCREEN_CENTER_Y+120)
		
		self:sleep(.05);
		self:queuecommand("DifficultySelectExited");
	end;
	
	SongChosenMessageCommand=function(self)
		local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		MusicWheel:accelerate(.2);
		MusicWheel:y(SCREEN_BOTTOM+300);
		
		isSelectingDifficulty = true;
	end;
	
	SongUnchosenMessageCommand=function(self)
		local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		MusicWheel:accelerate(.2);
		MusicWheel:y(SCREEN_CENTER_Y+120)
		
		self:sleep(.05);
		self:queuecommand("DifficultySelectExited");
	end;
	
	DifficultySelectExitedCommand=function(self)
		isSelectingDifficulty = false;
	end;

}


t[#t+1] = LoadActor(THEME:GetPathS("","EX_Move"))..{
	OptionsListOpenedMessageCommand=cmd(play);
	OptionsListClosedMessageCommand=cmd(play);	
	OptionsListRightMessageCommand=cmd(play);
	OptionsListLeftMessageCommand=cmd(play);	
	OptionsListQuickChangeMessageCommand=cmd(play);	
}
t[#t+1] = LoadActor(THEME:GetPathS("","EX_Confirm"))..{
	OptionsListClosedMessageCommand=cmd(play);	
	OptionsListStartMessageCommand=cmd(play);
	OptionsListResetMessageCommand=cmd(play);	
}
t[#t+1] = LoadActor(THEME:GetPathS("","EX_Select"))..{
	OptionsListPopMessageCommand=cmd(play);
	OptionsListPushMessageCommand=cmd(play);	
}
t[#t+1] = LoadActor(THEME:GetPathS("","Common Cancel"))..{
	SongUnchosenMessageCommand=cmd(play);
}


return t
