--[[
Apparently the IdleTimeout doesn't call a transition, so we have to work
around it by checking the timer and executing the transition before the timer runs out
]]
local timerSeconds = THEME:GetMetric("ScreenTitleJoin", "IdleTimeoutSeconds");
local fadeoutTime = .3;

return Def.ActorFrame{

	--Piggybacking off that...
	--LoadActor("ScreenTitleMenu decorations")..{};
	
	--[[LoadActor(THEME:GetPathS("ScreenTitleMenu", "music"))..{
		OnCommand=function(self)
			if PREFSMAN:GetPreference("AttractSoundFrequency") == 'AttractSoundFrequency_EveryTime' then
				self:play();
			end
		end;
		OffCommand=cmd(stop);
	};]]
	
	Def.Quad{
		InitCommand=cmd(Center;setsize,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,Color("Black");diffusealpha,0;draworder,999);
		--Doesn't work, input gets locked during a transition.
		--[[OnCommand=function(self)
			if timerSeconds > 0 then
				SCREENMAN:GetTopScreen():AddInputCallback(inputs);
				self:hibernate(timerSeconds-fadeoutTime);
				self:queuecommand("Fade");
			end
		end;]]
		--[[OnCommand=function(self)
			--SCREENMAN:GetTopScreen():AddInputCallback(inputs);
			SCREENMAN:SystemMessage(PREFSMAN:GetPreference("AttractSoundFrequency"));
		end;]]
		
		FadeCommand=cmd(linear,fadeoutTime;diffusealpha,1);
	};

};
