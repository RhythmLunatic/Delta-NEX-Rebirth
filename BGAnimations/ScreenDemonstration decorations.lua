--TODO: Use GameplayMargins instead of these metrics values
local P1X = THEME:GetMetric("ScreenGameplay", "PlayerP1TwoPlayersTwoSidesX");
local P2X = THEME:GetMetric("ScreenGameplay", "PlayerP2TwoPlayersTwoSidesX");

return Def.ActorFrame{
	InitCommand=function(self)
		GAMESTATE:ApplyGameCommand("stopmusic");
	end;

	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		Text=THEME:GetString("ScreenDemonstration","Demonstration");
		InitCommand=cmd(draworder,900;xy,SCREEN_CENTER_X,SCREEN_BOTTOM-45;--[[diffuseshift;effectperiod,2;effectcolor1,color("1,1,1,1");effectcolor2,color("1,1,1,0")]]);
	};
	
	--[[Def.Quad{
		InitCommand=cmd(setsize,260,50;diffuse,Color("Black");Center);
	};
	]]
	
	LoadActor(THEME:GetPathG("", "JoinOverlay"), true)..{
		Frames = Sprite.LinearFrames(10,.3);
		InitCommand=cmd(xy,P1X,SCREEN_BOTTOM-130;draworder,900);
	};
	

	
	LoadActor(THEME:GetPathG("", "JoinOverlay"), true)..{
		Frames = Sprite.LinearFrames(10,.3);
		InitCommand=cmd(xy,P2X,SCREEN_BOTTOM-130;draworder,900);
	};
};
