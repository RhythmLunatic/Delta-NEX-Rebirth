local t = Def.ActorFrame{}

t[#t+1] = LoadActor(THEME:GetPathG("","footer"))..{
	InitCommand=cmd(draworder,130);
};

if GAMESTATE:GetCurrentGame():GetName() == "dance" then
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		t[#t+1] = Def.ActorFrame{
			LoadActor("stepsDisplay", pn)..{
				--InitCommand=cmd(xy,160,180);
				InitCommand=function(self)
					if pn == "PlayerNumber_P2" then
						self:x(SCREEN_WIDTH-160)
					else
						self:x(160);
					end;
					self:y(180);
				end;
			};
		};
	end;
end;

--Player score thingy
--Spaced 55px apart.
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(pn))
			if pn == PLAYER_1 then
				self:x(SCREEN_CENTER_X-250);
			else
				self:x(SCREEN_CENTER_X+250);
			end;
			
			self:diffusealpha(0);
		end;
		
		
		SongChosenMessageCommand=cmd(stoptweening;linear,.2;diffusealpha,1);
		TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
		PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(player));
		
		LoadActor("MachineScore", pn)..{
			InitCommand=cmd(y,120);
		};
		LoadActor("PlayerScore", pn)..{
			InitCommand=cmd(y,175);
		};
	};
