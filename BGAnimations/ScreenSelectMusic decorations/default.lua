local t = Def.ActorFrame{}




--bot quad
--[[t[#t+1] = Def.Quad {
	InitCommand=cmd(diffuse,0,0,0,0.5;vertalign,bottom;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;setsize,SCREEN_WIDTH,188;);
}]]

t[#t+1] = LoadActor(THEME:GetPathG("","footer"))..{
	InitCommand=cmd(draworder,130);
};

--[[t[#t+1] = LoadActor("listbg") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X-1;y,SCREEN_CENTER_Y;zoomy,0.675;zoomx,0.65);

};]]



--for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
--[[for pn in ivalues(PlayerNumber) do
	t[#t+1] = Def.ActorFrame{
		LoadActor(THEME:GetPathG("ScreenSelectMusic", "PaneDisplay"), ToEnumShortString(pn))..{
			InitCommand=cmd(xy,100,150);
		};
	};
end]]


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
--TODO: Add a more descriptive comment.
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = LoadActor("PlayerScore", pn);
end;
--[[t[#t+1] = Def.Quad {
	InitCommand=cmd(draworder,2;visible,true;diffuse,color("1,0,0.2,0");x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-100;scaletoclipped,262,130;diffusealpha,0.4;fadetop,0.4;fadebottom,0.4);
]]--

-- BANNER CENTRAL -- BACKGROUND


t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-100);
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
	Def.Quad {
		InitCommand=cmd(diffuse,color("0,0,0,1");scaletoclipped,260+1,160;diffusealpha,0.7);
	};
	
	Def.Quad {
		InitCommand=cmd(visible,true;diffuse,color("0,0,0,1");setsize,290,160;diffusealpha,1);
	};
	
	--SONG BACKGROUND
	Def.Sprite {
		CurrentSongChangedMessageCommand=cmd(finishtweening;queuecommand,"ModifySongBackground");
		ModifySongBackgroundCommand=function(self)
			self:stoptweening();
			if GAMESTATE:GetCurrentSong() then
				self:LoadFromSongBackground(GAMESTATE:GetCurrentSong());
				--self:scaletoclipped(290,160);
				--self:cropto(200,200);
				--self:customtexturerect(100,100,100,100);
				--self:zoomto(290,160);
				--self:setsize(290,160);
				--self:SetWidth(290);
				self:scaletocover(-145,-80,145,80);
				local tex = self:GetTexture();
				if round(tex:GetImageWidth()/tex:GetImageHeight(), 1) == 1.3 then
					self:croptop(.13);
					self:cropbottom(.13);
				else
					self:croptop(0);
					self:cropbottom(0);
				end;
				--SCREENMAN:SystemMessage(tostring(tex:GetImageWidth()).." / "..tostring(tex:GetImageHeight()).." = "..tostring(tex:GetImageWidth()/tex:GetImageHeight()));

				self:diffusealpha(0);
				self:linear(0.5);
				self:diffusealpha(1);
			end;
		end;
		CurrentCourseChangedMessageCommand=function(self)
			if GAMESTATE:GetCurrentCourse() and SCREENMAN:GetTopScreen():GetName() == "ScreenSelectCourse" then
				self:stoptweening();
				local bg = GAMESTATE:GetCurrentCourse():GetBackgroundPath();
					if bg then
					self:Load(bg);
					self:scaletocover(-145,-80,145,80);
					local tex = self:GetTexture();
					if round(tex:GetImageWidth()/tex:GetImageHeight(), 1) == 1.3 then
						self:croptop(.13);
						self:cropbottom(.13);
					else
						self:croptop(0);
						self:cropbottom(0);
					end;
					self:diffusealpha(0);
					self:linear(0.5);
					self:diffusealpha(1);
				end;
			end;
		end;
	};
	
	--SONG VIDEO
	Def.Sprite {
		CurrentSongChangedMessageCommand=cmd(finishtweening;diffusealpha,0;queuecommand,"ModifySongBackground");

		ModifySongBackgroundCommand=function(self)
			if GAMESTATE:GetCurrentSong() ~= nil then
				--self:linear(0);
				if GAMESTATE:GetCurrentSong():HasPreviewVid() then
					self:sleep(1);
					self:queuecommand("LoadSongBG"); --If you use playcommand, the sleep() will be ignored!
					self:linear(1);
					self:diffusealpha(1);
				end;
			end;
		end;
		
		--It's in a separate command because that's the only way to delay Load();
		LoadSongBGCommand=function(self)
			self:Load( GAMESTATE:GetCurrentSong():GetPreviewVidPath() );
			self:scaletoclipped(290,160);
		end;
	};
	
	--SONG TITLE SHADOW
	Def.Quad{
		InitCommand=cmd(setsize,284,35;vertalign,bottom;diffuse,color("0,0,0,.8");addy,80;fadetop,.2);
	};
	
	--SONG TITLE
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(--[[addx,-50;]]addy,58;zoom,.5;maxwidth,530;faderight,1;fadeleft,1;diffusealpha,0);
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
		CurrentCourseChangedMessageCommand=function(self)
			if GAMESTATE:GetCurrentCourse() and SCREENMAN:GetTopScreen():GetName() == "ScreenSelectCourse" then
				local course = GAMESTATE:GetCurrentCourse();
				if course then
					self:settext(course:GetDisplayFullTitle());
				else
					self:settext("");
				end;
			end;
		end;
	};
	
	--SONG ARTIST
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(maxwidth,530;horizalign,center;--[[addx,-50;]]addy,71;zoomx,0.385;zoomy,0.38;shadowlength,1);
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
	
	--BPM DISPLAY
	--[[LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(addx,-50;addy,58;zoom,.5;maxwidth,530;);
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				self:settext(song:GetDisplayFullTitle());
			else
				self:settext("");
			end;
		end;
		CurrentCourseChangedMessageCommand=function(self)
			if GAMESTATE:GetCurrentCourse() and SCREENMAN:GetTopScreen():GetName() == "ScreenSelectCourse" then
				local course = GAMESTATE:GetCurrentCourse();
				if course then
					self:settext(course:GetDisplayFullTitle());
				else
					self:settext("");
				end;
			end;
		end;
	};]]
	
	--LONG SONG WARNING
	Def.Quad{
		InitCommand=cmd(setsize,284,28;vertalign,top;fadebottom,.2;addy,-80;);
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
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(setsize,284,30;vertalign,top;addy,-75;zoom,.5;shadowlength,1;shadowcolor,color("#000000BB"));
		--Text="FULL SONG: This song requires 2 stages.";
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			if song and song:IsLong() then
				self:visible(true)
				self:settext("FULL SONG: This song takes 2 stages.");
			elseif song and song:IsMarathon() then
				self:visible(true)
				self:settext("MARATHON: This song takes 3 stages.");
			else
				self:visible(false)
			end
		end;
	};
	
	
	LoadActor("songback") .. {
		InitCommand=cmd(draworder,6;addy,10;zoomy,0.675;zoomx,0.65);

	};
};


