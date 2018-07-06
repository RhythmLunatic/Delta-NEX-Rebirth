local t = Def.ActorFrame{

    LoadActor(THEME:GetPathS("CommandMenu","Move"))..{
        PreviousGroupMessageCommand=cmd(play);
        NextGroupMessageCommand=cmd(play);
        OptionsListOpenedMessageCommand=cmd(play);
        OptionsListClosedMessageCommand=cmd(play);
        OptionsListRightMessageCommand=cmd(play);
        OptionsListLeftMessageCommand=cmd(play);
        OptionsListQuickChangeMessageCommand=cmd(play);
    };
    LoadActor(THEME:GetPathS("CommandMenu","Set"))..{
        OptionsListClosedMessageCommand=cmd(play);
        OptionsListStartMessageCommand=cmd(play);
        OptionsListResetMessageCommand=cmd(play);
    };
    LoadActor(THEME:GetPathS("CommandMenu","InOut"))..{
		CodeMessageCommand = function(self, params)
			if params.Name == 'OpenOpList' then
				--SCREENMAN:SystemMessage("OptionsList opened")
				SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
			end
		end;
        OptionsListPopMessageCommand=cmd(play);
        OptionsListPushMessageCommand=cmd(play);
    };
    LoadActor(THEME:GetPathS("","Common Cancel"))..{
        SongUnchosenMessageCommand=cmd(play);
    };
    
    LoadActor(THEME:GetPathS("","SSM_Select"))..{
        SongChosenMessageCommand=cmd(play);
        StepsChosenMessageCommand=cmd(play);
    };
    LoadActor(THEME:GetPathS("","SSM_Confirm"))..{
        OffCommand=cmd(play);
    };
};

for pn in ivalues(PlayerNumber) do


    t[#t+1] = LoadActor("oplist") ..{
        InitCommand=cmd(diffuse,color("1,0.95,0.9,0");zoom,0.675;Center;diffusealpha,0;blend,Blend.Add);
    
            OptionsListOpenedMessageCommand=function(self,params)
                if params.Player == pn then
                    if pn == PLAYER_1 then
                        self:zoomx(0.675);
    
                    elseif pn == PLAYER_2 then
                        self:zoomx(-0.675);
    
                    end
    
                    self:playcommand("Open");
                end
            end;
    
    
            OpenCommand=cmd(stoptweening;decelerate,0.3;diffusealpha,1;);
            OptionsListClosedMessageCommand=function(self,params)
                if params.Player == pn then
    
                    self:stoptweening();
                    self:accelerate(0.3);
                    self:diffusealpha(0);
    
                end
            end;
    
    }
    
    
    
    
    t[#t+1] = LoadActor("oplist") ..{
        InitCommand=cmd(diffuse,color("0.3,0.3,0.3,0");zoom,0.675;Center;diffusealpha,0;);
    
            OptionsListOpenedMessageCommand=function(self,params)
                if params.Player == pn then
                    if pn == PLAYER_1 then
                        self:zoomx(0.775);
    
                    elseif pn == PLAYER_2 then
                        self:zoomx(-0.775);
    
                    end
    
                    self:playcommand("Open");
                end
            end;
    
    
            OpenCommand=cmd(stoptweening;decelerate,0.3;diffusealpha,0.95;);
            OptionsListClosedMessageCommand=function(self,params)
                if params.Player == pn then
    
                    self:stoptweening();
                    self:accelerate(0.3);
                    self:diffusealpha(0);
    
                end
            end;
    
    }
    
end

return t;
