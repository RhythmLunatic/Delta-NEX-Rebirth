-- ITEM SCROLLER
-- /////////////////////////////////
local scroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local numWheelItems = 11 --THEME:GetMetric("ScreenSelectGroup", "NumWheelItems")

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
		  		subself:zoom(.75);
			end;
				
			Def.BitmapText{
				Name= "text",
				Font= "Common Normal",
				InitCommand=cmd(addy,100);
			};
			
			Def.Sprite{
				Name="banner";
			};
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		--PrimeWheel(self.container,offsetFromCenter,item_index,numWheelItems)
		self.container:stoptweening();
		if math.abs(offsetFromCenter) < 3 then
			self.container:decelerate(.5);
			self.container:visible(true);
		else
			self.container:visible(false);
		end;
		self.container:x(offsetFromCenter*350)
		self.container:rotationy(offsetFromCenter*-45);
		--self.container:zoom(math.abs(offsetFromCenter)+1/2)
		
		--[[if offsetFromCenter == 0 then
			self.container:diffuse(Color("Red"));
		else
			self.container:diffuse(Color("White"));
		end;]]
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, info)
		self.container:GetChild("text"):settext(info)
		local banner = SONGMAN:GetSongGroupBannerPath(info);
		if banner == "" then
			self.container:GetChild("banner"):Load(THEME:GetPathG("common","fallback banner.png"));
			self.container:GetChild("text"):visible(true);
  		else
  			self.container:GetChild("banner"):Load(banner);
  			self.container:GetChild("text"):visible(false);
		end;
	end,
	gettext=function(self)
		return self.container:GetChild("text"):gettext()
	end,
}}
--local info_set= {"fin", "tail", "gorg", "lilk", "zos", "mink", "aaa"}
local info_set = SONGMAN:GetSongGroupNames();


-- INPUT HANDLER
-- /////////////////////////
local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	if not pn or isSelectingDifficulty then return end

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	if button == "Center" then
		--SCREENMAN:SystemMessage(scroller:get_info_at_focus_pos());
		--IT'S A HACK! (if you don't put local it makes a global variable)
		currentGroup = scroller:get_info_at_focus_pos();
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
	elseif button == "DownLeft" then
		scroller:scroll_by_amount(-1);
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"));
		MESSAGEMAN:Broadcast("PreviousGroup");
	elseif button == "DownRight" then
		scroller:scroll_by_amount(1);
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"));
		MESSAGEMAN:Broadcast("NextGroup");
	end
	
	if button == "MenuDown" then
		local groupName = scroller:get_info_at_focus_pos()
		SCREENMAN:SystemMessage(groupName.." | "..SONGMAN:GetSongGroupBannerPath(groupName));
	end;
	
end;

-- ACTORFRAMES FOR BOTH
-- ////////////////////////
local t = Def.ActorFrame{
	OnCommand=function(self)
		scroller:set_info_set(info_set, 1);
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		SCREENMAN:SystemMessage(math.ceil(numWheelItems/2));
	end;
	
};
t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, SCREEN_CENTER_X, SCREEN_CENTER_Y);

--Header
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
			if stageNum < 10 then
				self:settext("0"..stageNum);
			else
				self:settext(stageNum);
			end
		end;
	}
};

t[#t+1] = LoadFont("frutiger/frutiger 24px")..{
		--Text="Insert Text Here";
		InitCommand=cmd(Center;addy,150;);
		PreviousGroupMessageCommand=cmd(playcommand,"UpdateText");
		NextGroupMessageCommand=cmd(playcommand,"UpdateText");
		TestCommand=function(self)
			SCREENMAN:SystemMessage("passed");
		end;
		UpdateTextCommand=function(self)
			local groupName = scroller:get_info_at_focus_pos()
			if groupName then
				local fir = SONGMAN:GetSongGroupBannerPath(groupName);
				if not fir then 
					self:settext("Need banner!");
					return;
				end;
				local dir = gisub(fir,'banner.png','info/text.ini');
				--SCREENMAN:SystemMessage(dir);
				if FILEMAN:DoesFileExist(dir) then
					local tt = lua.ReadFile(dir);
					self:settext(tt);
					(cmd(stoptweening;zoom,.7;shadowlength,0;wrapwidthpixels,420/1;))(self);
				else
					self:settext("Need /info/text.ini!");
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
		end;
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


return t;
