-- Get screen handle so we can adjust the timer.
local MenuTimer;

-- SONGS
local songs = SONGMAN:GetPopularSongs();

local info_set = songs;

-- ITEM SCROLLER
-- /////////////////////////////////
local scroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local numWheelItems = THEME:GetMetric("ScreenSelectGroup", "NumWheelItems")

--Item scroller starts at 0, duh.
local currentItemIndex = 0;

-- Scroller function thingy
local item_mt= {
  __index= {
	-- create_actors must return an actor.  The name field is a convenience.
	create_actors= function(self, params)
	  self.name= params.name
		return Def.ActorFrame{		
			InitCommand= function(subself)
				-- Setting self.container to point to the actor gives a convenient
				-- handle for manipulating the actor.
		  		self.container= subself
		  		subself:SetDrawByZPosition(true);
		  		--subself:zoom(.75);
			end;
				
			--[[Def.BitmapText{
				Name= "text",
				Font= "Common Normal",
				InitCommand=cmd(addy,100);
			};]]
			
			Def.Banner{
				Name="SongBanner";
				InitCommand=cmd(diffusealpha,1);
			};

		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		self.container:stoptweening();
		--PrimeWheel(self.container,offsetFromCenter,item_index,numWheelItems)
		local nx = math.abs(offsetFromCenter)*250;
		if math.abs(offsetFromCenter) > 1 then
			nx = ( ( math.abs( offsetFromCenter ) -1 ) *(69-(math.abs(offsetFromCenter)*-8)) )+250
		end
		local morlss = offsetFromCenter ~= 0 and (offsetFromCenter/math.abs(offsetFromCenter)) or 1
		local yfun = math.min(math.abs(offsetFromCenter),1)
		--Y value is set in ScreenSelectMusic overlay.
		--local y = 0
		if yfun >= 2 then
			ypos = (yfun-2)*3
		end
		function zoomw(offsetFromCenter)
			local ofsfc = math.abs(offsetFromCenter)
			if ofsfc >=1 then ofsfc=1 end
			return 1-ofsfc*.2
		end;
		function zooma(offsetFromCenter)
			local ofsfc = math.abs(offsetFromCenter)
			if ofsfc >=1 then ofsfc=1 end
			return 1-ofsfc*.2
		end;
		self.container:decelerate(.3);
		self.container:x(nx*morlss)
		self.container:zoomx(zooma(offsetFromCenter))
		self.container:zoomy(zoomw(offsetFromCenter))
		self.container:z(		20-(	math.min(math.abs(offsetFromCenter),8)*8	)	)
		self.container:rotationx( 0 );
		self.container:rotationy( morlss*(math.min(math.abs(offsetFromCenter)*98,50)) );
		self.container:rotationz( 0 );
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, song)
		banner = self.container:GetChild("SongBanner");
		local path;
		if song then
			path = song:GetJacketPath();
			banner:scaletoclipped(180,180);
			if not path then
				path = song:GetBannerPath();
				banner:scaletoclipped(250,177);
			end;
		end;
		if not path then path = THEME:GetPathG("Common","fallback banner") end
		banner:Load(path);
	end,
	--[[gettext=function(self)
		return self.container:GetChild("text"):gettext()
	end,]]
}}
--local info_set= {"fin", "tail", "gorg", "lilk", "zos", "mink", "aaa"}


-- INPUT HANDLER
-- /////////////////////////
local function GoToNextScreen()
	--Has no effect.
	--MenuTimer:pause()
	--SCREENMAN:SystemMessage(scroller:get_info_at_focus_pos());
	--IT'S A HACK! (if you don't put local it makes a global variable)
	if initialGroup ~= scroller:get_info_at_focus_pos() then
		currentGroup = scroller:get_info_at_focus_pos();
	end;
	local curItem = scroller:get_actor_item_at_focus_pos();
	--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
	curItem.container:GetChild("banner"):accelerate(.3):zoom(2);
	secondsLeft = MenuTimer:GetSeconds();
	SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
end;

local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	if not pn or isSelectingDifficulty then return end

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	if button == "Center" or button == "Start" then
		GoToNextScreen()
	elseif button == "DownLeft" or button == "Left" then
		scroller:scroll_by_amount(-1);
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		GAMESTATE:SetCurrentSong(scroller:get_info_at_focus_pos());
		MESSAGEMAN:Broadcast("CurrentSongChanged");
	elseif button == "DownRight" or button == "Right" then
		scroller:scroll_by_amount(1);
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		GAMESTATE:SetCurrentSong(scroller:get_info_at_focus_pos());
		MESSAGEMAN:Broadcast("CurrentSongChanged");
	elseif button == "Back" then
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
	else
		--SCREENMAN:SystemMessage(button);
	end;
	
	if button == "MenuDown" then
		local groupName = scroller:get_info_at_focus_pos()
		if initialGroup then
			SCREENMAN:SystemMessage(groupName.." | "..initialGroup);
		else
			SCREENMAN:SystemMessage(groupName.." | No initial group.");
		end;
		--SCREENMAN:SystemMessage(groupName.." | "..SONGMAN:GetSongGroupBannerPath(groupName));
	end;
	
	if button == "MenuUp" then
		--SCREENMAN:SystemMessage(tostring(ReadPrefFromFile("UserPrefHiddenChannels") == "Enabled"));
	end;
	
