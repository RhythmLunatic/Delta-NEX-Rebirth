local gc = Var "GameCommand";
local name = gc:GetName():lower();
local index = gc:GetIndex()+1;

--[[
Either StepMania doesn't have any way of telling how many choices there are
or I just haven't found it yet. So of course the hack is to read metrics.ini
directly and count the commas in the string.
]]
--local numChoices = select(2,string.gsub(THEME:GetMetric("ScreenSelectPlayMode","ChoiceNames"), ",", ""))+1
local numChoices = THEME:GetMetric("ScreenSelectPlayMode","ScrollerNumItemsToDraw")
local placement = SCREEN_WIDTH/(numChoices)*index-(SCREEN_WIDTH/numChoices/2)
return Def.ActorFrame{

    --[[LoadActor(name)..{
        InitCommand=cmd(x,placement);        
    };]]
    
    LoadFont("Common Normal")..{
        Text=name;
        InitCommand=cmd(diffuse,Color("White");x,placement);
        --[[OnCommand=function(self)
        	SCREENMAN:SystemMessage(numChoices)
    	end;]]
        --OffCommand=cmd();
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