-- LONG SONG (OLD)
--[[t[#t+1] = LoadActor("long_normal") .. {
	InitCommand=cmd(draworder,25;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-3;zoom,0.575);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	--PlayerJoinedMessageCommand=cmd(playcommand,"Init");
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsLong());
		else
		self:visible(false)
		end
	end;

};



t[#t+1] = LoadActor("long_add") .. {
	InitCommand=cmd(draworder,25;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-3;zoom,0.575;blend,Blend.Add);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	--PlayerJoinedMessageCommand=cmd(playcommand,"Init");
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFFD0");effectcolor2,color("#FFFFFF00"));
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsLong());
		else
		self:visible(false)
		end
	end;

};

t[#t+1] = LoadActor("marathon_normal") .. {
	InitCommand=cmd(draworder,25;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-3;zoom,0.575);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	--PlayerJoinedMessageCommand=cmd(playcommand,"Init");
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsMarathon());
		else
		self:visible(false)
		end
	end;

};

t[#t+1] = LoadActor("marathon_add") .. {
	InitCommand=cmd(draworder,25;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-3;zoom,0.575;blend,Blend.Add);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	--PlayerJoinedMessageCommand=cmd(playcommand,"Init");
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFFD0");effectcolor2,color("#FFFFFF00"));
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsMarathon());
		else
		self:visible(false)
		end
	end;

};]]