end;

-- ACTORFRAMES FOR BOTH
-- ////////////////////////

local t = Def.ActorFrame{
	OnCommand=function(self)
		scroller:set_info_set(info_set, 1);
		for key,value in pairs(info_set) do
			if initialGroup == value then
				scroller:scroll_by_amount(key-1)
			end
		end;
		
		
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		MenuTimer = SCREENMAN:GetTopScreen():GetChild("Timer");
		--SecondsLeft is a global variable hack, brought over from ScreenSelectMusic overlay.
		--MenuTimer:SetSeconds(secondsLeft);
		--SCREENMAN:SystemMessage(math.ceil(numWheelItems/2));
		--self:linear(5);
		--self:queuecommand("CheckTimer");
	end;
	--I think this is the only way to check the timer
	CheckTimerCommand=function(self)
		--For some reason it ends the timer instantly because it's at 0 (Maybe it's unitialized?) So just stop the timer at 1 second.
		--Someone is going to see this and complain.
		if MenuTimer:GetSeconds() > 0 and MenuTimer:GetSeconds() < 1 then
			MenuTimer:SetSeconds(0.1);
			GoToNextScreen()
		else
			self:linear(1):queuecommand("CheckTimer");
		end;
	end;
	
	--Handle the hidden channels code
	CodeMessageCommand=function(self, params)
		if params.Name == "SecretGroup" then

		else
			--SCREENMAN:SystemMessage("WTF? "..params.Name);
		end;
	end;
	
	GoFullMode2Command=function(self)
		--SCREENMAN:SetNewScreen("ScreenSelectGroup");
		info_set = getVisibleSongGroups()
		initialGroup = scroller:get_info_at_focus_pos()
		scroller:set_info_set(info_set, 1);
		for key,value in pairs(info_set) do
			if initialGroup == value then
				scroller:scroll_by_amount(key-1)
			end
		end;
	end;
	
	-- BACKGROUND
	--  ScreenSelectGroup background has to be here, because if it's in its original location the diffuse wont be updated when all_channels_unlocked is set to true.
	--  (Probably some kind of attempt to cache the background since it's loading the same screen)
	-- Additionally the Sprite has to be accessible from here so it can be changed when the screen goes to full mode.
	Def.Sprite{
		Name="BackgroundVideo";
		InitCommand=function(self)
			if all_channels_unlocked then
				self:playcommand("GoFullMode2");
			else
				if ReadPrefFromFile("UserPrefBackgroundType") == "Prime" then
					self:Load(THEME:GetPathG("","_VIDEOS/diffuseMusicSelect"))
					self:diffuse(Color("Blue"));
				else
					self:Load(THEME:GetPathG("","_VIDEOS/MusicSelect"));
				end;
			end;
			self:Center():FullScreen();
		end;
		--InitCommand=cmd(Load,THEME:GetPathG("","_VIDEOS/diffuseMusicSelect"));
		GoFullModeMessageCommand=cmd(sleep,.5;queuecommand,"GoFullMode2");
		GoFullMode2Command=function(self)
			self:Load(THEME:GetPathG("","_VIDEOS/diffuseMusicSelect"))
			self:diffuse(Color("Green"))
		end;
	};
};

t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, SCREEN_CENTER_X, SCREEN_CENTER_Y);

--HEADER
t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","header"), false);
	
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(rotationx,30;diffuse,0.08,0.08,0.08,1;diffusetopedge,0.2,0.2,0.2,1;shadowlengthy,-1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_TOP+37;zoomx,0.7;zoomy,0.725;);
		Text="SELECT GROUP";
	};
	
	--TIMER

	LoadActor("B0") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,-0.55);

	};

	LoadActor("B1") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

	};

	LoadActor("B2") .. {
		InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

	};

	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,-0.8;shadowlength,-0.8;horizalign,left;x,SCREEN_CENTER_X+185 ;y,SCREEN_TOP+16;zoom,0.40);
		Text="TIMER"
	};

	--STAGE

	LoadActor("B0") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X-190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,0.55);

	};

	LoadActor("B1") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X-160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,0.6);

	};

	LoadActor("B2") .. {
		InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X-160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,0.6);

	};

	LoadFont("venacti/_venacti 26px bold diffuse")..{
			InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,0.8;shadowlengthy,-0.8;horizalign,right;x,SCREEN_CENTER_X-185;y,SCREEN_TOP+16;zoom,0.40);
			Text="STAGE"
	};

	LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
		InitCommand=cmd(draworder,102;diffuse,0.9,0.9,0.9,0.9;uppercase,true;horizalign,center;x,SCREEN_CENTER_X-160;maxwidth,45;zoomx,0.58;zoomy,0.58;y,SCREEN_TOP+25;shadowlengthx,1;shadowlengthy,-1);
		OnCommand=function(self)
			local stageNum=GAMESTATE:GetCurrentStageIndex()+1
			self:settextf("%02d",stageNum);
		end;
	}
};

