return Def.ActorFrame {
	--[[OnCommand=cmd();
	Def.Sprite {
		OnCommand=cmd(Center;LoadFromCurrentSongBackground;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;sleep,1;diffusealpha,1;decelerate,1.2;diffusealpha,0);
	};
	Def.Quad{
		InitCommand=cmd(diffuse,color("0,0,0,1");zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;Center;playcommand,"Check");
		CoinModeChangedMessageCommand=cmd(playcommand,"Check");
		CheckCommand=function(self)
			if GAMESTATE:GetCoinMode() == "CoinMode_Home" then
				SOUND:DimMusic(1,0);
				self:visible(false);
			else
				SOUND:DimMusic(0,65536);
				self:visible(true);
			end;
		end;
	};
	LoadFont("MyDefault")..{
		InitCommand=cmd(Center;zoom,0.8;playcommand,"Check");
		CoinModeChangedMessageCommand=cmd(playcommand,"Check");
		CheckCommand=function(self)
			if GAMESTATE:GetCoinMode() == "CoinMode_Home" then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;
		Text="You shouldn't have done that";
	};]]
};
