local t = Def.ActorFrame{
	LoadActor(THEME:GetPathG("", "_VIDEOS/Diagonal"))..{
		InitCommand=cmd(FullScreen);
	};
};

return t;
