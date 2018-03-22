local t=Def.ActorFrame{};

t[#t+1]=Def.ActorFrame{
  FOV=90;
	LoadActor(THEME:GetPathG("","_VIDEOS/back")) .. {
		InitCommand=cmd(Center;Cover);
	};
};

return t;
