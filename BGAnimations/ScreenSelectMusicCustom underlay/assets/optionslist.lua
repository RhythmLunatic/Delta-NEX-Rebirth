local maxitems = 8;
local selection = {
    [PLAYER_1] = 1,
    [PLAYER_2] = 1,
};

local currentoption = {
    [PLAYER_1] = nil,
    [PLAYER_2] = nil,
};

local option_stack = {
    [PLAYER_1] = {},
    [PLAYER_2] = {},
};

local selection_stack = {
    [PLAYER_1] = {},
    [PLAYER_2] = {},
};


ResetPlayerDisplay(pn);

local function NoteskinMenu(pn)
    local noteskins = GetNoteskins();
    local noteskin_stack = {};
    for i=1,#noteskins do 
        table.insert(noteskin_stack, ConfigNoteskin(noteskins[i]) );
    end
    table.insert(noteskin_stack, ConfigExit("Back"));
    table.insert(selection_stack[pn], selection[pn]);
    table.insert(option_stack[pn], noteskin_stack);
    selection[pn] = GetNoteskinSelection(pn);
    MESSAGEMAN:Broadcast("OptionsListSelected", { Player = pn, silent = true });
    MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, silent = true });
end;

local option_tree = { 
    {
        Name = "Speed",
        Options = {
            ConfigRange(NOTESCONFIG, "speed_mod", 250, 1, 9999, 25),
            ConfigChoices(PLAYERCONFIG, "SpeedModifier", 25, { 1, 10, 25, 50, 100 }),
            ConfigChoices(NOTESCONFIG, "speed_type", "maximum", notefield_speed_types),
            ConfigAction("Reset", function(pn) ResetPlayerSpeed(pn) end),
            ConfigExit("Back"),
        },
    },
    ConfigAction("Noteskin", function(pn) NoteskinMenu(pn) end),
    {
        Name = "Display",
        Options = {
            ConfigBool(NOTESCONFIG, "hidden", false),
            ConfigBool(NOTESCONFIG, "sudden", false),
            --ConfigRange(NOTESCONFIG, "hidden_offset", 0, 0, 0, 0), 
            --ConfigRange(NOTESCONFIG, "sudden_offset", 0, 0, 0, 0), 
            --ConfigRange(NOTESCONFIG, "fade_dist", 40, 0, 120, 5), 
            ConfigBool(NOTESCONFIG, "glow_during_fade", true),
            {
                Name = "Extras",
                Options = {
                    ConfigBool(PLAYERCONFIG, "ReverseJudgment", false),
                    ConfigRange(PLAYERCONFIG, "ScreenFilter", 0, 0, 100, 5),
                    ConfigBool(PLAYERCONFIG, "ShowEarlyLate", false),
                    ConfigBool(PLAYERCONFIG, "ShowJudgmentList", false),
                    ConfigBool(PLAYERCONFIG, "ShowOffsetMeter", false),
                    --ConfigChoices(PLAYERCONFIG, "ShowPacemaker", "off", pacemaker_targets),
                    ConfigExit("Back"),
                }
            },
            ConfigAction("Reset", function(pn) ResetPlayerDisplay(pn) end),
            ConfigExit("Back"),
        },
    },
    {
        Name = "Transform",
        Options = {
            {   
                Name = "Zoom", 
                Options = {
                    ConfigRange(NOTESCONFIG, "zoom", 1, -2, 2, 0.05), 
                    ConfigRange(NOTESCONFIG, "zoom_x", 1, -2, 2, 0.05), 
                    ConfigRange(NOTESCONFIG, "zoom_y", 1, -2, 2, 0.05), 
                    ConfigRange(NOTESCONFIG, "zoom_z", 1, -2, 2, 0.05), 
                    ConfigAction("Reset", function(pn) ResetPlayerZoom(pn) end),
                    ConfigExit("Back"),
                }
            },
            {   
                Name = "Rotation", 
                Options = {
                    ConfigRange(NOTESCONFIG, "rotation_x", 0, -180, 180, 5), 
                    ConfigRange(NOTESCONFIG, "rotation_y", 0, -180, 180, 5), 
                    ConfigRange(NOTESCONFIG, "rotation_z", 0, -180, 180, 5), 
                    ConfigAction("Reset", function(pn) ResetPlayerRotation(pn) end),
                    ConfigExit("Back"),
                }
            },
            {
                Name = "Viewport",
                Options = {
                    ConfigBool(NOTESCONFIG, "reverse", 1, { -1, 1 }),
                    ConfigRange(NOTESCONFIG, "yoffset", 140, 0, 180, 1),
                    ConfigRange(NOTESCONFIG, "fov", 45, 30, 90, 1),
                    ConfigAction("Reset", function(pn) ResetPlayerView(pn) end),
                    ConfigExit("Back"),
                }
            },
            ConfigAction("Reset", function(pn) ResetPlayerTransform(pn) end),
            ConfigExit("Back"),
        },
    },
    {
        Name = "Reset All",
        Options = {
            ConfigAction("Reset To Default", function(pn) 
                ResetPlayerSpeed(pn);
                ResetPlayerZoom(pn);
                ResetPlayerRotation(pn);
                ResetPlayerView(pn);
                ResetPlayerDisplay(pn);
                ResetPlayerTransform(pn);
            end),
            ConfigExit("Back"),
        }
    },

    ConfigExit("Exit"),
};