t[#t+1] = LoadActor("jacket_light") .. {
	InitCommand=cmd(draworder,100;xy,SCREEN_CENTER_X,SCREEN_CENTER_Y+121;zoomx,1.14;zoomy,.81;effectclock,"bgm";blend,Blend.Add);

	CurrentSongChangedMessageCommand=function(self)
		if GAMESTATE:GetPlayMode() ~= "PlayMode_Nonstop" then
			--local JacketOrBanner;
			local song = GAMESTATE:GetCurrentSong();
			self:finishtweening();
			self:linear(.5);
			if song then
				if song:HasJacket() then
					self:zoomx(.81);
					self:diffusealpha(1);
				elseif song:HasBanner() then
					self:zoomx(1.14);
					self:diffusealpha(1);
				end;
				--SCREENMAN:SystemMessage(
			else
				self:diffusealpha(0);
			end;
			self:playcommand("CheckSteps");
		end;
	end;
	
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

}

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


t[#t+1] = LoadActor("leftpress") .. {
	InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X;vertalign,top;diffusealpha,0;zoom,0.675;blend,Blend.Add);
	PreviousSongMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,0.15;linear,0.3;diffusealpha,0);
}

t[#t+1] = LoadActor("rightpress") .. {
	InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X;vertalign,top;diffusealpha,0;zoom,0.675;blend,Blend.Add);
	NextSongMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,0.15;linear,0.3;diffusealpha,0);
}
--[[


t[#t+1] = LoadActor("long_normal") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+3;zoom,0.675);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsLong());
		else
		self:visible(false)
		end
	end;

};

t[#t+1] = LoadActor("long_add") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+3;zoom,0.675;blend,Blend.Add);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFFD0");effectcolor2,color("#FFFFFF00"));
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsLong());
		else
		self:visible(false)
		end
	end;

};


t[#t+1] = LoadActor("marathon_normal") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+3;zoom,0.675);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsMarathon());
		else
		self:visible(false)
		end
	end;

};

t[#t+1] = LoadActor("marathon_add") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+3;zoom,0.675;blend,Blend.Add);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFFD0");effectcolor2,color("#FFFFFF00"));
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsMarathon());
		else
		self:visible(false)
		end
	end;

};



]]--






--DIFFICULTY BAR

t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","DifficultyDisplay"))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,165);
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


	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		InitCommand=cmd(y,-20;zoom,0.35;zoomy,0.325;shadowlengthy,0.8;draworder,100;diffuse,0.65,0.65,0.65,0;diffusetopedge,0.8,0.8,0.8,0);
		SongChosenMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y-18;diffusealpha,1);
		TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+16;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+18;diffusealpha,0);
		Text=" - PRESS CENTER STEP TO START - "
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


t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(maxwidth,450;diffusetopedge,0.5,0.88,0.95,1;diffusebottomedge,1,1,1,1;uppercase,true;draworder,110;horizalign,center;x,SCREEN_WIDTH*.1;y,23;zoomx,0.385;zoomy,0.38;shadowlength,1);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
			--Assume that the user doesn't want those numbers at the beginning that StepF2 has
			--TODO: Is there a faster way to do this?
			num = split("-",song:GetGroupName())
			if tonumber(num[1]) then
				self:settext(num[2])
			else
				self:settext(song:GetGroupName())
			end;
			self:diffusealpha(1);
		else
			self:settext("---")
			self:diffusealpha(0.3);
		end

	end;
}

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	Text="GENRE";
	InitCommand=cmd(xy,SCREEN_WIDTH*.9,10;uppercase,true;draworder,101;strokecolor,Color("Outline");zoom,0.45;shadowlength,1);

};

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
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

