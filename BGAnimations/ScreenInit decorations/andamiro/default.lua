local t = Def.ActorFrame {

	LoadActor("_NDA_IRO")..{
		InitCommand=cmd(diffusealpha,0;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+2;sleep,3.65;linear,0.5;diffusealpha,1;)
	};

	LoadActor("LASH")..{
		InitCommand=cmd(x,SCREEN_CENTER_X-150;y,SCREEN_CENTER_Y+18;cropright,1;sleep,4.15;linear,0.5;cropright,0;)
	};

	LoadActor("A")..{
		InitCommand=cmd(x,SCREEN_CENTER_X-100;y,SCREEN_CENTER_Y;diffusealpha,0;zoom,1);
		OnCommand=cmd(linear,2;diffusealpha,1;sleep,1;linear,0.65;zoom,0.28;x,SCREEN_CENTER_X-150;diffusealpha,1)
	};

	LoadActor("M")..{
		InitCommand=cmd(x,SCREEN_CENTER_X+100;y,SCREEN_CENTER_Y;diffusealpha,0;zoom,1);
		OnCommand=cmd(linear,2;diffusealpha,1;sleep,1;linear,0.65;zoom,0.28;x,SCREEN_CENTER_X+55)
	};

	--[[Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1);
		OnCommand=cmd(diffusealpha,0;sleep,9.8;linear,.2;diffusealpha,1);
	};]]
	LoadFont("MyDefault")..{
		InitCommand=cmd(Center;addy,-170;maxwidth,SCREEN_WIDTH-10);
		Text=THEME:GetString("ScreenInit","Warning1");
	};
	LoadFont("MyDefault")..{
		InitCommand=cmd(Center;addy,170);
		Text=THEME:GetString("ScreenInit","Warning2");
	};

};

return t;
