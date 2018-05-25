local gc = Var "GameCommand";
local name = gc:GetName():lower();
local index = gc:GetIndex()+1;

--[[
Either StepMania doesn't have any way of telling how many choices there are
or I just haven't found it yet. Anyway, use this variable for now.
]]

local numChoices = 2;
local placement = SCREEN_WIDTH/2*index - SCREEN_WIDTH/4
return Def.ActorFrame{

    --[[LoadActor(name)..{
        InitCommand=cmd(x,placement);        
    };]]
    
    LoadFont("Common Normal")..{
        Text=name;
        InitCommand=cmd(diffuse,Color("White");x,placement);
        OffCommand=cmd();
        GainFocusCommand=cmd(stoptweening;accelerate,.2;zoom,1);
        LoseFocusCommand=cmd(stoptweening;accelerate,.2;zoom,.5;);
    };
	--[[LoadActor("subt_"..name)..{
		InitCommand=cmd(diffusealpha,0;x,SCREEN_CENTER_X;addy,180);
		GainFocusCommand=cmd(linear,.1;diffusealpha,1);
		LoseFocusCommand=cmd(linear,.2;diffusealpha,0);
	
	};
	LoadActor("desc_"..name)..{
		InitCommand=cmd(diffusealpha,0;x,SCREEN_CENTER_X;addy,260);
		GainFocusCommand=cmd(linear,.1;diffusealpha,1);
		LoseFocusCommand=cmd(linear,.2;diffusealpha,0);
	
	};]]


};
