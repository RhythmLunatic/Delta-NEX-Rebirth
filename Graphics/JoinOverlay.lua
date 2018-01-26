return Def.ActorFrame{

	LoadFont("venacti/_venacti 26px bold diffuse")..{
		Text="PRESS";
		InitCommand=cmd(uppercase,true;horizalign,center;x,-42;horizalign,right;shadowlength,1;diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF99");effectperiod,1;);
	};

	LoadFont("venacti/_venacti 26px bold diffuse")..{
		Text="TO JOIN";
		InitCommand=cmd(uppercase,true;horizalign,center;x,28;horizalign,left;shadowlength,1;diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF99");effectperiod,1;);
	};

	LoadActor("_press "..GAMESTATE:GetCurrentGame():GetName().. " 5x2")..{
		Frames = Sprite.LinearFrames(10,.6);
		InitCommand=cmd(horizalign,center;x,-7;y,-13;zoom,.5);
	};
};