end;
--[[t[#t+1] = Def.Quad {
	InitCommand=cmd(draworder,2;visible,true;diffuse,color("1,0,0.2,0");x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-100;scaletoclipped,262,130;diffusealpha,0.4;fadetop,0.4;fadebottom,0.4);
]]--

-- BANNER CENTRAL -- BACKGROUND


t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-50);
	--OnCommand=cmd(visible,SCREENMAN:GetTopScreen():GetName() ~= "ScreenSelectCourse");
	OnCommand=cmd(fov,60;vanishpoint,SCREEN_CENTER_X,SCREEN_CENTER_Y+90;);
	--[[CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		if song then
			self:linear(0.2)
			self:diffusealpha(1);
		else
			self:linear(0.2)
			self:diffusealpha(0);
		end
	end;]]
	--[[Def.Quad {
		InitCommand=cmd(diffuse,color("0,0,0,1");scaletoclipped,260+1,160;diffusealpha,0.7);
	};
	
	Def.Quad {
		InitCommand=cmd(diffuse,color("0,0,0,1");setsize,290,160;diffusealpha,1);
	};]]
	
	--SONG BACKGROUND
	--[[Def.Sprite {
		CurrentSongChangedMessageCommand=cmd(finishtweening;queuecommand,"ModifySongBackground");
		ModifySongBackgroundCommand=function(self)
			self:stoptweening();
			self:diffusealpha(0);
			if GAMESTATE:GetCurrentSong() then
				if not GAMESTATE:GetCurrentSong():GetPreviewVidPath() then
					self:sleep(.2);--Delay the loading a little to reduce lag when scrolling through the wheel
					self:queuecommand("LoadSongBG"); --If you use playcommand, the sleep() will be ignored!
				end;
			end;
		end;
		
		LoadSongBGCommand=function(self)
			self:LoadFromSongBackground(GAMESTATE:GetCurrentSong());
			--self:scaletoclipped(290,160);
			--self:cropto(200,200);
			--self:customtexturerect(100,100,100,100);
			--self:zoomto(290,160);
			--self:setsize(290,160);
			--self:cropto(290,160);
			--self:SetWidth(290);
			self:scaletocover(-145,-80,145,80);
			local tex = self:GetTexture();
			local ratio_16by9 = round(16/9, 2);
			local ratio_image = round(tex:GetImageWidth()/tex:GetImageHeight(), 2);
			if ratio_16by9 == ratio_image then
				self:cropbottom(0);
				self:croptop(0);
				--SCREENMAN:SystemMessage(ratio_16by9.." "..ratio_image);
			else
				--It works and I don't know why. It's probably also very demanding on the CPU.
				local cropRatio = math.abs((ratio_16by9 - ratio_image)/3.5)
				self:croptop(cropRatio)
				self:cropbottom(cropRatio)
				--SCREENMAN:SystemMessage(ratio_16by9.." "..ratio_image.." "..cropRatio);
			end;

			self:diffusealpha(0);
			self:linear(0.5);
			self:diffusealpha(1);
		end
	};]]
	
	--SONG VIDEO
	Def.Sprite {
		CurrentSongChangedMessageCommand=cmd(finishtweening;diffusealpha,0;queuecommand,"ModifySongBackground");

		ModifySongBackgroundCommand=function(self)
			if GAMESTATE:GetCurrentSong() ~= nil then
				--SCREENMAN:SystemMessage(GAMESTATE:GetCurrentSong():GetPreviewVidPath() or "none");
				
				self:sleep(.3);--Delay the loading a little to make it in sync with the music. This also makes the game less laggy when switching songs. (It's still a bit early, but whatever)
				self:queuecommand("LoadSongBG"); --If you use playcommand, the sleep() will be ignored!
				--self:diffuse(Color("White"));
			end;
		end;
		
		--It's in a separate command because that's the only way to delay Load();
		LoadSongBGCommand=function(self)
			local path = GAMESTATE:GetCurrentSong():GetPreviewVidPath()
			if path then
				--self:Load(THEME:GetPathG("ScrollBar","middle"));
				self:Load( path );
				self:scaletoclipped(288,162);
				self:linear(.4):diffusealpha(1);
			else
				self:diffusealpha(0);
			end;
		end;
	};
	
	--SONG TITLE SHADOW
	Def.Quad{
		InitCommand=cmd(setsize,290,35;vertalign,bottom;diffuse,color("0,0,0,.8");addy,81;fadetop,.2);
	};
	
	--SONG TITLE
	LoadFont("venacti/_venacti 13px bold diffuse")..{
		InitCommand=cmd(addx,-135;addy,58;zoom,.5;maxwidth,450;faderight,1;--[[fadeleft,1;]]diffusealpha,0;horizalign,left);
		OnCommand=cmd(linear,.8;faderight,0;fadeleft,0;diffusealpha,1);
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				self:settext(song:GetDisplayFullTitle());
			--[[elseif GAMESTATE:GetCurrentCourse() then
				self:settext(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle());]]
			else
				self:settext("");
			end;
		end;
		--[[CurrentCourseChangedMessageCommand=function(self)
			if GAMESTATE:GetCurrentCourse() and SCREENMAN:GetTopScreen():GetName() == "ScreenSelectCourse" then
				local course = GAMESTATE:GetCurrentCourse();
				if course then
					self:settext(course:GetDisplayFullTitle());
				else
					self:settext("");
				end;
			end;
		end;]]
	};
	
	--SONG ARTIST
	LoadFont("venacti/_venacti 13px bold diffuse")..{
		InitCommand=cmd(maxwidth,530;horizalign,left;addx,-135;addy,71;zoomx,0.385;zoomy,0.38;shadowlength,1);
		OnCommand=cmd(diffusealpha,0;strokecolor,Color("Outline");shadowlength,1;sleep,0.3;linear,0.8;diffusealpha,1);
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			if song then
				self:settext(song:GetDisplayArtist());
				self:diffusealpha(1);
			elseif GAMESTATE:GetCurrentCourse() then
				self:settext(GAMESTATE:GetCurrentCourse():GetGroupName())
			else
				self:settext("---");
				self:diffusealpha(0.3);
			end
		end;
		--[[CurrentCourseChangedMessageCommand=function(self)
			local course = GAMESTATE:GetCurrentCourse();
			if course then
				self:settext(course:GetGroupName());
				self:diffusealpha(1);
			else
				self:settext("");
			end;
		end;]]
	};
	
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(addx,135;addy,58;zoom,.5;maxwidth,530;diffusealpha,0;horizalign,right);
		OnCommand=cmd(linear,.8;diffusealpha,1);
		Text="BPM";
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				self:diffusealpha(1);
			else
				self:diffusealpha(0);
			end;
		end;
		--[[CurrentCourseChangedMessageCommand=function(self)
			if GAMESTATE:GetCurrentCourse() and SCREENMAN:GetTopScreen():GetName() == "ScreenSelectCourse" then
				local course = GAMESTATE:GetCurrentCourse();
				if course then
					self:settext(course:GetDisplayFullTitle());
				else
					self:settext("");
				end;
			end;
		end;]]
	};
	--BPM DISPLAY
	LoadFont("venacti/_venacti 13px bold diffuse")..{
		InitCommand=cmd(addx,135;horizalign,right;addy,71;zoomx,0.385;zoomy,0.38;shadowlength,1);
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				if song:IsDisplayBpmSecret() then
					self:settext("???")
					
				else
					local bpm = song:GetDisplayBpms()
					if bpm[1] ~= bpm[2] then
						self:settext(round(bpm[1], 0).."-"..round(bpm[2],0));
					else
						self:settext(round(bpm[1], 0))
					end;
				end;
			else
				self:settext("");
			end;
		end;
		--[[CurrentCourseChangedMessageCommand=function(self)
			if GAMESTATE:GetCurrentCourse() and SCREENMAN:GetTopScreen():GetName() == "ScreenSelectCourse" then
				local course = GAMESTATE:GetCurrentCourse();
				if course then
					self:settext(course:GetDisplayFullTitle());
				else
					self:settext("");
				end;
			end;
		end;]]
	};
	
	--LONG SONG WARNING
	Def.Quad{
		InitCommand=cmd(setsize,290,28;vertalign,top;fadebottom,.2;addy,-82;);
		CurrentSongChangedMessageCommand=function(self)
			--diffuse,Color("Red");
			local song = GAMESTATE:GetCurrentSong();
			if song and song:IsLong() then
				self:visible(true)
				self:diffuse(color("#eb9100CC"));
			elseif song and song:IsMarathon() then
				self:visible(true)
				self:diffuse(color("#ff2424CC"));
			else
				self:visible(false)
			end
		end;
	
	};
	LoadFont("venacti/_venacti 13px bold diffuse")..{
		InitCommand=cmd(maxwidth,525;vertalign,top;addy,-77;zoom,.5;shadowlength,1;shadowcolor,color("#000000BB"));
		--Text="FULL SONG: This song requires 2 stages.";
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			if song and song:IsLong() then
				self:visible(true)
				self:settext(THEME:GetString("ScreenSelectMusic","FullSongWarning"));
			elseif song and song:IsMarathon() then
				self:visible(true)
				self:settext(THEME:GetString("ScreenSelectMusic","MarathonWarning"));
			else
				self:visible(false)
			end
		end;
	};
	
	
	--[[LoadActor("songback") .. {
		InitCommand=cmd(draworder,6;zoomy,0.675;zoomx,0.65);

	};]]
	LoadActor("jacket_light") .. {
		InitCommand=cmd(draworder,100;zoomx,1.45;zoomy,.81;effectclock,"bgm";blend,Blend.Add);
		
		StartSelectingGroupMessageCommand=cmd(visible,false);
		StartSelectingSongMessageCommand=cmd(visible,true);
		
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"CheckSteps");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"CheckSteps");

		SongChosenMessageCommand=function(self)
			self:visible(false);
		end;
		SongUnchosenMessageCommand=function(self)
			self:visible(true);
		end;
		TwoPartConfirmCanceledMessageCommand=function(self)
			self:visible(true);
		end;
		
		CheckStepsCommand=function(self,params)

			local stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1);
			local stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2);
			local threshold = THEME:GetMetric("SongManager","ExtraColorMeter");

				if not stepsP1 then
					meterP1 = 0
				else
					meterP1 = stepsP1:GetMeter()
				end

				if not stepsP2 then
					meterP2 = 0
				else
					meterP2 = stepsP2:GetMeter()
				end


				if meterP1>=threshold or meterP2>=threshold then
					self:playcommand("Extra");
				else
					self:playcommand("Normal");
				end;

		end;

		NormalCommand=cmd(blend,Blend.Add;diffuseshift;effectcolor1,color("#88CCFFFF");effectcolor2,color("#88CCFF33"));
		ExtraCommand=cmd(blend,Blend.Add;diffuseshift;effectcolor1,color("#FFCC00FF");effectcolor2,color("#FFCC0033"));

	};
	
	LoadActor("leftpress") .. {
		InitCommand=cmd(draworder,100;x,-200;diffusealpha,0;zoom,0.675;blend,Blend.Add);
		PreviousSongMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,0.15;linear,0.3;diffusealpha,0);
	};

	LoadActor("leftpress") .. {
		InitCommand=cmd(draworder,100;x,200;rotationy,180;diffusealpha,0;zoom,0.675;blend,Blend.Add);
		NextSongMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,0.15;linear,0.3;diffusealpha,0);
	};
};

