local t = Def.ActorFrame{
	LoadActor(getRandomBackground("_random wallpapers"))..{
		InitCommand=cmd(Cover);
	};
	
	LoadActor(THEME:GetPathG("", "logo"))..{
		InitCommand=cmd(zoom,.5;xy,SCREEN_WIDTH*.2,SCREEN_BOTTOM*.8);
	};
};

return t;
