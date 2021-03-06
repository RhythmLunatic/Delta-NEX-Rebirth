local comboLabel;
local player,judgementType = ...;
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
local ShowMissComboAt = THEME:GetMetric("Combo", "ShowMissComboAt");
local Pulse = THEME:GetMetric("Combo", "LabelPulseCommand");

local t = Def.ActorFrame {
	LoadActor(judgementType) .. {
		Name="ComboLabel";
		InitCommand=cmd(visible,false;y,-17);
		OnCommand=function(self)
			comboLabel = self;
			self:visible(false);
			--SCREENMAN:SystemMessage(tostring(comboLabel));
		end;
		ComboCommand=function(self, param)
			local iCombo = param.Misses or param.Combo;
			local iShowComboAt = (param.Misses and param.Misses > 0) and ShowMissComboAt or ShowComboAt;

			self:stoptweening();
			self:diffuse( color("#FFFFFF") );

			if param.Misses then
				self:diffuse( color("#FF2020") );
			end

			if judgementType == "NX" then
				(cmd(stoptweening;diffusealpha,1;zoomx,0.65;zoomy,0.75;linear,0.075;zoomx,0.465;zoomy,0.385;sleep,1;linear,0.2;diffusealpha,0;zoomx,1.05;zoomy,0.5))(self,param);
			elseif judgementType == "FIESTA 2" then
			(cmd(stoptweening;diffusealpha,1;zoomx,0.5;zoomy,1;linear,0.125;zoomx,0.35;zoomy,0.35;sleep,0.35;linear,0.2;diffusealpha,0;zoomx,1.5;zoomy,0.05))(self,param);
			elseif judgementType == "Delta LED" then
				(cmd(stoptweening;diffusealpha,1;zoom,.9;linear,0.075;zoom,.8;sleep,0.3;linear,0.2;diffusealpha,0;zoomx,1;zoomy,0.2))(self,param);
			else --if GetUserPref("UserPrefJudgmentType") == "Normal" or GetUserPref("UserPrefJudgmentType") == "Deviation" then
				Pulse( self, param );
			end

			-- Do the above even if we're not going to show the combo, so the
			-- tweening always matches up with the judgement.
			if not iCombo or iCombo < iShowComboAt then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;
	};

	OnCommand = function(self)
		-- Set the frame around the number as the Combo actor, so it's
		-- moved by ComboTransformCommand.  Don't set the number itself,
		-- since we want to set an explicit zoom on it, and ComboTransformCommand
		-- will override the whole TweenState.
		local player = self:GetParent();
		--player:SetActorWithComboPosition( c.NumberFrame );
	end;
};
	


return t;