local bannerFirst = true;
if GetUserPref("UserPrefWheelPriority") == "Banner" then
	--Don't need to assign, since it's already true
	--bannerFirst = true;
elseif GetUserPref("UserPrefWheelPriority") == "Jacket" then
	bannerFirst = false;
else --Auto
	if GAMESTATE:GetCurrentGame():GetName() == "pump" then
		bannerFirst = true;
	else
		bannerFirst = false; --Prioritize jackets for every other game mode
	end;
end;

-- BANNER MASK DANCE

if GAMESTATE:GetCurrentGame():GetName() == "dance" then
	t[#t+1] = LoadActor("bannermask") .. {
		InitCommand=cmd(draworder,5;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-101;zoomy,0.58;zoomx,0.58);

	};

	t[#t+1] = LoadActor("A1") .. {
		InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X-147;y,SCREEN_CENTER_Y-100;draworder,2;diffusealpha,0);
		SongChosenMessageCommand=cmd(diffusealpha,0);
		PreviousSongMessageCommand=cmd(horizalign,right;diffusealpha,0.9;stoptweening;zoomy,0.5;zoomx,0.5;linear,0.2;zoomx,0.3;diffusealpha,0);
		TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,0);
		SongUnchosenMessageCommand=cmd(diffusealpha,0);
		ChangeStepsMessageCommand=function(self, params)
			if  params.Direction == 1 then
				--Nothing here???
			elseif params.Direction == -1 then
				self:stoptweening();
				self:horizalign(right);
				self:diffusealpha(0.7);
				self:zoomy(0.5);
				self:zoomx(0.5);
				self:linear(0.2);
				self:zoomx(0.2);
				self:diffusealpha(0);
			end;
		end;

	}

	t[#t+1] = LoadActor("A2") .. {
		InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X-147;y,SCREEN_CENTER_Y-100;draworder,2;diffusealpha,0);
		SongChosenMessageCommand=cmd(diffusealpha,0);
		PreviousSongMessageCommand=cmd(horizalign,right;diffusealpha,0.9;stoptweening;zoomy,0.5;zoomx,0.5;linear,0.2;zoomx,0.3;diffusealpha,0);
		TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,0);
		SongUnchosenMessageCommand=cmd(diffusealpha,0);
		ChangeStepsMessageCommand=function(self, params)
			if  params.Direction == 1 then
			
			elseif params.Direction == -1 then
				self:stoptweening();
				self:horizalign(right);
				self:diffusealpha(0.7);
				self:zoomy(0.5);
				self:zoomx(0.5);
				self:linear(0.2);
				self:zoomx(0.2);
				self:diffusealpha(0);
			end;
		end;

	}


	t[#t+1] = LoadActor("A1") .. {
		InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X+147;y,SCREEN_CENTER_Y-100;draworder,2;diffusealpha,0;rotationy,180);
		SongChosenMessageCommand=cmd(diffusealpha,0);
		NextSongMessageCommand=cmd(horizalign,right;diffusealpha,0.9;stoptweening;zoomy,0.5;zoomx,0.5;linear,0.2;zoomx,0.3;diffusealpha,0);
		TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,0);
		SongUnchosenMessageCommand=cmd(diffusealpha,0);
			ChangeStepsMessageCommand=function(self, params)
			if  params.Direction == 1 then
			self:stoptweening();
			self:horizalign(right);
			self:diffusealpha(0.7);
			self:zoomy(0.5);
			self:zoomx(0.5);
			self:linear(0.2);
			self:zoomx(0.2);
			self:diffusealpha(0);
			elseif params.Direction == -1 then
			end;
			end;
	}

	t[#t+1] = LoadActor("A2") .. {
		InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X+147;y,SCREEN_CENTER_Y-100;draworder,2;diffusealpha,0;rotationy,180);
		SongChosenMessageCommand=cmd(diffusealpha,0);
		NextSongMessageCommand=cmd(horizalign,right;diffusealpha,0.9;stoptweening;zoomy,0.5;zoomx,0.5;linear,0.2;zoomx,0.3;diffusealpha,0);
		TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,0);
		SongUnchosenMessageCommand=cmd(diffusealpha,0);
			ChangeStepsMessageCommand=function(self, params)
			if  params.Direction == 1 then
			self:stoptweening();
			self:horizalign(right);
			self:diffusealpha(0.7);
			self:zoomy(0.5);
			self:zoomx(0.5);
			self:linear(0.2);
			self:zoomx(0.2);
			self:diffusealpha(0);
			elseif params.Direction == -1 then
			end;
			end;
	}

	--[[t[#t+1] = LoadActor("bannermaskleftlight") .. {
		InitCommand=cmd(diffusealpha,0;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-14;zoomy,0.52;zoomx,0.64;blend,Blend.Add);
		PreviousSongMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,0.15;linear,0.3;diffusealpha,0);
	}

	t[#t+1] = LoadActor("bannermaskrightlight") .. {
		InitCommand=cmd(diffusealpha,0;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-14;zoomy,0.52;zoomx,0.64;blend,Blend.Add);
		NextSongMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,0.15;linear,0.3;diffusealpha,0);
	}]]--





	-- aparte
	--[[
	t[#t+1] = LoadActor("wheel_mask") .. {
		InitCommand=cmd(draworder,80;x,SCREEN_CENTER_X-1;y,SCREEN_CENTER_Y;zoomy,0.675;zoomx,0.65;diffusealpha,0.75;cropbottom,0.0575);

	};
	t[#t+1] = LoadActor("wheel_selection") .. {
		InitCommand=cmd(draworder,80;x,SCREEN_CENTER_X-1;y,SCREEN_CENTER_Y;zoomy,0.675;zoomx,0.65;diffusealpha,0;cropbottom,0.0575);
	SongChosenMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,1);
	TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	SongUnchosenMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	};
	]]

