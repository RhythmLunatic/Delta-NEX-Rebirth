local gc = Var("GameCommand");

return Def.ActorFrame {
	
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH/1.5,40;fadeleft,1;faderight,1;y,50;diffusealpha,0;diffuse,0,0,0,0.5);
		GainFocusCommand=cmd(diffusealpha,1);
		LoseFocusCommand=cmd(diffusealpha,0);
	};

	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH/2,2;fadeleft,1;faderight,1;y,30;diffuse,color("#F54D70"));
	};
	
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH/2,2;fadeleft,1;faderight,1;y,70;diffuse,color("#F54D70"));
	};
	
	LoadActor(gc:GetText()) .. {
		InitCommand=cmd(zoom,0.7;y,52);
		GainFocusCommand=cmd(x,-15;stoptweening;linear,0.2;diffusealpha,1;x,0);
		LoseFocusCommand=cmd(x,0;stoptweening;linear,0.2;diffusealpha,0;x,15);
	};


};
