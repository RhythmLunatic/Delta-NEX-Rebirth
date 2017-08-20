local t = Def.ActorFrame{}

t[#t+1] = Def.Quad{
	InitCommand=cmd(diffuse,0,0,0,0.85;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT/1.75;fadetop,1;vertalign,bottom;y,SCREEN_BOTTOM;x,SCREEN_CENTER_X);
};
		
t[#t+1] = Def.Quad{
	InitCommand=cmd(zoomto,SCREEN_WIDTH,75;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-40;diffuse,0,0,0,0.4;vertalign,top);
}


t[#t+1] = LoadActor(THEME:GetPathG("","logo"))..{
	InitCommand=cmd(Center;y,SCREEN_CENTER_Y-120;zoom,0.55);
}

t[#t+1] = LoadFont("Common normal")..{
	Text="Thanks for using PIU Delta NEX!\nThis theme forces some preferences, like Timing values, disabled Marvelous Timing and others. You can change this behavior on the game options at any time, but once the preferences get overwritten, you have to set them back manually! Do you want the theme to override your preferences?";
	InitCommand=cmd(zoom,0.425;wrapwidthpixels,1200;vertalign,top;shadowlength,0.8;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-25;strokecolor,0,0,0,0.6);
		GainFocusCommand=cmd(diffusealpha,1);
		LoseFocusCommand=cmd(diffusealpha,0.33);
};

return t