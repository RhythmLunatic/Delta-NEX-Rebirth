
local t = Def.ActorFrame {
	GainFocusCommand=function(self)
		SetUserPref("UserPrefSetPreferences", "Yes");
	end

};
t[#t+1] = Def.Quad{
		InitCommand=cmd(diffuse,0.4,0.75,1,1;zoomto,220,32;fadeleft,0.5;faderight,0.5;blend,Blend.Add;y,-30);
		GainFocusCommand=cmd(stoptweening;linear,0.15;diffusealpha,1);
		LoseFocusCommand=cmd(stoptweening;linear,0.15;diffusealpha,0.2);

};

t[#t+1] = LoadFont("Common normal")..{
	Text="Yes, allow the theme to override my preferences in order to get maximum functionality.\n\nRecommended for users who play pump game type only.";
	InitCommand=cmd(zoom,0.45;wrapwidthpixels,400;vertalign,top;shadowlength,0.8;y,-5);
		GainFocusCommand=cmd(stoptweening;linear,0.2;diffusealpha,1);
		LoseFocusCommand=cmd(stoptweening;linear,0.2;diffusealpha,0.33);
};

t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	Text="YES";
	InitCommand=cmd(zoom,0.8;y,-30);
		GainFocusCommand=cmd(stoptweening;linear,0.2;zoom,0.8);
		LoseFocusCommand=cmd(stoptweening;linear,0.2;zoom,0.6);
};



return t