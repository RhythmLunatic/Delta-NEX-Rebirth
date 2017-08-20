local t = Def.ActorFrame{

	LoadActor("base");
	LoadActor("color")..{
	InitCommand=cmd(blend,Blend.Add);
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFF00");effectcolor2,color("#FFFFFF66");effectperiod,2,4,5,8);
};

	LoadActor("shine")..{
	InitCommand=cmd(blend,Blend.Add);
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFF00");effectcolor2,color("#FFFFFFFF");effecttiming,0.8,0,2.75,8);
};


}

return t 