end

-- BANNER MASK PUMP
if false then

t[#t+1] = Def.ActorFrame{
	LoadActor("pump/bannermask") .. {
		InitCommand=cmd(draworder,5;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+123;zoomy,0.58;zoomx,0.58);
	};

	LoadActor("pump/A1") .. {
		InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X-115;y,SCREEN_CENTER_Y+125;draworder,2;diffusealpha,0);
		SongChosenMessageCommand=cmd(diffusealpha,0);
		PreviousSongMessageCommand=cmd(horizalign,right;diffusealpha,0.9;stoptweening;zoomy,0.5;zoomx,0.5;linear,0.2;zoomx,0.3;diffusealpha,0);
		TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,0);
		SongUnchosenMessageCommand=cmd(diffusealpha,0);
		ChangeStepsMessageCommand=function(self, params)
			if  params.Direction == 1 then
				--Nothing here???
			elseif params.Direction == -1 then
				self:stoptweening();
				self:horizalign(right);
				self:diffusealpha(0.7);
				self:zoomy(0.5);
				self:zoomx(0.5);
				self:linear(0.2);
				self:zoomx(0.2);
				self:diffusealpha(0);
			end;
		end;

	};

	LoadActor("pump/A2") .. {
		InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X-115;y,SCREEN_CENTER_Y+125;draworder,2;diffusealpha,0);
		SongChosenMessageCommand=cmd(diffusealpha,0);
		PreviousSongMessageCommand=cmd(horizalign,right;diffusealpha,0.9;stoptweening;zoomy,0.5;zoomx,0.5;linear,0.2;zoomx,0.3;diffusealpha,0);
		TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,0);
		SongUnchosenMessageCommand=cmd(diffusealpha,0);
		ChangeStepsMessageCommand=function(self, params)
			if  params.Direction == 1 then
			elseif params.Direction == -1 then
			self:stoptweening();
			self:horizalign(right);
			self:diffusealpha(0.7);
			self:zoomy(0.5);
			self:zoomx(0.5);
			self:linear(0.2);
			self:zoomx(0.2);
			self:diffusealpha(0);
			end;
			end;

	};


	LoadActor("pump/A1") .. {
		InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X+115;y,SCREEN_CENTER_Y+125;draworder,2;diffusealpha,0;rotationy,180);
		SongChosenMessageCommand=cmd(diffusealpha,0);
		NextSongMessageCommand=cmd(horizalign,right;diffusealpha,0.9;stoptweening;zoomy,0.5;zoomx,0.5;linear,0.2;zoomx,0.3;diffusealpha,0);
		TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,0);
		SongUnchosenMessageCommand=cmd(diffusealpha,0);
			ChangeStepsMessageCommand=function(self, params)
			if  params.Direction == 1 then
			self:stoptweening();
			self:horizalign(right);
			self:diffusealpha(0.7);
			self:zoomy(0.5);
			self:zoomx(0.5);
			self:linear(0.2);
			self:zoomx(0.2);
			self:diffusealpha(0);
			elseif params.Direction == -1 then
			end;
			end;
	};

	LoadActor("pump/A2") .. {
		InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X+115;y,SCREEN_CENTER_Y+125;draworder,2;diffusealpha,0;rotationy,180);
		SongChosenMessageCommand=cmd(diffusealpha,0);
		NextSongMessageCommand=cmd(horizalign,right;diffusealpha,0.9;stoptweening;zoomy,0.5;zoomx,0.5;linear,0.2;zoomx,0.3;diffusealpha,0);
		TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,0);
		SongUnchosenMessageCommand=cmd(diffusealpha,0);
			ChangeStepsMessageCommand=function(self, params)
			if  params.Direction == 1 then
			self:stoptweening();
			self:horizalign(right);
			self:diffusealpha(0.7);
			self:zoomy(0.5);
			self:zoomx(0.5);
			self:linear(0.2);
			self:zoomx(0.2);
			self:diffusealpha(0);
			elseif params.Direction == -1 then
			end;
			end;
	};

}
	--[[t[#t+1] = LoadActor("bannermaskleftlight") .. {
		InitCommand=cmd(diffusealpha,0;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-14;zoomy,0.52;zoomx,0.64;blend,Blend.Add);
		PreviousSongMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,0.15;linear,0.3;diffusealpha,0);
	}

	t[#t+1] = LoadActor("bannermaskrightlight") .. {
		InitCommand=cmd(diffusealpha,0;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-14;zoomy,0.52;zoomx,0.64;blend,Blend.Add);
		NextSongMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,0.15;linear,0.3;diffusealpha,0);
	}]]--





	-- aparte
	--[[
	t[#t+1] = LoadActor("wheel_mask") .. {
		InitCommand=cmd(draworder,80;x,SCREEN_CENTER_X-1;y,SCREEN_CENTER_Y;zoomy,0.675;zoomx,0.65;diffusealpha,0.75;cropbottom,0.0575);

	};
	t[#t+1] = LoadActor("wheel_selection") .. {
		InitCommand=cmd(draworder,80;x,SCREEN_CENTER_X-1;y,SCREEN_CENTER_Y;zoomy,0.675;zoomx,0.65;diffusealpha,0;cropbottom,0.0575);
	SongChosenMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,1);
	TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	SongUnchosenMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	};
	]]

