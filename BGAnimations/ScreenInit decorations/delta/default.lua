local t = Def.ActorFrame{

	LoadActor("base");
	LoadActor("color")..{
	InitCommand=cmd(blend,Blend.Add);
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFF00");effectcolor2,color("#FFFFFF66");effectperiod,1);
};

	LoadActor("shine")..{
	InitCommand=cmd(blend,Blend.Add);
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFF00");effectcolor2,color("#FFFFFFFF");effecttiming,0.3,0,1.75,8);
};


}

return t 