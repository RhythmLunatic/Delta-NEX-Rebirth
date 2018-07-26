return Def.ActorFrame{

	InitCommand=cmd(Center;stoptweening;);

	Def.Quad{
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,Color("White");diffusealpha,0);
		GoFullModeMessageCommand=cmd(linear,1;diffusealpha,1);
	};

	LoadActor(THEME:GetPathG("ScreenSelectGroup","rayo red"))..{
		InitCommand=cmd(zoom,0;addy,90);
		GoFullModeMessageCommand=cmd(zoom,.67;decelerate,.2;diffusealpha,1;decelerate,.05;diffusealpha,0;zoom,.67;decelerate,.2;diffusealpha,1;decelerate,.05;diffusealpha,0;decelerate,.2;diffusealpha,1;linear,.1;zoom,.67;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("ScreenSelectGroup","electric red"))..{
		InitCommand=cmd(zoom,0;addy,90;);
		GoFullModeMessageCommand=cmd(zoom,.67;decelerate,.2;diffusealpha,0;decelerate,.05;diffusealpha,1;zoom,.67;decelerate,.2;diffusealpha,0;decelerate,.05;diffusealpha,1;decelerate,.2;diffusealpha,0;linear,.1;zoom,.67;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("ScreenSelectMusic","efx1"))..{
		OnCommand=cmd(zoom,0;blend,'BlendMode_Add';);
		GoFullModeMessageCommand=cmd(diffusealpha,.8;zoom,.4;sleep,.1;linear,.05;diffusealpha,.4;zoom,.8;sleep,.2;linear,.1;diffusealpha,.1;zoom,.85;sleep,.4;linear,.1;diffusealpha,0;blend,'BlendMode_Add';);
	};
	LoadActor(THEME:GetPathG("ScreenSelectMusic","efx2"))..{
		OnCommand=cmd(zoom,0;blend,'BlendMode_Add';);
		GoFullModeMessageCommand=cmd(diffusealpha,.8;zoom,.4;sleep,.1;linear,.05;diffusealpha,.4;zoom,.8;sleep,.2;linear,.1;diffusealpha,.1;zoom,.85;sleep,.4;linear,.1;diffusealpha,0;blend,'BlendMode_Add';);
	};
	LoadActor(THEME:GetPathG("ScreenSelectGroup","SECRET MODE"))..{
		InitCommand=cmd(zoom,0);
		GoFullModeMessageCommand=cmd(diffusealpha,1;zoom,.66;sleep,.8;linear,.1;diffusealpha,0);
	};
};
