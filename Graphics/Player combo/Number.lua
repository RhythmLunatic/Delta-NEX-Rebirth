local c;
local player,judgmentType = ...;
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
local ShowMissComboAt = THEME:GetMetric("Combo", "ShowMissComboAt");
local Pulse = THEME:GetMetric("Combo", "NumberPulseCommand");

local t = Def.ActorFrame {
	Def.ActorFrame {
		Name="NumberFrame";
		LoadFont( "Combo", judgmentType) .. {
			Name="Number";
			InitCommand=cmd(visible,false);
		};
		
	};
};

t.InitCommand = function(self)
	c = self:GetChildren();
	c.Number = c.NumberFrame:GetChild("Number");
	c.Number:visible(false);
end;

t.OnCommand = function(self)
	-- Set the frame around the number as the Combo actor, so it's
	-- moved by ComboTransformCommand.  Don't set the number itself,
	-- since we want to set an explicit zoom on it, and ComboTransformCommand
	-- will override the whole TweenState.
	local player = self:GetParent();
	--player:SetActorWithComboPosition( c.NumberFrame );
end;

t.ComboCommand=function(self, param)






	local iCombo = param.Misses or param.Combo;
	local iShowComboAt = (param.Misses and param.Misses > 0) and ShowMissComboAt or ShowComboAt;
	

	c.Number:stoptweening();
	c.Number:diffuse( color("#FFFFFF") );
	

	--testing shit
	--STATSMAN:GetCurStageStats():GetPlayerStageStats(player):SetScore(100)



	if param.Misses then
		c.Number:diffuse( color("#FF2020") );
	end
	
		--c.Number:diffuse( color("#FF2020") );
	

	c.Number:settext( string.format("%03i", iCombo or 0) );
	
	

	if judgmentType == "NX" then
		(cmd(stoptweening;y,3;diffusealpha,1;zoomx,0.575;zoomy,0.525;linear,0.075;y,0;zoomx,0.425;zoomy,0.385;sleep,1;linear,0.2;diffusealpha,0;zoomx,1.05;zoomy,0.5))( c.Number, param );
	elseif judgmentType == "FIESTA 2" then
		(cmd(stoptweening;y,8;diffusealpha,1;zoomx,0.6;zoomy,0.55;linear,0.175;y,0;zoomx,0.55;zoomy,0.5;sleep,0.3;linear,0.2;zoomx,1.5,zoomy,0.5;diffusealpha,0))( c.Number, param );
	elseif judgmentType == "Delta LED" then
		(cmd(stoptweening;y,14;diffusealpha,1;zoom,.8;linear,0.075;y,0;zoom,.7;sleep,0.3;linear,0.2;zoomx,1.4;zoomy,0.2;diffusealpha,0))( c.Number, param );
	else
		Pulse( c.Number, param );
	end	
		
	-- Do the above even if we're not going to show the combo, so the
	-- tweening always matches up with the judgement.
	if not iCombo or iCombo < iShowComboAt then
		c.Number:visible(false);
	else
		c.Number:visible(true);
	end
end;

return t;
