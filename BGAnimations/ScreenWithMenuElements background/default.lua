local t = Def.ActorFrame {};

t[#t+1]=Def.ActorFrame{
  FOV=90;
  InitCommand=cmd(Center);
--[[	LoadActor("bg_ze") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH+256,SCREEN_HEIGHT);
	};
	LoadActor("brk") .. {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH+1,SCREEN_HEIGHT);
		OnCommand=cmd(queuecommand,"Loop");
		LoopCommand=cmd(diffusealpha,0.5;linear,1;diffusealpha,1;linear,1;diffusealpha,0.5;queuecommand,"Loop");
	};]]
	--[[LoadActor("LOAD") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH+1,SCREEN_HEIGHT);
	};]]
};


return t;
