
local curTime = -1;
local bpm = 60;
local curskin = {
    [PLAYER_1] = "",
    [PLAYER_2] = "",
}

local function UpdateTime(self, delta)
    curTime = GAMESTATE:GetCurMusicSeconds();
    MESSAGEMAN:Broadcast("UpdateNotefield");
end

local function CanShowNotefield()
    if Global.state == "SelectSteps" or Global.oplist[PLAYER_1] or Global.oplist[PLAYER_2] then return true end;
    return false;
end;

local t = Def.ActorFrame{
    InitCommand=function(self) self:SetUpdateFunction(UpdateTime); self:diffusealpha(0); end;
    StateChangedMessageCommand=cmd(playcommand,"Refresh");
    OptionsListOpenedMessageCommand=cmd(playcommand,"Refresh");
    OptionsListClosedMessageCommand=cmd(playcommand,"Refresh");
    RefreshCommand=function(self)
        self:stoptweening();
        self:linear(0.15);
        if CanShowNotefield() then
            self:diffusealpha(1);
        else
            self:diffusealpha(0);
        end;
    end;
} 

local tex = Def.ActorFrameTexture{
    InitCommand= function(self)
        self:setsize(_screen.w, _screen.h)
        self:SetTextureName("notefield_overlay")
        self:EnableAlphaBuffer(true);
        self:EnablePreserveTexture(false)
        self:Create();
    end;
}

-- <Kyzentun> Luizsan: Yeah, it's touchy about the order.  I tried to make it less 
-- touchy in the notefield_targets branch, but good luck finding someone to build that.
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do

    tex[#tex+1] = Def.NoteField{

        StepsChangedMessageCommand=cmd(playcommand,"Refresh");
        SpeedChangedMessageCommand=cmd(playcommand,"Refresh");
        FolderChangedMessageCommand=cmd(playcommand,"Refresh");
        PropertyChangedMessageCommand=cmd(playcommand,"Refresh");
        OptionsListChangedMessageCommand=cmd(playcommand,"Refresh");
        NoteskinChangedMessageCommand=function(self,param)
            if param and param.noteskin and param.Player == pn then
                self:set_skin(param.noteskin, {});
            end;
        end;

        RefreshCommand=function(self)
            if GAMESTATE:IsSideJoined(pn) and Global.pncursteps[pn] then
                if Global.state ~= "SelectSteps" then
                    self:visible(Global.oplist[pn]);
                else
                    self:visible(true);
                end;

                local steps = Global.pncursteps[pn];
                local skin = GetPreferredNoteskin(pn);
                local prefs = notefield_prefs_config:get_data(pn);

                self:set_vanish_type("FieldVanishType_RelativeToSelf")

                if curskin[pn] ~= skin then
                    self:set_skin(skin, {});
                    curskin[pn] = skin;
                end;

                self:set_steps(steps);

                local speed = prefs.speed_mod;
                local mode = prefs.speed_type;
                local bpm = Global.song:GetDisplayBpms()[2];
                apply_notefield_prefs_nopn(bpm, self, prefs)
                self:playcommand("WidthSet");
                self:set_curr_second(curTime);  
            end;
        end;

        WidthSetCommand=function(self,param)
            if GAMESTATE:IsSideJoined(pn) and Global.pncursteps[pn] then
                local steps = Global.pncursteps[pn];
                local st = PureType(steps);

                if (st == "Double" or st == "Routine") or GAMESTATE:GetNumSidesJoined() == 1 then
                    self:set_base_values{
                        transform_pos_x = _screen.cx, 
                        transform_pos_y = _screen.cy,
                    }
                else
                    self:set_base_values{
                        transform_pos_x = _screen.cx + (self:get_width() + 32) * 0.5 * pnSide(pn), 
                        transform_pos_y = _screen.cy,
                    }
                end;
            end;
        end;

        UpdateNotefieldMessageCommand=function(self)
            if GAMESTATE:IsSideJoined(pn) and Global.pncursteps[pn] then
                self:set_curr_second(curTime);
            end;
        end;
    };

end;

t[#t+1] = tex;

t[#t+1] = Def.Sprite{
    Texture = "notefield_overlay";
    InitCommand=cmd(zoom,0.515;xy,_screen.cx,_screen.cy-177;vertalign,top;diffusealpha,0);
    OnCommand=cmd(playcommand,"Reload");
    MusicWheelMessageCommand=cmd(playcommand,"Reload");
    StepsChangedMessageCommand=cmd(stoptweening;diffusealpha,0;linear,0.15;diffusealpha,1);
    ReloadCommand=cmd(stoptweening;diffusealpha,0;sleep,0.6;linear,0.25;diffusealpha,1);
    StateChangedMessageCommand=cmd(finishtweening;linear,0.15;fadebottom,Global.state == "GroupSelect" and 0.2 or 0);
}


return t;