end

if GAMESTATE:GetCurrentGame():GetName() == "pump" then
	if GAMESTATE:IsSideJoined(PLAYER_1) then
		t[#t+1] = LoadActor("pump/RadarsUnified", PLAYER_1) .. {
			InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
		};
	end
	if GAMESTATE:IsSideJoined(PLAYER_2) then
		t[#t+1] = LoadActor("pump/RadarsUnified", PLAYER_2) .. {
			InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X+50;y,SCREEN_CENTER_Y+97;);
		};
	end
end;

if GAMESTATE:GetCurrentGame():GetName() == "dance" then
	if GAMESTATE:IsSideJoined(PLAYER_1) then
		t[#t+1] = LoadActor("RadarsUnified", PLAYER_1) .. {
			InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
		};
	end
	if GAMESTATE:IsSideJoined(PLAYER_2) then
		t[#t+1] = LoadActor("RadarsUnified", PLAYER_2) .. {
			InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X+50;y,SCREEN_CENTER_Y+97;);
		};
	end
end;





--[[t[#t+1] = LoadActor("cursor_body") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+3;zoom,0.675);

};]]

--DIFFICULTY BAR

t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","DifficultyDisplay"))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,110);
		--[[SelectingGroupMessageCommand=cmd(visible,false);
		SelectingSongMessageCommand=cmd(visible,true);]]
	};
};


--READY BANNER

t[#t+1] = Def.ActorFrame{

	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_HEIGHT*.8);

	LoadActor("rdy_add")..{
		InitCommand=cmd(y,-20;diffusealpha,0;zoom,0.8;draworder,100;blend,Blend.Multiply;);
		SongChosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,1);
		TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
	};

	LoadActor("rdy_add")..{
		InitCommand=cmd(y,-20;zoom,0.8;diffusealpha,0;draworder,100;blend,Blend.Add;);
		SongChosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,1);
		TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
	};


	LoadActor("rdy_sub")..{
		InitCommand=cmd(y,17;zoom,0.75;diffusealpha,0;draworder,100;diffuse,0,0,0,0);
		SongChosenMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+17;diffusealpha,1);
		TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+37;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+37;diffusealpha,0);
	};




	LoadActor("rdy_logo")..{
		InitCommand=cmd(x,3;y,-42;zoom,0.4;draworder,100;thump;effectperiod,2;;diffuse,0,0,0,0;diffusetopedge,0.25,0.25,0.25,0);
		SongChosenMessageCommand=cmd(stoptweening;linear,0.2;;diffusealpha,1);
		TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;);
	};
	
	LoadActor(THEME:GetPathG("", "_press "..GAMESTATE:GetCurrentGame():GetName().. " 5x2"))..{
		Frames = Sprite.LinearFrames(10,.3);
		InitCommand=cmd(x,-110;y,-64;zoom,0.45;visible,false;draworder,100);
		SongChosenMessageCommand=cmd(setstate,0;visible,true);
		TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
		SongUnchosenMessageCommand=cmd(visible,false);
	};
	LoadActor(THEME:GetPathG("", "_press "..GAMESTATE:GetCurrentGame():GetName().. " 5x2"))..{
		Frames = Sprite.LinearFrames(10,.3);
		InitCommand=cmd(x,110;y,-64;zoom,0.45;visible,false;draworder,100);
		SongChosenMessageCommand=cmd(setstate,0;visible,true);
		TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
		SongUnchosenMessageCommand=cmd(visible,false);
	};

}

