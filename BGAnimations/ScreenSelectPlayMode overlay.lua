local t = Def.ActorFrame{
	LoadActor(THEME:GetPathG("","header"))..{};
	
	--TITLE
	LoadFont("venacti/_venacti 26px bold diffuse")..{
			InitCommand=cmd(draworder,100;rotationx,30;diffuse,0.08,0.08,0.08,1;diffusetopedge,0.2,0.2,0.2,1;shadowlengthy,-1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_TOP+37;zoomx,0.7;zoomy,0.725;);
		Text="SELECT MODE";
	};

	--TIMER

	LoadActor("B0") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,-0.55);

	}; 

	LoadActor("B1") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

	}; 

	LoadActor("B2") .. {
		InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

	}; 

	LoadFont("venacti/_venacti 26px bold diffuse")..{
			InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,-0.8;shadowlength,-0.8;horizalign,left;x,SCREEN_CENTER_X+185 ;y,SCREEN_TOP+16;zoom,0.40);
			Text="TIMER"
	}
};

return t;
