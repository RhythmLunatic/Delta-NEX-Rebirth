local player = ...
--local player = PLAYER_1
local diffArray = Enum.Reverse(Difficulty);

return Def.ActorFrame{
	InitCommand=cmd(zoom,.525);
	LoadActor("difficulty")..{
	};
	
	--[[LoadActor("modes 1x6")..{
		
	};]]
	
	Def.Sprite{
		Texture="modes 1x6";
		InitCommand=cmd(animate,false;addy,-40;);
		--CurrentSongChangedMessageCommand=cmd(playcommand,"On");
		--CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"On");
		--CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"On");
		--I actually didn't know you could do this until now
		['CurrentSteps'..ToEnumShortString(player)..'ChangedMessageCommand']=cmd(playcommand,"On");
		OnCommand=function(self)
			local steps = GAMESTATE:GetCurrentSteps(player);
			if steps then
				self:setstate(diffArray[steps:GetDifficulty()]);
				--SCREENMAN:SystemMessage(ToEnumShortString(steps:GetDifficulty()).." = "..tostring(Enum.Reverse(Difficulty)[steps:GetDifficulty()]));
			end;
		end;
	};
	
	LoadActor("arrows_normal 1x2")..{
		InitCommand=cmd(animate,false;setstate,0;addy,-55);
		--[[
		This weird MessageCommand is the only way to determine
		if the difficulty changed to easier or harder]]
		ChangeStepsMessageCommand=function(self, params)
			if params.Player == player and params.Direction == -1 then
				self:finishtweening();
				self:glow(color("1,1,1,.8"));
				self:addy(-5);
				--self:diffusealpha(1);
				self:linear(.3);
				self:addy(5);
				self:glow(color("0,0,0,0"));
				--self:diffusealpha(0);
			end;
		end;
	};
	
	LoadActor("arrows_normal 1x2")..{
		InitCommand=cmd(animate,false;setstate,1;addy,-25);
		ChangeStepsMessageCommand=function(self, params)
			if params.Player == player and params.Direction == 1 then
				self:finishtweening();
				self:glow(color("1,1,1,.8"));
				self:addy(5);
				--self:diffusealpha(1);
				self:linear(.3);
				self:addy(-5);
				self:glow(color("0,0,0,0"));
				--self:diffusealpha(0);
			end;
		end;
	};
	
	
	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		InitCommand=cmd(xy,-100,73;horizalign,left);
		--['CurrentSteps'..ToEnumShortString(player)..'ChangedMessageCommand']=cmd(playcommand,"On");
		Text="1234567898765";
		--OnCommand=function(self)
		
	
	};
	LoadFont("venacti/_venacti 15px bold")..{
		InitCommand=cmd(xy,58,3;horizalign,left);
		['CurrentSteps'..ToEnumShortString(player)..'ChangedMessageCommand']=cmd(playcommand,"On");
		OnCommand=function(self)
			local steps = GAMESTATE:GetCurrentSteps(player);
			if steps then
				self:settext("Lv. "..steps:GetMeter());
			end;
		end;
		--Text="Lv. 99";
	
	};


};