--TODO: Fix PlayerJoinedMessageCommand, put it inside the above actorframe (with better error handling)
if GAMESTATE:IsSideJoined(PLAYER_1) then
	t[#t+1] = LoadActor(THEME:GetPathG("","PlayerSteps"), PLAYER_1)..{
		InitCommand=cmd(draworder,100;xy,SCREEN_CENTER_X-135,SCREEN_HEIGHT*.77;visible,false);
		SongChosenMessageCommand=cmd(visible,true);
		TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
		SongUnchosenMessageCommand=cmd(visible,false);
		--OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
		--PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
		--CurrentStepsP1ChangedMessageCommand=cmd(stoptweening;diffusealpha,0;zoomx,0;decelerate,0.075;zoomx,1;diffusealpha,1);
	}
end;

if GAMESTATE:IsSideJoined(PLAYER_2) then
	t[#t+1] = LoadActor(THEME:GetPathG("","PlayerSteps"), PLAYER_2)..{
		InitCommand=cmd(draworder,100;xy,SCREEN_CENTER_X+80,SCREEN_HEIGHT*.77;visible,false);
		SongChosenMessageCommand=cmd(visible,true);
		TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
		SongUnchosenMessageCommand=cmd(visible,false);
		--OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
		--PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
		--CurrentStepsP2ChangedMessageCommand=cmd(stoptweening;zoomx,0;diffusealpha,0;decelerate,0.075;zoomx,1;diffusealpha,1);
	}
end;


t[#t+1] = Def.ActorFrame{
	--[[LoadFont("venacti/_venacti 26px bold diffuse")..{
			InitCommand=cmd(diffuse,0.6,0.6,0.6,1;diffusetopedge,1,1,1,1;draworder,100;horizalign,center;x,SCREEN_CENTER_X-90;y,SCREEN_CENTER_Y-2;zoomx,0.35;zoomy,0.35;shadowlengthy,1;shadowlengthx,0.8);
			Text="BPM"
	};
	StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay")..{
		InitCommand=cmd(draworder,100);
	}]]

	--[[LoadFont("BPMDisplay bpm")..{
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then

		InitCommand=cmd(xy,SCREEN_CENTER_X-105,SCREEN_CENTER_Y+22);
		OnCommand=cmd(diffusealpha,0;maxwidth,100;shadowlength,1;zoom,0.6;draworder,100;finishtweening;horizalign,left;strokecolor,Color("Outline");sleep,0.3;linear,0.8;diffusealpha,1);
		OffCommand=cmd(bouncebegin,0.15;zoomx,0;);
	};]]

};


t[#t+1] = StandardDecorationFromFileOptional("SortOrder","SortOrderText") .. {
	BeginCommand=cmd(draworder,106;playcommand,"Set");
	SortOrderChangedMessageCommand=cmd(playcommand,"Set";);
	SetCommand=function(self)
		local s = SortOrderToLocalizedString( GAMESTATE:GetSortOrder() );
		self:settext( s );
		--self:playcommand("Sort");
	end;
};


--[[
t[#t+1] = StandardDecorationFromFileOptional("SongTime","SongTime") .. {
	InitCommand=cmd(draworder,100;settext,0);
	SetCommand=function(self)
		local curSelection;
		local length = 0.0;
		if GAMESTATE:IsCourseMode() then
			curSelection = GAMESTATE:GetCurrentCourse();
			self:playcommand("Reset");
			if curSelection then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				if trail then
					length = TrailUtil.GetTotalSeconds(trail);
				else
					length = 0.0;
				end;
			else
				length = 0.0;
			end;
		else
			curSelection = GAMESTATE:GetCurrentSong();
			self:playcommand("Reset");
			if curSelection then
				length = curSelection:MusicLengthSeconds();
				if curSelection:IsLong() then
					self:playcommand("Long");
				elseif curSelection:IsMarathon() then
					self:playcommand("Marathon");
				else
					self:playcommand("Reset");
				end
			else
				length = 0.0;
				self:playcommand("Reset");
			end;
		end;
		self:settext( SecondsToMSS(length) );
	end;
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
}
]]
--t[#t+1] = StandardDecorationFromFileOptional("SongTime","SongTime")..{};

--[[t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(diffuse,0.6,0.6,0.6,1;diffusetopedge,1,1,1,1;draworder,100;horizalign,right;x,SCREEN_CENTER_X+98;y,SCREEN_CENTER_Y-2;zoomx,0.35;zoomy,0.35;shadowlengthy,1;shadowlengthx,0.8);
		Text="TIME"
}


t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(diffuse,0.6,0.6,0.6,1;diffusetopedge,1,1,1,1;draworder,100;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-2;zoomx,0.35;zoomy,0.35;shadowlengthy,1;shadowlengthx,0.8);
		Text="ARTIST"
}]]


