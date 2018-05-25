local pn = ...
local function CurrentNoteSkin(p)
        local state = GAMESTATE:GetPlayerState(p)
        local mods = state:GetPlayerOptionsArray( 'ModsLevel_Preferred' )
        local skins = NOTESKIN:GetNoteSkinNames()

        for i = 1, #mods do
            for j = 1, #skins do
                if string.lower( mods[i] ) == string.lower( skins[j] ) then
                   return skins[j];
                end
            end
        end

end
return Def.ActorFrame{
		OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
		PlayerJoinedMessageCommand=cmd(queuecommand,"On");
		PlayerUnjoinedMessageCommand=cmd(playcommand,"On");
		
		LoadActor("optionIcon")..{
			InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,.75);
		};
		
		Def.Sprite{
			InitCommand=cmd(x,1;draworder,100);
			OnCommand=function(self)
				local arrow = "UpLeft";
				local name = "Tap note";
				if CurrentNoteSkin(pn) == "delta" then
					name = "Ready Receptor";
				elseif CurrentNoteSkin(pn) == "delta-note" or CurrentNoteSkin(pn) == "rhythm" then
					arrow = "_UpLeft";
				end
				local path = NOTESKIN:GetPathForNoteSkin(arrow, name, CurrentNoteSkin(pn));
				
				self:Load(path);
				self:croptop(0);
				self:cropright(0);
				self:zoom(0.35);
			end;
			OptionsListClosedMessageCommand=cmd(queuecommand,"On");
			CodeMessageCommand=cmd(playcommand,"On");
		};

	};
