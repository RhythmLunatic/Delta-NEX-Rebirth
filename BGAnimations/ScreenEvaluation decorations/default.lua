local t = Def.ActorFrame{
	InitCommand=cmd(hibernate,3);
}
local song = GAMESTATE:GetCurrentSong();

t[#t+1] = Def.ActorFrame {
  FOV=90;
  --InitCommand=cmd(Center);
--[[	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH/2,SCREEN_HEIGHT;x,-SCREEN_WIDTH/4);
		OnCommand=cmd(diffuse,color("#000000");diffuserightedge,color("#c71585"));
	};
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH/2,SCREEN_HEIGHT;x,SCREEN_CENTER_X-(SCREEN_WIDTH/4));
		OnCommand=cmd(diffuse,color("#000000");diffuseleftedge,color("#c71585"));
	};]]


	LoadActor("../_backgroundRedir", "musicSelect") .. {
		InitCommand=function(self)
			self:visible(not GAMESTATE:GetCurrentSong():HasBackground());
		end;
	};

	--Jacket BG
	--[[Def.Sprite{
		InitCommand=function(self)
			self:addy(-20);
			self:scaletoclipped(180,180);
			self:diffuse(color(".5,.5,.5,.7"));
			local path = GAMESTATE:GetCurrentSong():GetJacketPath();
			if path then self:Load(path);
			else
				self:diffusealpha(0);
			end;
		end;
		OnCommand=cmd(x,SCREEN_RIGHT-200;y,SCREEN_CENTER_Y;rotationx,-20;rotationy,15;rotationz,30;);
	};]]

	Def.Sprite{
		InitCommand=cmd(Load,GetSongBackground();visible,GAMESTATE:GetCurrentSong():HasBackground();scaletocover,0,0,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,color(".2,.2,.2,1"));
	};
};


--Seriously, why does this themer hate ActorFrames so much
--Rewriting this stuff to be easier to position drives me up the wall
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(xy,SCREEN_CENTER_X,80);


	--Top bg
	Def.Quad {
		InitCommand=cmd(diffuse,0,0,0,0.4;setsize,SCREEN_WIDTH,38;);

	};
	Def.Quad {
		InitCommand=cmd(diffuse,color("#C2C2C2");setsize,SCREEN_WIDTH,1;y,19);

	};

	Def.Quad {
		InitCommand=cmd(diffuse,color("#C2C2C2");setsize,SCREEN_WIDTH,1;y,-19);

	};

	--[[LoadActor(THEME:GetPathG("","SongBanner"))..{
		InitCommand=cmd(draworder,100;zoom,0.475;);
	};]]

	LoadActor(THEME:GetPathG("","PlayerSteps"), PLAYER_1)..{
		InitCommand=cmd(draworder,100;zoom,0.925;x,-215;y,-10;visible,GAMESTATE:IsSideJoined(PLAYER_1));
	};
	LoadActor(THEME:GetPathG("","PlayerSteps"), PLAYER_2)..{
		InitCommand=cmd(draworder,100;x,170;y,-10;zoom,0.925;visible,GAMESTATE:IsSideJoined(PLAYER_2));
	};

	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		InitCommand=cmd(addy,-8;maxwidth,500;zoomy,0.55;zoomx,0.58;diffuse,color("#FFFF66FF");diffusebottomedge,color("#DDAA44FF");shadowlength,0.8);
		Text=string.upper(song:GetDisplayMainTitle().." "..song:GetDisplaySubTitle())
	};


	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		InitCommand=cmd(addy,8;zoom,0.4;diffuse,color("#fffFFF");diffusebottomedge,color("#CCCCCC");shadowlength,0.8);
		Text=""..string.upper(song:GetGroupName());
	};

};

--[[t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(Center;addy,10);
	Def.Sprite{
		InitCommand=function(self)
			self:addy(-20);
			self:scaletoclipped(180,180);
			local path = GAMESTATE:GetCurrentSong():GetJacketPath();
			if path then self:Load(path);
			else
				self:diffusealpha(0);
			end;
		end;
	};

	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		InitCommand=cmd(addy,80;maxwidth,1020;zoomy,0.55;zoomx,0.58;diffuse,color("#FFFF66FF");diffusebottomedge,color("#DDAA44FF");shadowlength,0.8);
		Text=string.upper(song:GetDisplayMainTitle().." "..song:GetDisplaySubTitle())
	};


	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		InitCommand=cmd(addy,95;zoom,0.4;diffuse,color("#fffFFF");diffusebottomedge,color("#CCCCCC");shadowlength,0.8);
		Text=""..string.upper(song:GetGroupName());
	};

};]]

