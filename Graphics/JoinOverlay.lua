--Apparently Condition will treat nil as true. Which is bad.
local dimText = (... == true)

return Def.ActorFrame{
	
	--Because the text can be different width, get the width and adjust the shadow accordingly
	OnCommand=function(self)
		if dimText then
			local l1 = self:GetChild("Label1");
			local l2 = self:GetChild("Label2");
			self:GetChild("dim"):setsize(l1:GetWidth() + l2:GetWidth() + 100,40);
		end;
	end;

	Def.Quad{
		Name="dim";
		InitCommand=cmd(diffuse,color("0,0,0,.8");fadeleft,.2;faderight,.2;);
		Condition=dimText;
	};

	LoadFont("venacti/_venacti 26px bold diffuse")..{
		Name="Label1";
		Text=THEME:GetString("Common","JoinLabel");
		InitCommand=cmd(uppercase,true;horizalign,center;x,-42;horizalign,right;shadowlength,1;diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF99");effectperiod,1;);
	};

	LoadFont("venacti/_venacti 26px bold diffuse")..{
		Name="Label2";
		Text=THEME:GetString("Common","JoinLabel2");
		InitCommand=cmd(uppercase,true;horizalign,center;x,28;horizalign,left;shadowlength,1;diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF99");effectperiod,1;);
	};

	LoadActor("_press "..GAMESTATE:GetCurrentGame():GetName().. " 5x2")..{
		Frames = Sprite.LinearFrames(10,.6);
		InitCommand=cmd(horizalign,center;x,-7;y,-13;zoom,.5);
	};
};