--[[
Use an ActorFrame, there should be no reason to copy and paste
the same code twice and have all this extra logic. And there should be no need
to position the graphic inside the Actor!!
In fact, why was the join checking code inside the actor in the first place?
You could have just put it outside the actor and added it here!!
Even if you didn't know how to use args in LoadActor, you still
would know how to do this!!
]]
--[[t[#t+1] = LoadActor("JoinOverlay")..{
	InitCommand=cmd(draworder,110;visible,THEME:GetMetric("GameState", "AllowLateJoin"));
}]]
t[#t+1] = Def.ActorFrame{
	LoadActor(THEME:GetPathG("","JoinOverlay"))..{
		InitCommand=cmd(xy,SCREEN_WIDTH*.15,SCREEN_CENTER_Y-50;zoom,.75;visible,THEME:GetMetric("GameState", "AllowLateJoin");playcommand,"RefreshPlayer");
		PlayerJoinedMessageCommand=cmd(playcommand,"RefreshPlayer");
		CoinModeChangedMessageCommand=cmd(playcommand,"RefreshPlayer");
		CoinInsertedMessageCommand=cmd(playcommand,"RefreshPlayer");
		RefreshPlayerCommand=function(self)
			self:visible(not GAMESTATE:IsHumanPlayer(PLAYER_1))
		end;
	};
	LoadActor(THEME:GetPathG("","JoinOverlay"))..{
		InitCommand=cmd(xy,SCREEN_WIDTH*.85,SCREEN_CENTER_Y-50;zoom,.75;visible,THEME:GetMetric("GameState", "AllowLateJoin");playcommand,"RefreshPlayer");
		PlayerJoinedMessageCommand=cmd(playcommand,"RefreshPlayer");
		CoinModeChangedMessageCommand=cmd(playcommand,"RefreshPlayer");
		CoinInsertedMessageCommand=cmd(playcommand,"RefreshPlayer");
		RefreshPlayerCommand=function(self)
			self:visible(not GAMESTATE:IsHumanPlayer(PLAYER_2))
		end;
	};
};

--enabled again because noteskins aren't working
--requires further testing


t[#t+1] = LoadActor(THEME:GetPathS("","EX_Confirm"))..{

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
};



t[#t+1] = LoadActor(THEME:GetPathS("","EX_Select"))..{
	CodeMessageCommand = function(self, params)
		if params.Name == 'OpenOpList' then
			--SCREENMAN:SystemMessage("OptionsList opened")
			SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
		end
	end;
};


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

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
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

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,0.8;shadowlengthy,-0.8;horizalign,right;x,SCREEN_CENTER_X-185;y,SCREEN_TOP+16;zoom,0.40);
		Text="STAGE"
}

t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
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



--Wheel left/right shadow
t[#t+1] = Def.Quad {
	InitCommand=cmd(horizalign,right;faderight,1;draworder,10;zoomto,120,SCREEN_HEIGHT;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X-320;diffuse,0,0,0,1);
}
t[#t+1] = Def.Quad {
	InitCommand=cmd(horizalign,left;fadeleft,1;draworder,10;zoomto,120,SCREEN_HEIGHT;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X+320;diffuse,0,0,0,1);
}


for pn in ivalues(PlayerNumber) do


t[#t+1] = LoadActor("oplist") ..{
InitCommand=cmd(draworder,100;diffuse,color("1,0.95,0.9,0");zoom,0.675;Center;diffusealpha,0;blend,Blend.Add);

		OptionsListOpenedMessageCommand=function(self,params)
			if params.Player == pn then
				if pn == PLAYER_1 then
					self:zoomx(0.675);

				elseif pn == PLAYER_2 then
					self:zoomx(-0.675);

				end

				self:playcommand("Open");
			end
		end;


		OpenCommand=cmd(stoptweening;decelerate,0.3;diffusealpha,1;);
		OptionsListClosedMessageCommand=function(self,params)
			if params.Player == pn then

				self:stoptweening();
				self:accelerate(0.3);
				self:diffusealpha(0);

			end
		end;

}




