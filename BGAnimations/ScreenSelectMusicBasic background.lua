return Def.ActorFrame{
	InitCommand=cmd(Center);
	LoadActor("ScreenSelectMusic background/back_nex")..{
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH+1,SCREEN_HEIGHT;diffuse,Color("Blue"));
	};

};