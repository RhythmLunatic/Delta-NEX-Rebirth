local x = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,Color("White"));
		OnCommand=cmd();
		OffCommand=cmd();
	};
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		Text="Saving...";
		InitCommand=cmd(horizalign,right;vertalign,bottom;xy,SCREEN_RIGHT-10,SCREEN_BOTTOM-10;diffuse,Color("Black");diffusealpha,0);
		OnCommand=cmd(linear,.5;diffusealpha,1);
	};

};
x[#x+1] = Def.Actor {
	BeginCommand=function(self)
		if SCREENMAN:GetTopScreen():HaveProfileToSave() then self:sleep(1); end;
		self:queuecommand("Load");
	end;
	LoadCommand=function()
		--Workaround for SaveProfileCustom not being called by SM
		for player in ivalues(GAMESTATE:GetHumanPlayers()) do
			local profileDir = PROFILEMAN:GetProfileDir(ProfileSlot[PlayerNumber:Reverse()[player]+1]);
			SaveProfileCustom(PROFILEMAN:GetProfile(player),profileDir);
		end;
		SCREENMAN:GetTopScreen():Continue();
	end;
};
return x;