t[#t+1] = LoadActor("oplist") ..{
InitCommand=cmd(draworder,100;diffuse,color("0.3,0.3,0.3,0");zoom,0.675;Center;diffusealpha,0;);

		OptionsListOpenedMessageCommand=function(self,params)
			if params.Player == pn then
				if pn == PLAYER_1 then
					self:zoomx(0.775);

				elseif pn == PLAYER_2 then
					self:zoomx(-0.775);

				end

				self:playcommand("Open");
			end
		end;


		OpenCommand=cmd(stoptweening;decelerate,0.3;diffusealpha,0.95;);
		OptionsListClosedMessageCommand=function(self,params)
			if params.Player == pn then

				self:stoptweening();
				self:accelerate(0.3);
				self:diffusealpha(0);

			end
		end;

}

end





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

t[#t+1] = LoadActor(THEME:GetPathS("","EX_Move"))..{
	PreviousGroupMessageCommand=cmd(play);
	NextGroupMessageCommand=cmd(play);
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

t[#t+1] = LoadActor(THEME:GetPathS("","SSM_Select"))..{
	SongChosenMessageCommand=cmd(play);
	StepsChosenMessageCommand=cmd(play);
}
t[#t+1] = LoadActor(THEME:GetPathS("","SSM_Confirm"))..{
	OffCommand=cmd(play);
}


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
local function increasePlayerSpeed(pn, amount)
	--SCREENMAN:SystemMessage(playerState);
	local playerState = GAMESTATE:GetPlayerState(pn);
	--This returns an instance of playerOptions, you need to set it back to the original
	local playerOptions = playerState:GetPlayerOptions("ModsLevel_Preferred")
	--SCREENMAN:SystemMessage(PlayerState:GetPlayerOptionsString("ModsLevel_Current"));
	--One of these will be valid, depending on the player's currently set speed mod.
	local cmod = playerOptions:CMod();
	local mmod = playerOptions:MMod();
	local xmod = playerOptions:XMod();
	if cmod then
		if amount*100+playerOptions:CMod() < 100 then
			playerOptions:CMod(800);
		elseif amount*100+playerOptions:CMod() > 1000 then
			playerOptions:CMod(100);
		else
			playerOptions:CMod(playerOptions:CMod()+amount*100);
		end;
	elseif mmod then
		if amount*100+playerOptions:MMod() < 100 then
			playerOptions:MMod(800);
		elseif amount*100+playerOptions:MMod() > 1000 then
			playerOptions:MMod(100);
		else
			playerOptions:MMod(playerOptions:MMod()+amount*100);
		end;
	elseif xmod then
		--SCREENMAN:SystemMessage(playerOptions:XMod())
		if amount+playerOptions:XMod() < .5 then
			playerOptions:XMod(8);
		elseif amount+playerOptions:XMod() > 8 then
			playerOptions:XMod(.5);
		else
			playerOptions:XMod(playerOptions:XMod()+amount,true);
		end;
		--SCREENMAN:SystemMessage("Set speed to "..playerOptions:XMod().." ("..tostring(xmod).."+"..tostring(amount)..")");
	else
		SCREENMAN:SystemMessage("ERROR: Can't determine "..pn.."'s current speed mod!");
	end;
	GAMESTATE:GetPlayerState(pn):SetPlayerOptions('ModsLevel_Preferred', playerState:GetPlayerOptionsString("ModsLevel_Preferred"));
	--SCREENMAN:SystemMessage(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Current").." "..playerState:GetCurrentPlayerOptions():XMod());
end

local step = 35;
for pn in ivalues(PlayerNumber) do

	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:y(60);
			self:draworder(11);
			if pn == PLAYER_1 then
				self:x(SCREEN_LEFT+27);
			else
				self:x(SCREEN_RIGHT-27);
			end;
		end;
		
		--Speed modifier
		Def.ActorFrame{
			InitCommand=cmd(y,step*5);
			OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
			
			LoadActor(THEME:GetPathS("","EX_Confirm"))..{
				CodeMessageCommand = function(self, params)
					local sTable = {
						Quarter = .25,
						Half = .5,
						Full = 1
					};

					if params.PlayerNumber == pn then
						if params.Name == 'SpeedQuarterUp' then
							increasePlayerSpeed(pn,sTable['Quarter']);
							self:play();
						end;
						if params.Name == 'SpeedHalfUp' then
							increasePlayerSpeed(pn,sTable['Half']);
							self:play();
						end;
						if params.Name == 'SpeedUp' then
							increasePlayerSpeed(pn,sTable['Full']);
							self:play();
						end;
						
						--Increasing... By a negative number
						if params.Name == 'SpeedQuarterDown' then
							increasePlayerSpeed(pn,sTable['Quarter']*-1);
							self:play();
						end;
						if params.Name == 'SpeedHalfDown' then
							increasePlayerSpeed(pn,sTable['Half']*-1);
							self:play();
						end;
						if params.Name == 'SpeedDown' then
							increasePlayerSpeed(pn,sTable['Full']*-1);
							self:play();
						end;
					end
				end
			};--speedmods

			LoadActor("optionIcon")..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,0.75;);
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				InitCommand=cmd(draworder,100;zoom,.45;diffusebottomedge,0.7,0.7,0.7,1;maxwidth,70;shadowlength,0.8);
				OnCommand=cmd(playcommand,"UpdateText");
				--sleep,0.1;queuecommand,"On");
				OptionsListClosedMessageCommand=cmd(playcommand,"UpdateText");
				CodeMessageCommand=function(self)
					self:playcommand("UpdateText");
				end;
				UpdateTextCommand=function(self)
					local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
					local cmod = playerOptions:CMod();
					local mmod = playerOptions:MMod();
					local xmod = playerOptions:XMod();
					if cmod then
						self:settext("C"..cmod);
					elseif mmod then
						self:settext("AV"..mmod);
					elseif xmod then
						self:settext(xmod.."x");
					else
						self:settext("???");
					end;
				end;
			};
			LoadActor("optionFlash")..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffuse,1,1,1,0;visible,GAMESTATE:IsHumanPlayer(pn);sleep,0.1;blend,Blend.Add;queuecommand,"Init");
				CodeMessageCommand=function(self,params)
					if params.PlayerNumber == pn then
						if params.Name == 'SpeedUp' or
							params.Name == 'SpeedDown' or
							params.Name == 'SpeedHalfUp' or
							params.Name == 'SpeedHalfDown' or
							params.Name == 'SpeedQuarterUp' or
							params.Name == 'SpeedQuarterDown' then
							self:stoptweening();
							self:diffusealpha(1);
							self:sleep(0.1);
							self:linear(0.3)
							self:diffusealpha(0);
						end
					end
				end
			};
		};
		
		-- Noteskin modifier
		LoadActor("NoteSkin Display", pn)..{
			InitCommand=function(self)
				self:y(step*4);
				self:draworder(11);
			end;
		};
		
		-- Perspective modifiers: NX (Space), HW/Hallway, DS/Distant, IN/Incoming.
		Def.ActorFrame{
			InitCommand=function(self)
				self:y(step*2);
				self:draworder(11);
			end;
			OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);playcommand,"UpdateText");
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
			OptionsListClosedMessageCommand=cmd(playcommand,"UpdateText");
			UpdateTextCommand=function(self)
				local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
				local text = self:GetChild("Text");
				--local anim = self:GetChild("Animation");
				if playerOptions:Space() then
					self:visible(true);
					--anim:playcommand("Play");
					text:settext("NX");
				elseif playerOptions:Hallway() then
					self:visible(true);
					--anim:queuecommand("Play");
					text:settext("HW");
				elseif playerOptions:Distant() then
					self:visible(true);
					--anim:queuecommand("Play");
					text:settext("DS");
				elseif playerOptions:Incoming() then
					self:visible(true);
					--anim:queuecommand("Play");
					text:settext("IN");
				else
					self:visible(false);
				end;
			end;
			
			LoadActor("optionIcon")..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,0.75;);
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				Name="Text";
				InitCommand=cmd(draworder,100;zoom,.45;diffusebottomedge,0.7,0.7,0.7,1;maxwidth,70;shadowlength,0.8);
			};
			--[[LoadActor("optionFlash")..{
				Name="Animation";
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffuse,1,1,1,0;sleep,0.1;blend,Blend.Add;);
				PlayCommand=cmd(stoptweening;diffusealpha,1;sleep,0.1;linear,0.3;diffusealpha,0;);
			};]]
		};
		
		-- Acceleration modifiers: AC (Boost), DC (Brake), EW (Expand), WV/Wave, BM/Boomerang
		Def.ActorFrame{
			InitCommand=function(self)
				self:y(step*3);
				self:draworder(11);
			end;
			OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);playcommand,"UpdateText");
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
			OptionsListClosedMessageCommand=cmd(playcommand,"UpdateText");
			UpdateTextCommand=function(self)
				local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred");
				local text2 = self:GetChild("Text");
				if playerOptions:Boost() ~= 0 then
					self:visible(true);
					text2:settext("AC");
				elseif playerOptions:Brake() ~= 0 then
					self:visible(true);
					text2:settext("DC");
				elseif playerOptions:Expand() ~= 0 then
					self:visible(true);
					text2:settext("EW");
				elseif playerOptions:Wave() ~= 0 then
					self:visible(true);
					text2:settext("WV");
				elseif playerOptions:Boomerang() ~= 0 then
					self:visible(true);
					text2:settext("BM");
				else
					self:visible(false);
				end;
			end;
			
			LoadActor("optionIcon")..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,0.75;);
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				Name="Text";
				Text="???";
				InitCommand=cmd(draworder,100;zoom,.45;diffusebottomedge,0.7,0.7,0.7,1;maxwidth,70;shadowlength,0.8);
			};
		};
		
		-- Appearance modifiers: Hidden (V), Sudden (AP), Stealth (NS), Blink (FL)
		Def.ActorFrame{
			InitCommand=function(self)
				self:y(step*0);
				self:draworder(11);
			end;
			OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);playcommand,"UpdateText");
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
			OptionsListClosedMessageCommand=cmd(playcommand,"UpdateText");
			UpdateTextCommand=function(self)
				local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred");
				local text = self:GetChild("Text");
				if playerOptions:Hidden() ~= 0 then
					self:visible(true);
					text:settext("V");
					--SCREENMAN:SystemMessage(playerOptions:Hidden());
				elseif playerOptions:Sudden() ~= 0 then
					self:visible(true);
					text:settext("AP");
				elseif playerOptions:Stealth() ~= 0 then
					self:visible(true);
					text:settext("NS");
					--SCREENMAN:SystemMessage(playerOptions:Stealth());
				elseif playerOptions:Blink() ~= 0 then
					self:visible(true);
					text:settext("FL");
				else
					self:visible(false);
				end;
			end;
			
			LoadActor("optionIcon")..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,0.75;);
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				Name="Text";
				Text="???";
				InitCommand=cmd(draworder,100;zoom,.45;diffusebottomedge,0.7,0.7,0.7,1;maxwidth,70;shadowlength,0.8);
			};
		};
		-- Alternate modifiers: Mirror (M), Shuffle (RS), SuperShuffle (SRS), Backwards (BK), Left (L), Right, (R), Soft Shuffle (SFS)
		Def.ActorFrame{
			InitCommand=function(self)
				self:y(step*1);
				self:draworder(11);
			end;
			OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);playcommand,"UpdateText");
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
			OptionsListClosedMessageCommand=cmd(playcommand,"UpdateText");
			UpdateTextCommand=function(self)
				local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred");
				local text = self:GetChild("Text");
				if playerOptions:Mirror() then
					self:visible(true);
					text:settext("M");
				elseif playerOptions:Shuffle() then
					self:visible(true);
					text:settext("RS");
				elseif playerOptions:SuperShuffle() then
					self:visible(true);
					text:settext("SRS");
				elseif playerOptions:Backwards() then
					self:visible(true);
					text:settext("BK");
				elseif playerOptions:Left() then
					self:visible(true);
					text:settext("L");
				elseif playerOptions:Right() then
					self:visible(true);
					text:settext("R");
				elseif playerOptions:SoftShuffle() then
					self:visible(true);
					text:settext("SFS");
				else
					self:visible(false);
				end;
			end;
			
			LoadActor("optionIcon")..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,0.75;);
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				Name="Text";
				Text="???";
				InitCommand=cmd(draworder,100;zoom,.45;diffusebottomedge,0.7,0.7,0.7,1;maxwidth,70;shadowlength,0.8);
			};
		};
	};
end;

return t;
