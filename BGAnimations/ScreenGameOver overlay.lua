
return Def.ActorFrame{
	InitCommand=function(self)
		GAMESTATE:ApplyGameCommand("stopmusic");
	end;

	LoadFont("venacti/_venacti 26px bold diffuse")..{
		Text="THANK YOU FOR PLAYING";
		InitCommand=cmd(Center;zoom,2;diffusebottomedge,Color("HoloGreen"));
	};
	LoadFont("soms2/_soms2 techy")..{
		Text="SEE YOU NEXT GAME";
		InitCommand=cmd(Center;addy,50;diffusebottomedge,Color("HoloGreen"));
	};
};
