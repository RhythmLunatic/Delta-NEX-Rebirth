local t = Def.ActorFrame{

	InitCommand=cmd(xy,SCREEN_WIDTH/4+20,SCREEN_CENTER_Y/3);
	LoadFont("Common Normal")..{
		Text="This is a game where\nyou use your feet!";
		InitCommand=cmd(cropright,1;faderight,1);
		OnCommand=cmd(sleep,.5;linear,1;cropright,0;faderight,0);
	};
	LoadFont("Common Normal")..{
		Text="When the arrow reaches the receptor,\nstep on the corresponding panel!";
		InitCommand=cmd(addy,100;cropright,1;faderight,1);
		OnCommand=cmd(sleep,8;linear,1;cropright,0;faderight,0);
	};
	LoadFont("Common Normal")..{
		Text="If you miss too many notes,\nyou'll fail the stage.\nTry to play songs at your level.";
		InitCommand=cmd(addy,200;cropright,1;faderight,1);
		OnCommand=cmd(sleep,20;linear,1;cropright,0;faderight,0);
	};
};

return t;
