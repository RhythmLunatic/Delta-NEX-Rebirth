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
	if button == "UpRight" then
		if ScreenSelectMusic:CanOpenOptionsList(pn) then --If options list isn't currently open
			--Yes, this is actually how the StepMania source does it. It's pretty buggy.
			local MusicWheel = ScreenSelectMusic:GetChild('MusicWheel');
			--local sectionName = MusicWheel:GetSelectedSection("");
			--Unfortunately not lua accessible...
			--MusicWheel:SelectSection(sectionName);
			SCREENMAN:SystemMessage(MusicWheel:GetCurrentIndex());
			--It's broken???
			--MusicWheel:Move(5);
			--MusicWheel:SetOpenSection("");
			
			--And this is the new function that's far less buggy.
			ScreenSelectMusic:CloseCurrentSection();
		end
	elseif button == "MenuUp" then
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
		SCREENMAN:SystemMessage(tostring(inGroupSelect));
	end
	
end;

local t = Def.ActorFrame{
	OnCommand=function(self)
	
        --Custom input code that isn't confusing at all /s
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		--SCREENMAN:set_input_redirected(PLAYER_1,false);
		
		ScreenSelectMusic = SCREENMAN:GetTopScreen();
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
			else --if no song
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
					ANNOUNCER_PlaySound("Song Category Names", groupName);
					--SOUND:PlayAnnouncer("Song Category Names/"..groupName); --Unfortunately, does not work.
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