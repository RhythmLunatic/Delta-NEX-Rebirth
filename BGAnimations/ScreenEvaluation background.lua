return Def.ActorFrame {
  FOV=90;
  --InitCommand=cmd(Center);
--[[	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH/2,SCREEN_HEIGHT;x,-SCREEN_WIDTH/4);
		OnCommand=cmd(diffuse,color("#000000");diffuserightedge,color("#c71585"));
	};
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH/2,SCREEN_HEIGHT;x,SCREEN_CENTER_X-(SCREEN_WIDTH/4));
		OnCommand=cmd(diffuse,color("#000000");diffuseleftedge,color("#c71585"));
	};]]


	LoadActor("_backgroundRedir", "musicSelect") .. {
		InitCommand=function(self)
			self:visible(not GAMESTATE:GetCurrentSong():HasBackground());
		end;
	};

	--Jacket BG
	--[[Def.Sprite{
		InitCommand=function(self)
			self:addy(-20);
			self:scaletoclipped(180,180);
			self:diffuse(color(".5,.5,.5,.7"));
			local path = GAMESTATE:GetCurrentSong():GetJacketPath();
			if path then self:Load(path);
			else
				self:diffusealpha(0);
			end;
		end;
		OnCommand=cmd(x,SCREEN_RIGHT-200;y,SCREEN_CENTER_Y;rotationx,-20;rotationy,15;rotationz,30;);
	};]]

	Def.Sprite{
		InitCommand=cmd(Load,GetSongBackground();visible,GAMESTATE:GetCurrentSong():HasBackground();scaletocover,0,0,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,color(".2,.2,.2,1"));
	};
};