local t = Def.ActorFrame{
	InitCommand=cmd(hibernate,3);
}
local song = GAMESTATE:GetCurrentSong();


t[#t+1] = Def.ActorFrame {
  FOV=90;
  InitCommand=cmd(Center);
--[[	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH/2,SCREEN_HEIGHT;x,-SCREEN_WIDTH/4);
		OnCommand=cmd(diffuse,color("#000000");diffuserightedge,color("#c71585"));
	};
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH/2,SCREEN_HEIGHT;x,SCREEN_CENTER_X-(SCREEN_WIDTH/4));
		OnCommand=cmd(diffuse,color("#000000");diffuseleftedge,color("#c71585"));
	};]]
	LoadActor("../ScreenSelectMusic background/back_nex") .. {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT);
	};
};


--Seriously, why does this themer hate ActorFrames so much
--Rewriting this stuff to be easier to position drives me up the wall
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(xy,SCREEN_CENTER_X,100);
	

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
	
	LoadActor(THEME:GetPathG("","SongBanner"))..{
		InitCommand=cmd(draworder,100;zoom,0.475;);
	};

};

if GAMESTATE:IsSideJoined(PLAYER_1) then
	t[#t+1] = LoadActor(THEME:GetPathG("","PlayerSteps"), PLAYER_1)..{
		InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X-165;y,90;zoom,0.925);
	}
end;

if GAMESTATE:IsSideJoined(PLAYER_2) then
	t[#t+1] = LoadActor(THEME:GetPathG("","PlayerSteps"), PLAYER_2)..{
		InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X+125;y,90;zoom,0.925);
	}
end;

t[#t+1] = Def.ActorFrame{
	--Bottom bg
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_BOTTOM-91);
	
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
	InitCommand=cmd(visible,GetUserPref("UserPrefSetPreferences") == "No";maxwidth,1020;zoomy,0.55;zoomx,0.58;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-93;shadowlength,0.8);
	Text="NO GAME LEVEL"
}


t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	InitCommand=cmd(maxwidth,1020;zoomy,0.55;zoomx,0.58;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-76;diffuse,color("#FFFF66FF");diffusebottomedge,color("#DDAA44FF");shadowlength,0.8);
	Text=string.upper(song:GetDisplayMainTitle().." "..song:GetDisplaySubTitle())
}


t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	InitCommand=cmd(zoom,0.4;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-61;diffuse,color("#fffFFF");diffusebottomedge,color("#CCCCCC");shadowlength,0.8);
	Text=""..string.upper(song:GetGroupName());
}




t[#t+1] = LoadActor("P1Stats")..{
	InitCommand=cmd(draworder,100;y,SCREEN_CENTER_Y-40;);
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
			self:x(SCREEN_CENTER_X);
		end
	end
}


t[#t+1] = LoadActor("P2Stats")..{
	InitCommand=cmd(draworder,100;y,SCREEN_CENTER_Y-40;);
	OnCommand=function(self)

	if GAMESTATE:IsHumanPlayer(PLAYER_2) then
		if STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):IsDisqualified()==true then
			self:visible(false);
		else
			self:visible(true);
		end
	else
		self:visible(false);
	end


		if GAMESTATE:GetNumSidesJoined() == 2 then
			self:x(SCREEN_CENTER_X+170);

			if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_TwoPlayersSharedSides" then
			self:visible(false)

				if GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P2" then
					self:visible(true)
					self:x(SCREEN_CENTER_X);
				end
			end

		else
			self:x(SCREEN_CENTER_X);
		end
	end
}


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





t[#t+1] = LoadActor(THEME:GetPathG("","footer",), true)..{
	InitCommand=cmd(draworder,100);
}

--BARRITA ABAJO

--t[#t+1] = Def.Quad {
--	InitCommand=cmd(draworder,100;diffuse,color("#1D1D1DFF");zoomto,304,10;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-20;fadebottom,0.2);
--
--}



t[#t+1] = LoadActor(THEME:GetPathG("","header"))..{
	InitCommand=cmd(draworder,100);
}



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
