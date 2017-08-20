
local t = Def.ActorFrame{};

--[[
	t[#t+1] = Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,color("1,0,0,0");blend,Blend.Multiply);
		OnCommand=cmd(diffuse,color("0.75,0,0,0.75");decelerate,1.75;diffuse,color("0,0,0,1"));
	};
	
	]]--
	t[#t+1] = LoadActor("iwbtg")..{
		InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT);
	};
	
	
	t[#t+1] = Def.Quad {
		InitCommand=cmd(blend,Blend.Add;Center;zoomto,SCREEN_WIDTH+1,SCREEN_HEIGHT);
		OnCommand=cmd(diffuse,color("1,1,1,0");sleep,8;playcommand,"Off");
		OffCommand=cmd(diffusealpha,0;accelerate,0.325;diffusealpha,1);
	};
	

	t[#t+1] = LoadActor(THEME:GetPathS( Var "LoadingScreen", "failed" ) ) .. {
		StartTransitioningCommand=cmd(play);
	};


return t;