--Player mods position are defined in metrics
t[#t+1] = Def.ActorFrame{
	--Bottom bg
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_BOTTOM-70);

	Def.Quad {
		InitCommand=cmd(diffuse,0,0,0,0.4;setsize,SCREEN_WIDTH,30;);

	};

	Def.Quad {
		InitCommand=cmd(diffuse,color("#C2C2C2");setsize,SCREEN_WIDTH,1;y,15);

	};

	Def.Quad {
		InitCommand=cmd(diffuse,color("#C2C2C2");setsize,SCREEN_WIDTH,1;y,-15);

	};

	LoadActor(THEME:GetPathG("","gl"))..{
		InitCommand=cmd(visible,GetUserPref("UserPrefSetPreferences") == "Yes";zoom,0.675;y,-2);

	};
};

t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	InitCommand=cmd(visible,GetUserPref("UserPrefSetPreferences") == "No";maxwidth,1020;zoomy,0.55;zoomx,0.58;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-70;shadowlength,0.8);
	Text="NO GAME LEVEL"
}





t[#t+1] = Def.ActorFrame{

	InitCommand=cmd(draworder,100;y,SCREEN_CENTER_Y-70;);
	OnCommand=function(self)
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			if STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):IsDisqualified()==true then
				self:visible(false);
			else
				self:visible(true);
			end
		else
			self:visible(false);
		end

		if GAMESTATE:GetNumSidesJoined() == 2 then
			self:x(SCREEN_CENTER_X-140);
			if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_TwoPlayersSharedSides" then
			self:visible(false)

				if GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P1" then
					self:visible(true)
					self:x(SCREEN_CENTER_X);
				end
			end

		else
			self:x(SCREEN_CENTER_X-200);
		end
	end;

	--LoadActor("P1Stats")..{};
};

--It's not like this theme supports course mode anyway, so I don't think AllowW1_CoursesOnly will ever appear
local AllowSuperb = (PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Everywhere');
local spacing = AllowSuperb and 36 or 40;

t[#t+1] = Def.ActorFrame{

	--Marvelous/Superb
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(AllowSuperb and 156 or 125);
	end;
	
	Def.Quad{
		InitCommand=cmd(y,-spacing;setsize,500,30;faderight,1;fadeleft,1;diffuse,color("#FFFFFF");blend,Blend.Add;visible,AllowSuperb);
	};
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(y,-spacing;visible,AllowSuperb);
		Text="SUPERB";
	};
	
	--Perfect
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		Text="PERFECT";
	};

	Def.Quad{
		InitCommand=cmd(setsize,500,30;faderight,1;fadeleft,1;diffuse,color("#2264b7");blend,Blend.Add);
		--OnCommand=cmd(x,itembaseX;y,itembaseY);
	};

	--Great
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(y,spacing);
		Text="GREAT";
	};
	Def.Quad{
		InitCommand=cmd(setsize,500,30;faderight,1;fadeleft,1;diffuse,color("#34851f");blend,Blend.Add);
		OnCommand=cmd(y,spacing);
	};

	--GOODS
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(y,spacing*2);
		Text="GOOD";
	};
	Def.Quad{
		InitCommand=cmd(setsize,500,30;faderight,1;fadeleft,1;diffuse,color("#85781f");blend,Blend.Add);
		OnCommand=cmd(y,spacing*2);
	};
	--BADS
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(y,spacing*3);
		Text="BAD"
	};
	Def.Quad{
		InitCommand=cmd(setsize,500,30;faderight,1;fadeleft,1;diffuse,color("#932192");blend,Blend.Add);
		OnCommand=cmd(y,spacing*3);
	};

	--Miss
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(y,spacing*4);
		Text="MISS";
	};
	Def.Quad{
		InitCommand=cmd(setsize,500,30;faderight,1;fadeleft,1;diffuse,color("#ac1e1e");blend,Blend.Add);
		OnCommand=cmd(y,spacing*4;);
	};
	--Combo
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(y,spacing*5);
		Text="MAX COMBO";
	};
	Def.Quad{
		InitCommand=cmd(setsize,500,30;faderight,1;fadeleft,1;diffuse,color("#666666");blend,Blend.Add);
		OnCommand=cmd(y,spacing*5);
	};
	--SCORE
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(y,spacing*6);
		Text="SCORE";
	};
	Def.Quad{
		InitCommand=cmd(setsize,500,30;faderight,1;fadeleft,1;diffuse,color("#c1800e");blend,Blend.Add);
		OnCommand=cmd(y,spacing*6);
	};

};