--//================================================================

function OptionsListController(self,param)
    local pn = param.Player;
    local stacksize = #option_stack[pn][#option_stack[pn]]
    param.Target = "OptionsList"

    if param.Input == "Prev" then
        if currentoption[pn] then
            if currentoption[pn].Field == "speed_mod" then currentoption[pn].Range.Step = PLAYERCONFIG:get_data(pn).SpeedModifier; end;
            MESSAGEMAN:Broadcast("ChangeProperty", { Player = pn, Input = param.Input, Option = currentoption[pn] });
            MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, Direction = "Prev", silent = true });
            return;
        else
            selection[pn] = selection[pn]-1;
            if selection[pn] < 1 then selection[pn] = stacksize end;
            if selection[pn] > stacksize then selection[pn] = 1 end;

            local topstack = option_stack[pn][#option_stack[pn]][selection[pn]]
            if topstack and topstack.Type and topstack.Type == "noteskin" then
                MESSAGEMAN:Broadcast("NoteskinChanged", { Player = pn, noteskin = GetNoteskins()[selection[pn]], silent = true });
            end;

            MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, Direction = "Prev", silent = false });
            return;
        end;
    end;
    
    if param.Input == "Next" then
        if currentoption[pn] then
            if currentoption[pn].Field == "speed_mod" then currentoption[pn].Range.Step = PLAYERCONFIG:get_data(pn).SpeedModifier; end;
            MESSAGEMAN:Broadcast("ChangeProperty", { Player = pn, Input = param.Input, Option = currentoption[pn] });
            MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, Direction = "Next", silent = true });
            return;
        else
            selection[pn] = selection[param.Player]+1;
            if selection[pn] > stacksize then selection[pn] = 1 end;
            if selection[pn] < 1 then selection[pn] = stacksize end;

            local topstack = option_stack[pn][#option_stack[pn]][selection[pn]];
            if topstack and topstack.Type and topstack.Type == "noteskin" then
                MESSAGEMAN:Broadcast("NoteskinChanged", { Player = pn, noteskin = GetNoteskins()[selection[pn]], silent = true });
            end;

            MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, Direction = "Next", silent = false });
            return;
        end;
    end;

    if param.Input == "Cancel" or param.Input == "Back" then

        if currentoption[pn] then
            selection[pn] = GetEntry(currentoption[pn], option_stack[pn][#option_stack[pn]]);
            currentoption[pn] = nil;
            MESSAGEMAN:Broadcast("Return", param);
            MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, silent = true });
            return;

        elseif #option_stack[pn] > 1 then
            selection[pn] = selection_stack[pn][#selection_stack[pn]];
            table.remove(selection_stack[pn], #selection_stack[pn]);
            table.remove(option_stack[pn], #option_stack[pn]);
            MESSAGEMAN:Broadcast("Return", param);
            MESSAGEMAN:Broadcast("NoteskinChanged", { Player = pn, noteskin = GetNoteskins()[GetNoteskinSelection(pn)], silent = true });
            MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, silent = true });
            return;

        else
            Global.oplist[param.Player] = false
            MESSAGEMAN:Broadcast("OptionsListClosed", param);
            return;
            
        end;
    end;

end;

function SelectOptionsList(param)
    local pn = param and param.Player or nil

    if currentoption[pn] ~= nil then
        currentoption[pn] = nil;
        MESSAGEMAN:Broadcast("OptionsListSelected", { Player = pn });
        MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, silent = true });
    else

        local topstack = option_stack[pn][#option_stack[pn]][selection[pn]];
        if topstack.Options and #topstack.Options > 0 then 
            table.insert(selection_stack[pn], selection[pn]);
            table.insert(option_stack[pn], topstack.Options);
            selection[pn] = 1;
            MESSAGEMAN:Broadcast("OptionsListSelected", { Player = pn });
            MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, silent = true });
            return;

        elseif topstack.Type then

            if topstack.Action then
                topstack.Action(pn);
                MESSAGEMAN:Broadcast("OptionsListSelected", { Player = pn });
                MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, silent = true });
                return;

            elseif topstack.Type == "bool" then
                MESSAGEMAN:Broadcast("ChangeProperty", { Player = pn, Input = "Next", Option = topstack, silent = true });
                MESSAGEMAN:Broadcast("OptionsListSelected", { Player = pn });
                MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, silent = true });
                return;

            elseif topstack.Type == "noteskin" then
                local n = SetNoteskinByIndex(pn, selection[pn]);
                selection[pn] = selection_stack[pn][#selection_stack[pn]];
                table.remove(selection_stack[pn], #selection_stack[pn]);
                table.remove(option_stack[pn], #option_stack[pn]);
                MESSAGEMAN:Broadcast("NoteskinChanged", { Player = pn, noteskin = n, silent = true });
                MESSAGEMAN:Broadcast("OptionsListSelected", { Player = pn });
                MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, silent = true });
                return;

            else
                currentoption[pn] = topstack;
                MESSAGEMAN:Broadcast("OptionsListSelected", { Player = pn });
                MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, silent = true });
                return;
            end
        else

            if #option_stack[pn] > 1 then
                selection[pn] = selection_stack[pn][#selection_stack[pn]];
                table.remove(selection_stack[pn], #selection_stack[pn]);
                table.remove(option_stack[pn], #option_stack[pn]);
                MESSAGEMAN:Broadcast("Return", param);
                MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, silent = true });
                return;
            else
                Global.oplist[param.Player] = false
                MESSAGEMAN:Broadcast("OptionsListClosed", param);
                return;
            end

        end;

    end
end;

--//================================================================

function ResetOptionStack(pn)
    option_stack[pn] = {}
    selection_stack[pn] = {}
    currentoption[pn] = nil;
    selection[pn] = 1;
    table.insert(option_stack[pn], option_tree);
    MESSAGEMAN:Broadcast("OptionsListChanged", { Player = pn, silent = true });
end;

--//================================================================

local t = Def.ActorFrame{};

local fontsize = 0.45;
local lineheight = 17;
local spacing = 186;
local sidespacing = 170;

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    if SideJoined(pn) then

        ResetOptionStack(pn);
        local scroller_actor = Def.ActorFrame{
            -- name
            Def.BitmapText{
                Name = "Name";
                Font = Fonts.options["Main"];
                InitCommand=cmd(horizalign,pnAlign(OtherPlayer[pn]);zoom,fontsize;skewx,-0.12;textglowmode,"TextGlowMode_Inner";playcommand,"LoseFocus");
                GainFocusCommand=cmd(stoptweening;glowshift;decelerate,0.15;diffuse,BoostColor(PlayerColor(pn),1.2);strokecolor,BoostColor(PlayerColor(pn),0.45);effectperiod,0.25);
                LoseFocusCommand=cmd(stoptweening;stopeffect;decelerate,0.15;diffuse,BoostColor(PlayerColor(pn),1.0);strokecolor,BoostColor(PlayerColor(pn),0.4));
                DisabledCommand=cmd(stoptweening;stopeffect;decelerate,0.15;diffuse,BoostColor(PlayerColor(pn,0.5),1.0);strokecolor,BoostColor(PlayerColor(pn,0.5),0.4));
                OptionsListClosedMessageCommand=function(self,param) if param and param.Player == pn then self:stopeffect() end; end;
            },
            -- value
            Def.BitmapText{
                Name = "Value";
                Font = Fonts.options["Main"];
                InitCommand=cmd(x,10*-pnSide(pn);horizalign,pnAlign(pn);zoom,fontsize*0.95;playcommand,"LoseFocus");
                GainFocusCommand=cmd(stoptweening;decelerate,0.15;diffuse,1,0.85,0.4,1;strokecolor,BoostColor({1,0.85,0.4,1},0.4));
                LoseFocusCommand=cmd(stoptweening;decelerate,0.15;diffuse,1,1,1,1;strokecolor,0.25,0.25,0.25,0.8);
                DisabledCommand=cmd(stoptweening;decelerate,0.15;diffuse,0.6,0.6,0.6,0.5;strokecolor,0.2,0.2,0.2,0.5);
                OptionsListClosedMessageCommand=function(self,param) if param and param.Player == pn then self:stopeffect() end; end;
            },  
        }

        
        local scroller = setmetatable({disable_wrapping = true}, item_scroller_mt)
        local scroller_item = OptionScrollerItem(lineheight,scroller_actor);
        scroller_item.__index.transform = function(self, item_index, num_items, is_focus)
            self.container:stoptweening();
            self.container:x(item_index * (1+(1/3)) * pnSide(pn));
            self.container:y(item_index * self.spacing);
            self.prev_index = item_index;
        end;


        t[#t+1] = Def.ActorFrame{
            InitCommand=cmd(diffusealpha,0);
            OptionsListOpenedMessageCommand=function(self,param) if param.Player == pn then self:stoptweening():decelerate(0.4):diffusealpha(1); ResetOptionStack(pn); end; end;
            OptionsListClosedMessageCommand=function(self,param) if param.Player == pn then self:stoptweening():decelerate(0.3):diffusealpha(0); end; end;
            OptionsListSelectedMessageCommand=function(self,param) self:playcommand("Refresh", param) end;
            OptionsListChangedMessageCommand=function(self,param) self:playcommand("Refresh", param) end;
            ReturnMessageCommand=function(self,param) self:playcommand("Refresh", param) end;
            RefreshCommand=function(self,param)
                if param and param.Player == pn then
                    local pn = param.Player;
                    scroller:set_info_set(GetCurrentStackInfo(option_stack[pn], pn), selection[pn]);
                    ScrollerFocus(scroller, selection[pn], currentoption[pn]);
                end;
            end;


            -- QUADS BG
            Def.ActorFrame{

                Def.Quad{
                    InitCommand=cmd(Center;skewx,-0.075;zoomto,_screen.h*(16/9)*-pnSide(pn)*0.45,_screen.h;halign,1.2;
                        diffuse,BoostColor(Global.bgcolor,0.5);diffusebottomedge,BoostColor(AlphaColor(Global.bgcolor,0),0.5);cropbottom,1/3;faderight,0.75);
                },
                Def.Quad{
                    InitCommand=cmd(Center;skewx,-0.075;zoomto,_screen.h*(16/9)*-pnSide(pn)*0.45,_screen.h;halign,1.2;
                        diffuse,BoostColor(PlayerColor(pn,1),0.5);diffusebottomedge,PlayerColor(pn,0);cropbottom,1/3;faderight,0.75);
                },
                LoadActor(THEME:GetPathG("","_pattern"))..{
                    InitCommand=cmd(Center;skewx,-0.075;zoomto,_screen.h*(16/9)*-pnSide(pn)*0.45,_screen.h;halign,1.2;
                        diffuse,BoostColor(PlayerColor(pn,0.2),0.5);diffusebottomedge,PlayerColor(pn,0);cropbottom,1/3;
                            customtexturerect,0,0,(_screen.h*(16/9)) / 384 * 2 *0.45,_screen.h / 384 * 2;texcoordvelocity,-0.125,-0.075;faderight,0.75;blend,Blend.Add);
                },
            },

            Def.Quad{
                InitCommand=cmd(CenterX;y,SCREEN_CENTER_Y-140;zoomto,_screen.w * 0.5 * pnSide(pn),1;horizalign,left;fadeleft,0.75;cropleft,0.15;diffuse,PlayerColor(pn));
            },

            -- TEXT
            Def.ActorFrame{
                InitCommand=cmd(x,SCREEN_CENTER_X + (pnSide(pn)*(spacing+32));y,SCREEN_CENTER_Y-140);
                OptionsListOpenedMessageCommand=function(self,param) if param.Player == pn then self:stoptweening():decelerate(0.4):x(SCREEN_CENTER_X + (pnSide(pn)*(spacing-8))); end; end;
                OptionsListClosedMessageCommand=function(self,param) if param.Player == pn then self:stoptweening():decelerate(0.3):x(SCREEN_CENTER_X + (pnSide(pn)*(spacing+8))); end; end;

                -- title
                Def.BitmapText{
                    Font = "regen strong";
                    Text = string.upper("Player  Options");
                    InitCommand=cmd(x,4*-pnSide(pn);zoomy,0.31;zoomx,0.3075;horizalign,pnAlign(OtherPlayer[pn]);strokecolor,BoostColor(PlayerColor(pn,0.9),1/3);diffusealpha,0);
                    OptionsListOpenedMessageCommand=function(self,param)
                        if param and param.Player == pn then
                            self:stoptweening();
                            self:decelerate(0.2);
                            self:diffusealpha(0.75);
                        end;
                    end;
                    OptionsListClosedMessageCommand=function(self,param)
                        if param and param.Player == pn then
                            self:stoptweening();
                            self:accelerate(0.3);
                            self:diffusealpha(0);
                        end;
                    end;
                },

                -- main scroller
                scroller:create_actors("OptionsList", maxitems, scroller_item, 0, 0)..{
                    InitCommand=cmd(y,4;x,16*pnSide(pn);diffusealpha,0);
                    OptionsListOpenedMessageCommand=function(self,param)
                        if param and param.Player == pn then
                            self:stoptweening();
                            self:decelerate(0.3);
                            self:diffusealpha(1);
                            self:x(0);
                        end;
                    end;

                    OptionsListClosedMessageCommand=function(self,param)
                        if param and param.Player == pn then
                            self:stoptweening();
                            self:accelerate(0.2);
                            self:diffusealpha(0);
                            self:x(16*pnSide(pn));
                        end;
                    end;

                },
            }

        }

    end;
end;

return t;