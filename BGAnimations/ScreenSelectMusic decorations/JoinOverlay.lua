local t = Def.ActorFrame{}

--P1 

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	Text="PRESS";
	InitCommand=cmd(uppercase,true;horizalign,center;x,-105;y,38;shadowlength,1;zoom,0.6;diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF99");effectperiod,1;);
};

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	Text="TO JOIN";
	InitCommand=cmd(uppercase,true;horizalign,center;y,38;shadowlength,1;zoom,0.6;diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF99");effectperiod,1;);
};

t[#t+1] = LoadActor(THEME:GetPathG("","_press dance 5x2.png"))..{
	Frames = Sprite.LinearFrames(10,.3);
	InitCommand=cmd(horizalign,center;x,-55;y,25;zoom,0.3;);
};

--[[t[#t+1] = LoadActor("start")..{
	InitCommand=cmd(draworder,106;horizalign,center;x,SCREEN_CENTER_X-215;y,SCREEN_CENTER_Y+39;zoom,0.3;diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF99");effectperiod,1;playcommand,"RefreshP1");
	PlayerJoinedMessageCommand=cmd(playcommand,"RefreshP1");
	CoinModeChangedMessageCommand=cmd(playcommand,"RefreshP1");
	CoinInsertedMessageCommand=cmd(playcommand,"RefreshP1");
	RefreshP1Command=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1))
	end;
};]]

--P2
--[[
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	Text="PRESS";
	InitCommand=cmd(uppercase,true;draworder,106;horizalign,center;x,SCREEN_CENTER_X+250;y,SCREEN_CENTER_Y+38;shadowlength,1;zoom,0.6;diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF99");effectperiod,1;playcommand,"RefreshP2");
	PlayerJoinedMessageCommand=cmd(playcommand,"RefreshP2");
	CoinModeChangedMessageCommand=cmd(playcommand,"RefreshP2");
	CoinInsertedMessageCommand=cmd(playcommand,"RefreshP2");
	RefreshP2Command=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2))
	end;
};

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	Text="TO JOIN";
	InitCommand=cmd(uppercase,true;draworder,106;horizalign,center;x,SCREEN_CENTER_X+353;y,SCREEN_CENTER_Y+38;shadowlength,1;zoom,0.6;diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF99");effectperiod,1;playcommand,"RefreshP2");
	PlayerJoinedMessageCommand=cmd(playcommand,"RefreshP2");
	CoinModeChangedMessageCommand=cmd(playcommand,"RefreshP2");
	CoinInsertedMessageCommand=cmd(playcommand,"RefreshP2");
	RefreshP2Command=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2))
	end;
};

t[#t+1] = LoadActor(THEME:GetPathG("","_press 5x2.png"))..{
	Frames = Sprite.LinearFrames(10,.3);
	InitCommand=cmd(draworder,106;horizalign,center;x,SCREEN_CENTER_X+300;y,SCREEN_CENTER_Y+25;zoom,0.3;playcommand,"RefreshP2");
	PlayerJoinedMessageCommand=cmd(playcommand,"RefreshP2");
	CoinModeChangedMessageCommand=cmd(playcommand,"RefreshP2");
	CoinInsertedMessageCommand=cmd(playcommand,"RefreshP2");
	RefreshP2Command=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2))
	end;
};
]]
--[[t[#t+1] = LoadActor("start")..{
	InitCommand=cmd(draworder,106;horizalign,center;x,SCREEN_CENTER_X+215;y,SCREEN_CENTER_Y+39;zoom,0.375;diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF99");effectperiod,1;playcommand,"RefreshP2");
	PlayerJoinedMessageCommand=cmd(playcommand,"RefreshP2");
	CoinModeChangedMessageCommand=cmd(playcommand,"RefreshP2");
	CoinInsertedMessageCommand=cmd(playcommand,"RefreshP2");
	RefreshP2Command=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2))
	end;
}]]


return t
