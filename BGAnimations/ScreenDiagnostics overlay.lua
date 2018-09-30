function IsWindowed()
	if PREFSMAN:GetPreference("Windowed") then
		return "Windowed";
	else
		return "Fullscreen";
	end;
end;



local t = Def.ActorFrame{
	CodeMessageCommand=function(self, params)
		if params.Name == "Start" or params.Name == "Center" then
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
		else
			SCREENMAN:SystemMessage("Unknown button: "..params.Name);
		end;
	end;
	
	LoadFont("Common Normal")..{
		Text="Press start or center step to exit.";
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_HEIGHT-20);
		OnCommand=function(self)
			--self:settext(getRandomBackgroundDebug("_random wallpapers"));
		end;
	
	};
	
	LoadFont("Common Normal")..{
		Text="System Information";
		InitCommand=cmd(xy,SCREEN_CENTER_X,20);
	};
	LoadFont("Common Normal")..{
		Text="Delta NEX Rebirth version: "..themeVersion;
		InitCommand=cmd(xy,SCREEN_CENTER_X,40);
	};
	LoadFont("Common Normal")..{
		Text="StepMania build: "..ProductFamily().." "..ProductVersion();
		InitCommand=cmd(xy,SCREEN_CENTER_X,60);
		OnCommand=function(self)
			if ProductVersion() ~= "5.0.12" then
				self:settext(self:GetText().." (Incompatible version!)");
				self:diffuse(Color("Red"));
			else
				self:diffuse(Color("Green"));
			end;
		end;
	};
	LoadFont("Common Normal")..{
		Text="Game Mode: "..ToEnumShortString(GAMESTATE:GetCoinMode());
		InitCommand=cmd(xy,20,100;horizalign,left);
	};
	LoadFont("Common Normal")..{
		Text="Event Mode: "..tostring(GAMESTATE:IsEventMode());
		InitCommand=cmd(xy,20,125;horizalign,left)
	};
	LoadFont("Common Normal")..{
		Text="Memory Cards: "..tostring(PREFSMAN:GetPreference("MemoryCards")).." | Memory Card profiles: "..tostring(PREFSMAN:GetPreference("MemoryCardProfiles"));
		InitCommand=cmd(xy,20,150;horizalign,left)
	};
	LoadFont("Common Normal")..{
		OnCommand=cmd(settext,"Player 1 Memory Card Status: "..ToEnumShortString(MEMCARDMAN:GetCardState(PLAYER_1))..MEMCARDMAN:GetName(PLAYER_1));
		StorageDevicesChangedMessageCommand=function(self)
			self:playcommand("On");
			SCREENMAN:SystemMessage("Memory card state was changed");
		end;
		InitCommand=cmd(xy,20,175;horizalign,left)
	
	};
	LoadFont("Common Normal")..{
		OnCommand=cmd(settext,"Player 2 Memory Card Status: "..ToEnumShortString(MEMCARDMAN:GetCardState(PLAYER_2))..MEMCARDMAN:GetName(PLAYER_2));
		StorageDevicesChangedMessageCommand=function(self)
			self:playcommand("On");
			SCREENMAN:SystemMessage("Memory card state was changed");
		end;
		InitCommand=cmd(xy,20,200;horizalign,left)
	
	};
	LoadFont("Common Normal")..{
		Text="Profiles: "..PROFILEMAN:GetNumLocalProfiles().." ("..join(", ",PROFILEMAN:GetLocalProfileDisplayNames())..")";
		InitCommand=cmd(xy,20,225;horizalign,left);
		OnCommand=function(self)
			if PREFSMAN:GetPreference("MemoryCardProfiles") == true and PROFILEMAN:GetNumLocalProfiles() == 0 then
				self:diffuse(Color("Green"));
				self:settext("Profiles: 0 | Ok!");
			else
				self:diffuse(Color("Red"));
			end;
		end;
	};
	--[[LoadFont("Common Normal")..{
		Text="Memory card save type: "..tostring(ReadPrefFromFile("GuestSaveType"));
		InitCommand=cmd(xy,20,175;horizalign,left)
	
	};]]
	LoadFont("Common Normal")..{
		Text="Resolution: "..PREFSMAN:GetPreference("DisplayWidth").."x"..PREFSMAN:GetPreference("DisplayHeight").." | Aspect ratio: "..round(GetScreenAspectRatio(),2).." | "..IsWindowed();
		InitCommand=cmd(xy,20,250;horizalign,left);
	};
	LoadFont("Common Normal")..{
		Text="Songs: "..SONGMAN:GetNumSongs().."+"..SONGMAN:GetNumAdditionalSongs().." | Groups/Channels: "..SONGMAN:GetNumSongGroups();
		InitCommand=cmd(xy,20,275;horizalign,left);
	};
	LoadFont("Common Normal")..{
		Text="Courses/Music Trains: "..SONGMAN:GetNumCourses().."+"..SONGMAN:GetNumAdditionalCourses();
		InitCommand=cmd(xy,20,300;horizalign,left);
	};
	LoadFont("Common Normal")..{
		Text="BasicModeGroup: ";
		InitCommand=cmd(xy,20,325;horizalign,left);
		OnCommand=function(self)
			if ReadPrefFromFile("UserPrefBasicModeType") == "BasicModeGroup" then
				if SONGMAN:DoesSongGroupExist("BasicModeGroup") == false then
					self:settext(self:GetText().." Missing!");
					self:diffuse(Color("Red"));
				else
					self:settext(self:GetText().." Ok! | "..#SONGMAN:GetSongsInGroup("BasicModeGroup").." songs");
					self:diffuse(Color("Green"));
				end;
			else
				self:settext(self:GetText().." Automatically generated");
			end;
		end;
	};
	
	LoadFont("Common Normal")..{
		--Text="Uptime: "..SecondsToHHMMSS(GetTimeSinceStart(););
		InitCommand=cmd(xy,20,SCREEN_BOTTOM-65;horizalign,left);
		OnCommand=cmd(queuecommand,"UpdateText");
		UpdateTextCommand=cmd(settext,"Uptime: "..SecondsToHHMMSS(GetTimeSinceStart());sleep,1;queuecommand,"UpdateText");
	};
	LoadFont("Common Normal")..{
		--Text="Uptime: "..SecondsToHHMMSS(GetTimeSinceStart(););
		InitCommand=cmd(xy,20,SCREEN_BOTTOM-40;horizalign,left);
		OnCommand=cmd(queuecommand,"UpdateText");
		UpdateTextCommand=cmd(settext,"Time: "..Hour()..":"..Minute()..":"..Second();sleep,1;queuecommand,"UpdateText");
	};
	

};

return t;
