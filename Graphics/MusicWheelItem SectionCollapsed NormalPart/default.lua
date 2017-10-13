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
                if groupJacket then
					self:scaletoclipped(180,180);
					self:Load(groupJacket);
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

}

return t;
