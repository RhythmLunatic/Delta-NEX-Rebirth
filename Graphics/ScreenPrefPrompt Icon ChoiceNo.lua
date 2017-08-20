
local t = Def.ActorFrame {
	GainFocusCommand=function(self)
		SetUserPref("UserPrefSetPreferences", "No");
	end
};
t[#t+1] = Def.Quad{
		InitCommand=cmd(diffuse,1,0.2,0,1;zoomto,220,32;fadeleft,0.5;faderight,0.5;blend,Blend.Add;y,-30);
		GainFocusCommand=cmd(stoptweening;linear,0.15;diffusealpha,1);
		LoseFocusCommand=cmd(stoptweening;linear,0.15;diffusealpha,0.2);

};

t[#t+1] = LoadFont("Common normal")..{
	Text="No, disallow the theme to change my preferences, even if this doesn't attain maximum functionality and might cause errors.\n\nRecommended for testing purposes, or users who play other game types than pump.";
	InitCommand=cmd(zoom,0.45;wrapwidthpixels,400;vertalign,top;shadowlength,0.8;y,-5);
		GainFocusCommand=cmd(stoptweening;linear,0.2;diffusealpha,1);
		LoseFocusCommand=cmd(stoptweening;linear,0.2;diffusealpha,0.33);
};

t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	Text="NO";
	InitCommand=cmd(zoom,0.8;y,-30);
		GainFocusCommand=cmd(stoptweening;linear,0.2;zoom,0.8);
		LoseFocusCommand=cmd(stoptweening;linear,0.2;zoom,0.6);
};


return t