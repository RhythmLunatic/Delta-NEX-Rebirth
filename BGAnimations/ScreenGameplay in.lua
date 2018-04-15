return Def.ActorFrame{
	LoadActor(GetSongBackground())..{
		InitCommand=cmd(Cover;diffusealpha,1);
		OnCommand=cmd(linear,.3;diffusealpha,0);
	};
};