t[#t+1] = Def.ActorFrame{

	PreviousGroupMessageCommand=cmd(playcommand,"Update");
	NextGroupMessageCommand=cmd(playcommand,"Update");
	UpdateCommand=function(self)
		--self:GetChild("AnnouncerSound"):playcommand("PlaySound");
		--self:GetChild("Description"):playcommand("UpdateText");
	end;
	--[[TestCommand=function(self)
		SCREENMAN:SystemMessage("passed");
	end;]]

	LoadFont("frutiger/frutiger 24px")..{
		Name="Description";
		--Text="Insert Text Here";
		InitCommand=cmd(Center;addy,150;);
		UpdateTextCommand=function(self)
			local groupName = scroller:get_info_at_focus_pos()
			if groupName then
				local fir = SONGMAN:GetSongGroupBannerPath(groupName);
				if not fir then 
					self:settext(THEME:GetString("ScreenSelectGroup","MissingBannerWarning"));
					return;
				end;
				local dir = gisub(fir,'banner.png','info/text.ini');
				--SCREENMAN:SystemMessage(dir);
				if FILEMAN:DoesFileExist(dir) then
					local tt = lua.ReadFile(dir);
					self:settext(tt);
					(cmd(stoptweening;zoom,.7;shadowlength,0;wrapwidthpixels,420/1;))(self);
				else
					self:settext(THEME:GetString("ScreenSelectGroup","MissingInfoWarning"));
				end;
			else
				self:settext("");
			end;
		end;
	};
	
	Def.Actor{
		Name="AudioPreview";
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				local ss = song:GetSampleStart();
				local length = song:GetSampleLength();
				local audioPath = song:GetPreviewMusicPath();
				--SCREENMAN:SystemMessage(audioPath.." , "..song:GetSampleLength());
				--SOUND:PlayOnce(audioPath, false);
				SOUND:PlayMusicPart(song:GetPreviewMusicPath(), song:GetSampleStart(), song:GetSampleLength(), .2, 5, false, false, false);
			end;
		end;
	};
	--[[Def.Sound{
		Name="AnnouncerSound";
		PlaySoundCommand=function(self)
			local groupName = scroller:get_info_at_focus_pos()
			if groupName then
				local fir = SONGMAN:GetSongGroupBannerPath(groupName);
				if not fir then
					return;
				end;
				local dir = gisub(fir,'banner.png','info/text.ini');
				--TODO: This should be a theme setting for sound priority.
				--Right now it's Announcer -> info folder but some people might like info folder -> announcer
				--Or possibly even info only?
				self:stop();
				local snd = ANNOUNCER_GetSound("Song Category Names", groupName);
				if snd then
					self:load(snd);
					self:play();
					return
				end
				local snd = string.gsub(dir, "text.ini", "sound")
				--SCREENMAN:SystemMessage(snd);
				--GetSound is in AnnouncerUtils for some reason		
				snd = GetSound(snd)
				if snd ~= false then
					self:load(snd);
					self:play();
				end;
			end;
		end;
	};]]
};
	
t[#t+1] = LoadActor(THEME:GetPathG("","footer"), true)..{
	InitCommand=cmd(draworder,130);
};

--Wheel left/right shadow
t[#t+1] = Def.Quad {
	InitCommand=cmd(horizalign,right;draworder,100;faderight,1;;zoomto,120,SCREEN_HEIGHT;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X-320;diffuse,0,0,0,1);
}
t[#t+1] = Def.Quad {
	InitCommand=cmd(horizalign,left;draworder,100;fadeleft,1;;zoomto,120,SCREEN_HEIGHT;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X+320;diffuse,0,0,0,1);
}

--next/prev indicator
--I like it in dance, but people will probably complain...
if GAMESTATE:GetCurrentGame():GetName() == "pump" then
	t[#t+1] = LoadActor(THEME:GetPathG("", "downTap/arrow_left"))..{
			InitCommand=cmd(draworder,131;horizalign,left;vertalign,bottom;xy,SCREEN_LEFT,SCREEN_BOTTOM;zoom,.675;);
			PreviousGroupMessageCommand=cmd(stoptweening;glow,color("1,1,1,.8");xy,SCREEN_LEFT-5,SCREEN_BOTTOM+5;sleep,.12;decelerate,.2;glow,color("0,0,0,0");xy,SCREEN_LEFT,SCREEN_BOTTOM;);
		};
	t[#t+1] = LoadActor(THEME:GetPathG("", "downTap/arrow_right"))..{
			InitCommand=cmd(draworder,131;horizalign,right;vertalign,bottom;xy,SCREEN_RIGHT,SCREEN_BOTTOM;zoom,.675;);
			NextGroupMessageCommand=cmd(stoptweening;glow,color("1,1,1,.8");xy,SCREEN_RIGHT+5,SCREEN_BOTTOM+5;sleep,.12;decelerate,.2;glow,color("0,0,0,0");xy,SCREEN_RIGHT,SCREEN_BOTTOM;);
		};
end;

t[#t+1] = LoadActor("GoSecretMode")..{
	
};


return t;
