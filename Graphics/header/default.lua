local lightsEnabled = ...
if lightsEnabled == nil then
	lightsEnabled = true; --Fallback to true since originally the lights were always on.
end;

local t = Def.ActorFrame{
	InitCommand=cmd(zoom,.7;x,SCREEN_CENTER_X);

	LoadActor("_header")..{
		InitCommand=cmd(draworder,100;vertalign,top;);
	};
	
	LoadActor("_hexes")..{
		InitCommand=cmd(visible,lightsEnabled;draworder,100;vertalign,top;);
	};
	--awesome light
	LoadActor("_light")..{
		InitCommand=cmd(draworder,800;vertalign,top;visible,lightsEnabled;);
		OnCommand=cmd(blend,Blend.Add;effectclock,"bgm";diffuseshift;effectcolor1,color("#FFFFFF20");effectcolor2,color("#FFFFFFFF"));
	};

	Def.Quad{
		InitCommand=cmd(draworder,800;vertalign,top;fadebottom,1;visible,lightsEnabled;);
		OnCommand=cmd(blend,Blend.Add;effectclock,"bgm";diffuseshift;effectcolor1,color("#CCDFFF00");effectcolor2,color("#CCDFFF18"));
	};
};



--text
--[[t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,101;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,0.8;shadowlengthy,-0.8;horizalign,right;x,SCREEN_CENTER_X-175;y,SCREEN_TOP+10;zoom,0.40);
		Text="STAGE"
}
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,101;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,-0.8;shadowlength,-0.8;horizalign,left;x,SCREEN_CENTER_X+175 ;y,SCREEN_TOP+10;zoom,0.40);
		Text="TIMER"
}]]--



return t
