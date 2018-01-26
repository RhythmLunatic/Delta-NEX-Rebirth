return Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;Center;diffusealpha,0;);
		OffCommand=cmd(sleep,3;linear,1;diffusealpha,1;);
	}
}