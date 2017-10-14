local comboLabel;
local player = Var "Player";
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
local ShowMissComboAt = THEME:GetMetric("Combo", "ShowMissComboAt");
local Pulse = THEME:GetMetric("Combo", "LabelPulseCommand");

local t = Def.ActorFrame {
	LoadActor(GetUserPref("UserPrefJudgmentType")) .. {
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
			if GetUserPref("UserPrefJudgmentType") == "Normal" or GetUserPref("UserPrefJudgmentType") == "Deviation" then
				Pulse( self, param );
			end

			if GetUserPref("UserPrefJudgmentType") == "NX" then
				(cmd(stoptweening;diffusealpha,1;zoomx,0.65;zoomy,0.75;linear,0.075;zoomx,0.465;zoomy,0.385;sleep,1;linear,0.2;diffusealpha,0;zoomx,1.05;zoomy,0.5))(c.ComboLabel,param);
			end

			if GetUserPref("UserPrefJudgmentType") == "FIESTA2" then
			(cmd(stoptweening;diffusealpha,1;zoomx,0.5;zoomy,1;linear,0.125;zoomx,0.35;zoomy,0.35;sleep,0.35;linear,0.2;diffusealpha,0;zoomx,1.5;zoomy,0.05))(c.ComboLabel,param);
			end		

			if GetUserPref("UserPrefJudgmentType") == "DELTANEX" then
				(cmd(stoptweening;diffusealpha,1;zoomx,0.75;zoomy,0.65;linear,0.075;zoomx,0.45;zoomy,0.45;sleep,0.3;linear,0.2;diffusealpha,0;zoomx,1;zoomy,0.2))(c.ComboLabel,param);
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
