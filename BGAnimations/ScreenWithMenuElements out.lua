return Def.ActorFrame {
	OnCommand=cmd();
	Def.Quad {
		InitCommand=cmd(blend,Blend.Add;Center;zoomto,SCREEN_WIDTH+1,SCREEN_HEIGHT);
		OnCommand=cmd(diffuse,color("1,1,1,0");accelerate,0.325;diffusealpha,1);
	};
};