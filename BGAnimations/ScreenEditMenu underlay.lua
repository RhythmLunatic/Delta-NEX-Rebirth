local t = Def.ActorFrame {};

t[#t+1] = Def.Quad{
	InitCommand=cmd(diffuse,0,0,0,0.85;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT/1.75;fadetop,1;vertalign,bottom;y,SCREEN_BOTTOM;x,SCREEN_CENTER_X);
};


return t;