return Def.ActorFrame{
    LoadFont("venacti/_venacti 26px bold diffuse")..{
        Text="Delta NEX Rebirth "..tostring(themeVersion);
        InitCommand=cmd(horizalign,center;vertalign,top;xy,SCREEN_CENTER_X,15;diffusebottomedge,Color("HoloDarkPurple"));
    };
    
    LoadFont("venacti/_venacti 15px bold")..{
		InitCommand=cmd(vertalign,top;xy,SCREEN_CENTER_X,45);
		OnCommand=function(self)
			if ProductVersion() ~= "5.0.12" then
				self:settext("WARNING: You are using StepMania version "..ProductVersion()..". Please update to 5.0.12.");
				self:diffuse(Color("Red"));
			else
    			self:settext("StepMania "..ProductVersion());
				self:diffuse(Color("HoloGreen"));
			end;
		end;
    };

}