for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	-- position = pn==PLAYER_2 ? 1 : -1;
	local position = (pn == "PlayerNumber_P2") and 1 or -1;
	local sPosition = AllowSuperb and 154 or 123;
	t[#t+1] = LoadActor("PlayerNumbers", pn)..{
		InitCommand=cmd(xy,SCREEN_CENTER_X+235*position,sPosition)
	};
	t[#t+1] = LoadActor("PlayerGrade", pn)..{
		InitCommand=cmd(xy,SCREEN_CENTER_X+300*position,SCREEN_CENTER_Y);
	};
end


t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(zoom,0.45;skewx,-0.09;horizalign,left;x,SCREEN_LEFT+30;y,SCREEN_BOTTOM-58;shadowlength,0.8;diffuse,1,0.8,0.3,1;diffusetopedge,1,1,0.6,1;glowshift);
	OnCommand=function(self)
	local song = GAMESTATE:GetCurrentSong();
		if song then
			profile = PROFILEMAN:GetMachineProfile();
			scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_1));
			assert(scorelist);
			local scores = scorelist:GetHighScores();
			--local topscore = scores[1]:GetScore();
			--local curscore = STATSMAN:GetPlayedStageStats(1):GetPlayerStageStats(PLAYER_1):GetScore();

			--SCREENMAN:SystemMessage(topscore.."   "..curscore);
				--[[if curscore == topscore then
					self:visible(true);
					self:settext("NEW BEST SCORE!");
				else
					self:visible(false);
				end]]

		end
	end;
}


t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(zoom,0.45;skewx,-0.09;horizalign,right;x,SCREEN_RIGHT-30;y,SCREEN_BOTTOM-58;shadowlength,0.8;diffuse,1,0.8,0.3,1;diffusetopedge,1,1,0.6,1;glowshift);
	OnCommand=function(self)
	local song = GAMESTATE:GetCurrentSong();
		if song then
			--[[profile = PROFILEMAN:GetMachineProfile();
			scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_2));
			assert(scorelist);
			local scores = scorelist:GetHighScores();
			local topscore = scores[1]:GetScore();
			local curscore = STATSMAN:GetPlayedStageStats(1):GetPlayerStageStats(PLAYER_2):GetScore();

			--SCREENMAN:SystemMessage(topscore.."   "..curscore);
				if curscore == topscore then
					self:visible(true);
					self:settext("NEW BEST SCORE!");
				else
					self:visible(false);
				end]]

		end
	end;
}





t[#t+1] = LoadActor(THEME:GetPathG("","footer"), true)..{
	InitCommand=cmd(draworder,100);
}

--BARRITA ABAJO

--t[#t+1] = Def.Quad {
--	InitCommand=cmd(draworder,100;diffuse,color("#1D1D1DFF");zoomto,304,10;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-20;fadebottom,0.2);
--
--}


--These lights are headache inducing. I don't know why anyone likes them.
--If you want your lights so badly, please just use the lights on the arcade...
t[#t+1] = LoadActor(THEME:GetPathG("","header"), true)..{
	InitCommand=cmd(draworder,100);
};



--TITLE
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,100;rotationx,30;diffuse,0.08,0.08,0.08,1;diffusetopedge,0.2,0.2,0.2,1;shadowlengthy,-1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_TOP+37;zoomx,0.7;zoomy,0.725;);
	Text="RESULTS"
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
		local stageNum=GAMESTATE:GetCurrentStageIndex()
		if stageNum < 10 then
			self:settext("0"..stageNum);
		else
			self:settext(stageNum);
		end
	end;
}


--[[t[#t+1] = LoadActor(THEME:GetPathG("","light/_light"))..{
	InitCommand=cmd(draworder,800;Center;zoomto,854,SCREEN_HEIGHT);
	OnCommand=cmd(blend,Blend.Add;diffusealpha,0;sleep,4.725;diffusealpha,1;sleep,0.2;decelerate,3;diffusealpha,0.2)
}]]





return t;
