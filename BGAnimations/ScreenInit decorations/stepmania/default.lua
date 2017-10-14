local t = Def.ActorFrame{

	LoadActor("base");
	LoadActor("blend")..{
	InitCommand=cmd(blend,Blend.Add);
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFF00");effectcolor2,color("#FFFFFF66");effectperiod,1);
};

}

return t 