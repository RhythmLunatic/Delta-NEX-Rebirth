local t = Def.ActorFrame{
	LoadFont("Common Normal")..{
		Text=base64decode(THEME:GetString("ap","m"));
		InitCommand=cmd(Center;wrapwidthpixels,SCREEN_WIDTH-10)
	};

};

return t;
