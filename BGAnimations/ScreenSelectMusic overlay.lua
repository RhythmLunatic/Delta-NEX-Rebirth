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
	--[[if button == "Center" then
		MESSAGEMAN:Broadcast("CurrentSongChanged");
	end]]

	--If basic mode, don't allow them to close the folder.
	if ScreenSelectMusic:GetName() == "ScreenSelectMusic" then
		if button == "UpRight" or button == "UpLeft" then
			if ScreenSelectMusic:CanOpenOptionsList(pn) then --If options list isn't currently open
				--ScreenSelectMusic:StartTransitioningScreen("SM_GoToPrevScreen");
				secondsLeft = ScreenSelectMusic:GetChild("Timer"):GetSeconds()
				--Set a global variable so ScreenSelectGroup will jump to the group that was selected before.
				initialGroup = ScreenSelectMusic:GetChild('MusicWheel'):GetSelectedSection()
				SCREENMAN:SetNewScreen("ScreenSelectGroup");
				
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
		--local MusicWheel = ScreenSelectMusic:GetChild('MusicWheel');
		--local currentWheelItem = MusicWheel:GetWheelItem(MusicWheel:GetCurrentIndex());
		--[[local jacket = GetSongGroupJacketPath(groupName)
		if jacket then
			SCREENMAN:SystemMessage(jacket);
		else
			SCREENMAN:SystemMessage("no jacket");
		end;]]
		SCREENMAN:SystemMessage(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle());
		--	SCREENMAN:SystemMessage(currentWheelItem:GetChild("CourseNormalPart"):GetChild("SongBanner"):GetChildren())
	elseif button == "MenuDown" then
		--[[local groupName = ScreenSelectMusic:GetChild('MusicWheel'):GetSelectedSection();
		local banner = SONGMAN:GetSongGroupBannerPath(groupName);
		SCREENMAN:SystemMessage(banner);]]
		--[[local MusicWheel = ScreenSelectMusic:GetChild('MusicWheel');
		SCREENMAN:SystemMessage(MusicWheel:GetWheelItem(MusicWheel:GetCurrentIndex()):GetType());]]
		SCREENMAN:SystemMessage(ScreenSelectMusic:GetChild("Timer"):GetSeconds());
	end
	
end;

local t = Def.ActorFrame{
	OnCommand=function(self)
	
		
        --Custom input code that isn't confusing at all /s
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		--SCREENMAN:set_input_redirected(PLAYER_1,false);
		
		ScreenSelectMusic = SCREENMAN:GetTopScreen();
		
		--Set timer if we came from ScreenSelectGroup
		if secondsLeft ~= nil then
			ScreenSelectMusic:GetChild("Timer"):SetSeconds(secondsLeft)
			--Remove it so we start with 99 seconds if the player is returning from song results, or they reloaded the screen.
			secondsLeft = nil
		end;
		
		--CurrentGroup comes from the group select overlay (It's a global variable hack!)
		if currentGroup ~= nil then
			SCREENMAN:SystemMessage(currentGroup);
			ScreenSelectMusic:GetChild('MusicWheel'):SetOpenSection(currentGroup);
			ScreenSelectMusic:GetChild('MusicWheel'):Move(1);
			ScreenSelectMusic:GetChild('MusicWheel'):Move(0);
			--Set it back to nil so it doesn't switch songs every time you exit and enter the same folder (or returning from a song)
			currentGroup = nil;
			--This doesn't actually work. I think the MusicWheel is bugged.
			--[[local songs = SONGMAN:GetSongsInGroup(currentGroup);
			local out = ScreenSelectMusic:GetChild('MusicWheel'):SelectSong(songs[1])
			SCREENMAN:SystemMessage(tostring(out).." "..songs[1]:GetTranslitMainTitle());]]
		end;
	end;
	
	CodeMessageCommand=function(self, params)
		if params.Name == "GoFullMode" then
			ScreenSelectMusic:lockinput(3);
			--SCREENMAN:SystemMessage("Full Mode triggered!");
			GAMESTATE:ApplyGameCommand("sort,group");
			--ScreenSelectMusic:StartTransitioningScreen("SM_GoToPrevScreen");
			SOUND:PlayOnce(THEME:GetPathS("", "FULL_SOUND"));
			SOUND:PlayOnce(THEME:GetPathS("", "FULL_VOICE"));
			initialGroup = nil; --It can be left over from a previous session
			inBasicMode = false;
			secondsLeft = ScreenSelectMusic:GetChild("Timer"):GetSeconds()
			SCREENMAN:SetNewScreen("ScreenSelectGroup");
		else
			--SCREENMAN:SystemMessage("WTF? "..params.Name);
		end;
	end;
	
	--I guess this might as well be here since all the musicwheel stuff is here already
	--Handle group descriptions.
	LoadFont("frutiger/frutiger 24px")..{
		InitCommand=cmd(Center;addy,150;--[[diffusebottomedge,Color("Red")]]);
		
		--Handle moving the MusicWheel;
		--[[CurrentSongChangedMessageCommand=function(self)
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
		end;]]
		--[[CurrentCourseChangedMessageCommand=function(self)
			SCREENMAN:SystemMessage("Hello World!");
		end;]]
	};
	
	
	--Needs to sleep because without it, isSelectingDifficulty will be false while they close the difficulty select instead of after.
	TwoPartConfirmCanceledMessageCommand=function(self)
		local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		MusicWheel:accelerate(.2);
		MusicWheel:addy(-300)
		
		self:sleep(.05);
		self:queuecommand("DifficultySelectExited");
	end;
	
	SongChosenMessageCommand=function(self)
		local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		MusicWheel:accelerate(.2);
		MusicWheel:addy(300);
		
		isSelectingDifficulty = true;
	end;
	
	SongUnchosenMessageCommand=function(self)
		local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		MusicWheel:accelerate(.2);
		MusicWheel:addy(-300)
		
		self:sleep(.05);
		self:queuecommand("DifficultySelectExited");
	end;
	
	DifficultySelectExitedCommand=function(self)
		isSelectingDifficulty = false;
	end;

}

--WTF is this doing here?
--[[t[#t+1] = LoadActor(THEME:GetPathS("","EX_Move"))..{
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
}]]


return t
