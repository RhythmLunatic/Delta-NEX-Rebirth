local t = Def.ActorFrame{};
--HEADER
t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","header"), false);
	
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(rotationx,30;diffuse,0.08,0.08,0.08,1;diffusetopedge,0.2,0.2,0.2,1;shadowlengthy,-1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_TOP+37;zoomx,0.7;zoomy,0.725;);
		Text="INFORMATION";
	};
};
return t;