t[#t+1] = LoadFont("venacti/_venacti 13px bold diffuse")..{
	InitCommand=cmd(maxwidth,450;diffusetopedge,0.5,0.88,0.95,1;diffusebottomedge,1,1,1,1;uppercase,true;draworder,110;horizalign,center;x,SCREEN_WIDTH*.1;y,23;zoomx,0.385;zoomy,0.38;shadowlength,1);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
			--Assume that the user doesn't want those numbers at the beginning that StepF2 has
			self:settext(string.gsub(song:GetGroupName(),"^%d%d? ?%- ?", ""))
			self:diffusealpha(1);
		else
			self:settext("---")
			self:diffusealpha(0.3);
		end

	end;
}

t[#t+1] = LoadFont("venacti/_venacti 13px bold diffuse")..{
	Text="GENRE";
	InitCommand=cmd(xy,SCREEN_WIDTH*.9,10;uppercase,true;draworder,101;strokecolor,Color("Outline");zoom,0.45;shadowlength,1);

};

t[#t+1] = LoadFont("venacti/_venacti 13px bold diffuse")..{
	InitCommand=cmd(diffusetopedge,0.5,0.88,0.95,1;diffusebottomedge,1,1,1,1;uppercase,true;draworder,110;horizalign,center;x,SCREEN_WIDTH*.9;y,23;zoomx,0.385;zoomy,0.38;shadowlength,1);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		if song and song:GetGenre() ~= "" then
			self:settext(song:GetGenre());
		else
			self:settext("NONE");
		end;
	end;
}




--[[t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(draworder,110;maxwidth,720;diffusebottomedge,0.7,0.7,0.7,1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+137;zoomx,0.375;zoomy,0.38;shadowlength,0.8);
	SongChosenMessageCommand=cmd(hurrytweening,0.5);
	CurrentSongChangedMessageCommand=function(self)
		self:stoptweening();
		local song = GAMESTATE:GetCurrentSong()
		if song then
			self:settext(song:GetDisplayArtist());
			self:diffusealpha(0);
			self:sleep(0.35);
			self:linear(0.2);
			self:diffusealpha(1);
		else
			self:diffusealpha(0);
		end
	end;
}]]

--enabled again because noteskins aren't working
--requires further testing


--[[t[#t+1] = LoadActor(THEME:GetPathS("","EX_Confirm"))..{

	CodeMessageCommand=function(self,params)
		if params.Name == 'GameLevelUp' then


			if GetUserPref("UserPrefGameLevel") == "Pro" then
				self:play()
				SetUserPref("UserPrefGameLevel","Ultimate");
				WritePrefToFile("UserPrefGameLevel","Ultimate");
				SCREENMAN:SystemMessage("Game Level changed to ULTIMATE");
			end


			if GetUserPref("UserPrefGameLevel") == "Standard" then
				self:play()
				SetUserPref("UserPrefGameLevel","Pro");
				WritePrefToFile("UserPrefGameLevel","Pro");
				SCREENMAN:SystemMessage("Game Level changed to PRO");
			end

			if GetUserPref("UserPrefGameLevel") == "Beginner" then
				self:play()
				SetUserPref("UserPrefGameLevel","Standard");
				WritePrefToFile("UserPrefGameLevel","Standard");
				SCREENMAN:SystemMessage("Game Level changed to STANDARD");
			end

		end;


	end
};

t[#t+1] = LoadActor(THEME:GetPathS("","EX_Confirm"))..{
	CodeMessageCommand=function(self,params)
		--SCREENMAN:SystemMessage("sdfsdf");
		if params.Name == 'GameLevelDown' then


			if GetUserPref("UserPrefGameLevel") == "Standard" then
				self:play()
				SetUserPref("UserPrefGameLevel","Beginner");
				WritePrefToFile("UserPrefGameLevel","Beginner");
				SCREENMAN:SystemMessage("Game Level changed to BEGINNER");
			end


			if GetUserPref("UserPrefGameLevel") == "Pro" then
				self:play()
				SetUserPref("UserPrefGameLevel","Standard");
				WritePrefToFile("UserPrefGameLevel","Standard");
				SCREENMAN:SystemMessage("Game Level changed to STANDARD");
			end

			if GetUserPref("UserPrefGameLevel") == "Ultimate" then
				self:play()
				SetUserPref("UserPrefGameLevel","Pro");
				WritePrefToFile("UserPrefGameLevel","Pro");
				SCREENMAN:SystemMessage("Game Level changed to PRO");
			end

		end;

	end
};]]






--[[t[#t+1] = LoadActor("light_mid") .. {
	InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X;effectclock,"bgm";vertalign,top;zoom,0.675;blend,Blend.Add;diffuseshift;effectcolor1,color("#FFFFFF55");effectcolor2,color("#FFFFFFCC");visible,GetUserPrefB("UserPrefLite"));

}]]

