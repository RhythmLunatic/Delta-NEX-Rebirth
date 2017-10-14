--[[return Def.ActorFrame{
    LoadActor("Music Wheel Song Normal")..{}
    
};]]


local t = Def.ActorFrame{
    
    Def.Sprite{
        SetCommand = function(self,params)
            --self:visible(0);
            local name = params.Text;
            if name then
				local groupJacket = GetSongGroupJacketPath(name);
				local groupBanner = SONGMAN:GetSongGroupBannerPath(name);
                if groupJacket then
					self:scaletoclipped(180,180);
					self:Load(groupJacket);
				elseif groupBanner ~= "" then
					self:Load(groupBanner);
					self:scaletoclipped(250,177);
				else
					--I don't know what's up with the size, so this is the best guess
					--To make it fit in the banner frame..
					self:scaletoclipped(250,177);
					self:Load(THEME:GetPathG("MusicWheelItem", "SectionCollapsed NormalPart/fallback banner"));
				end;
			end;
        end;
        CurrentSongChangedMessageCommand=function(self)
            self:queuecommand("Set");
        end;
    };
	--SectionCollapsedOnCommand=y,5.25;horizalign,center;uppercase,true;zoom,0.475;shadowlength,1;maxwidth,360;
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(y,5.25;horizalign,center;uppercase,true;zoom,0.475;shadowlength,1;maxwidth,360;);
		SetCommand = function(self, params)
			local name = params.Text;
			if name then
				local groupJacket = GetSongGroupJacketPath(name);
				local groupBanner = SONGMAN:GetSongGroupBannerPath(name);
				if groupJacket or groupBanner ~= "" then
					self:diffusealpha(0);
				else
					self:diffusealpha(1);
					self:settext(name);
				end;
			end;
		end;
		CurrentSongChangedMessageCommand=function(self)
            self:queuecommand("Set");
        end;
	};

}

return t;
