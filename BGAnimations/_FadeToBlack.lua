return Def.ActorFrame {
	Def.Quad {
		InitCommand=cmd(Center;setsize,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,color("0,0,0,1");diffusealpha,0);
		OffCommand=cmd(linear,0.3;diffusealpha,1);
	};
};
