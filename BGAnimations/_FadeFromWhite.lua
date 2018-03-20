local t = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;Center;diffuse,Color("White"));
		OnCommand=cmd(linear,.3;diffusealpha,0);
	};
};

return t;
