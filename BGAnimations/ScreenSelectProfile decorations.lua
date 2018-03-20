local t = Def.ActorFrame{}


t[#t+1] = LoadActor(THEME:GetPathG("","footer"), true)..{
	InitCommand=cmd(draworder,100);
};

t[#t+1] = LoadActor(THEME:GetPathG("","header"))..{
	InitCommand=cmd(draworder,100);
};


--TITLE
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,100;rotationx,30;diffuse,0.08,0.08,0.08,1;diffusetopedge,0.2,0.2,0.2,1;shadowlengthy,-1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_TOP+37;zoomx,0.7;zoomy,0.725;);
	Text="SELECT PROFILE";
};

--TIMER

t[#t+1] = LoadActor("B0") .. {
	InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,-0.55);

}; 

t[#t+1] = LoadActor("B1") .. {
	InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

}; 

t[#t+1] = LoadActor("B2") .. {
	InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

}; 

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,-0.8;shadowlength,-0.8;horizalign,left;x,SCREEN_CENTER_X+185 ;y,SCREEN_TOP+16;zoom,0.40);
		Text="TIMER"
}

--STAGE

--[[t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
	InitCommand=cmd(draworder,102;diffuse,0.9,0.9,0.9,0.9;uppercase,true;horizalign,center;x,SCREEN_CENTER_X-160;maxwidth,45;zoomx,0.55;zoomy,0.55;y,SCREEN_TOP+25;shadowlengthx,1;shadowlengthy,-1);
	Text="00";
};

t[#t+1] = LoadActor("B0") .. {
	InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X-190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,0.55);

}; 

t[#t+1] = LoadActor("B1") .. {
	InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X-160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,0.6);

}; 

t[#t+1] = LoadActor("B2") .. {
	InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X-160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,0.6);

}; 

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,0.8;shadowlengthy,-0.8;horizalign,right;x,SCREEN_CENTER_X-185;y,SCREEN_TOP+16;zoom,0.40);
		Text="STAGE"
};]]


return t