--I love having seizures! /s
--Change it to true if you want the flashing lights back.
t[#t+1] = LoadActor(THEME:GetPathG("","header"), false)..{
	InitCommand=cmd(draworder,100);
}


--TITLE
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,100;rotationx,30;diffuse,0.08,0.08,0.08,1;diffusetopedge,0.2,0.2,0.2,1;shadowlengthy,-1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_TOP+37;zoomx,0.7;zoomy,0.725;);
		Text="SELECT MUSIC";
		SongChosenMessageCommand=cmd(settext,"SELECT DIFFICULTY");
		TwoPartConfirmCanceledMessageCommand=cmd(settext,"SELECT MUSIC");
		SongUnchosenMessageCommand=cmd(settext,"SELECT MUSIC");
}

--TIMER

t[#t+1] = LoadActor("B0") .. {
	InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,-0.55);

};

t[#t+1] = LoadActor("B1") .. {
	InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

};

t[#t+1] = LoadActor("B2") .. {
	InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

};

t[#t+1] = LoadFont("venacti/_venacti 13px bold diffuse")..{
		InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,-0.8;shadowlength,-0.8;horizalign,left;x,SCREEN_CENTER_X+185 ;y,SCREEN_TOP+16;zoom,0.40);
		Text="TIMER"
}

--STAGE

t[#t+1] = LoadActor("B0") .. {
	InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X-190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,0.55);

};

t[#t+1] = LoadActor("B1") .. {
	InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X-160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,0.6);

};

t[#t+1] = LoadActor("B2") .. {
	InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X-160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,0.6);

};

t[#t+1] = LoadFont("venacti/_venacti 13px bold diffuse")..{
		InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,0.8;shadowlengthy,-0.8;horizalign,right;x,SCREEN_CENTER_X-185;y,SCREEN_TOP+16;zoom,0.40);
		Text="STAGE"
}

t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
	InitCommand=cmd(draworder,102;diffuse,0.9,0.9,0.9,0.9;uppercase,true;horizalign,center;x,SCREEN_CENTER_X-160;maxwidth,45;zoomx,0.58;zoomy,0.58;y,SCREEN_TOP+25;shadowlengthx,1;shadowlengthy,-1);
	OnCommand=function(self)
		local stageNum=GAMESTATE:GetCurrentStageIndex()+1
		self:settextf("%02d",stageNum);
	end;
}



--Wheel left/right shadow
t[#t+1] = Def.Quad {
	InitCommand=cmd(horizalign,left;vertalign,bottom;faderight,1;draworder,10;zoomto,120,SCREEN_HEIGHT;xy,SCREEN_LEFT,SCREEN_HEIGHT;diffuse,0,0,0,1);
}
t[#t+1] = Def.Quad {
	InitCommand=cmd(horizalign,right;vertalign,bottom;fadeleft,1;draworder,10;zoomto,120,SCREEN_HEIGHT;xy,SCREEN_RIGHT,SCREEN_HEIGHT;diffuse,0,0,0,1);
}

--Command Window has been moved to ScreenSelectMusic overlay because it has to take over input handling.



--next/prev indicator

--I like it in dance, but people will probably complain...
if GAMESTATE:GetCurrentGame():GetName() == "pump" then
	t[#t+1] = LoadActor(THEME:GetPathG("", "downTap/arrow_left"))..{
			InitCommand=cmd(draworder,131;horizalign,left;vertalign,bottom;xy,SCREEN_LEFT,SCREEN_BOTTOM;zoom,.675;);
			PreviousSongMessageCommand=cmd(stoptweening;glow,color("1,1,1,.8");xy,SCREEN_LEFT-5,SCREEN_BOTTOM+5;sleep,.12;decelerate,.2;glow,color("0,0,0,0");xy,SCREEN_LEFT,SCREEN_BOTTOM;);
		};
	t[#t+1] = LoadActor(THEME:GetPathG("", "downTap/arrow_right"))..{
			InitCommand=cmd(draworder,131;horizalign,right;vertalign,bottom;xy,SCREEN_RIGHT,SCREEN_BOTTOM;zoom,.675;);
			NextSongMessageCommand=cmd(stoptweening;glow,color("1,1,1,.8");xy,SCREEN_RIGHT+5,SCREEN_BOTTOM+5;sleep,.12;decelerate,.2;glow,color("0,0,0,0");xy,SCREEN_RIGHT,SCREEN_BOTTOM;);
		};
end;
--t[#t+1] = LoadActor("_arrows")..{InitCommand=cmd(draworder,131);};


--I don't know what this is for?
--[[
t[#t+1] = Def.Quad {
		InitCommand=cmd(draworder,900;Center;zoomto,SCREEN_WIDTH+1,SCREEN_HEIGHT);
		OnCommand=cmd(diffuse,color("0,0,0,0"));
		OffCommand=cmd(linear,0.2;diffusealpha,1);
};]]


--[[t[#t+1] = LoadActor("songback") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X-1;y,SCREEN_CENTER_Y;zoomy,0.675;zoomx,0.65);

};]]

-- ================
-- Modifier display
-- ================

for pn in ivalues(PlayerNumber) do
	t[#t+1] = LoadActor("mods display", pn);
end;

return t;
