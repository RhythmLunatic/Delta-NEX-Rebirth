
return Def.ActorFrame{
	InitCommand=function(self)
		GAMESTATE:ApplyGameCommand("stopmusic");
		SOUND:PlayOnce(THEME:GetPathS("ScreenGameOver", "music"));
	end;

	Def.Quad{
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,Color("Black");diffusealpha,0;Center);
		OnCommand=cmd(sleep,3;linear,1;diffusealpha,1);
	};
	LoadFont("_@dfgW7 36px")..{
		Text="Thank You For Playing";
		InitCommand=cmd(Center;zoom,1.5;diffusebottomedge,Color("HoloBlue"););
		OnCommand=cmd(sleep,3;decelerate,.5;zoomy,0;zoomx,3);
	};
	LoadFont("soms2/_soms2 techy")..{
		Text="SEE YOU NEXT GAME";
		InitCommand=cmd(Center;addy,50;diffusebottomedge,Color("HoloBlue"));
		OnCommand=cmd(sleep,3;decelerate,.5;zoomy,0;zoomx,3);
	};
};
