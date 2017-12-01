--//================================================================

local maxitems = 6;
local currentoption = nil;  
local option_stack = {};
local selection_stack = {};
local option_tree = { 

    {
        Name = "Display",
        Options = {
            ConfigRange(THEMECONFIG, "BGBrightness", 100, 0, 100, 5),
            ConfigBool(THEMECONFIG, "DefaultBG", false),
            ConfigBool(THEMECONFIG, "DisableBGA", false),
            ConfigBool(THEMECONFIG, "CenterPlayer", false),
            ConfigAction("Reset", function() ResetDisplayOptions() end),
            ConfigExit("Back"),
        },
    },

    {
        Name = "Song",
        Options = {
            ConfigRange(THEMECONFIG, "MusicRate", 1, 0.5, 2, 0.05),
            ConfigChoices(THEMECONFIG, "FailType", "delayed", { "immediate", "delayed", "off" }),
            ConfigBool(THEMECONFIG, "FailMissCombo", true),
            ConfigAction("Reset", function() ResetSongOptions() end),
            ConfigExit("Back"),
        },
    },

    {
        Name = "Judgment",
        Options = {
            ConfigBool(THEMECONFIG, "AllowW1"),
            ConfigRange(THEMECONFIG, "TimingDifficulty", 4, 1, 9, 1),
            ConfigRange(THEMECONFIG, "LifeDifficulty", 4, 1, 7, 1),
            ConfigAction("Reset", function() ResetJudgmentOptions() end),
            ConfigExit("Back"),
        },
    },

    {
        Name = "Reset All",
        Options = {
            ConfigAction("Reset Default Options", function() ResetThemeSettings() end),
            ConfigExit("Back"),
        }
    },

    ConfigExit("Exit"),

};

table.insert(option_stack, option_tree);

--//================================================================

function OptionsMenuController(self,param)

    if param.Input == "Prev" then
        if currentoption then
            MESSAGEMAN:Broadcast("ChangeProperty", { Player = nil, Input = param.Input, Option = currentoption });
            MESSAGEMAN:Broadcast("OptionsMenuChanged", { Player = param.Player, Direction = "Prev", silent = true });
            THEMECONFIG:save("ProfileSlot_Invalid");
            return;
        else
            Global.selection = Global.selection-1;
            if Global.selection < 1 then Global.selection = #option_stack[#option_stack] end;
            if Global.selection > #option_stack[#option_stack] then Global.selection = 1 end;
            MESSAGEMAN:Broadcast("OptionsMenuChanged", { Player = param.Player, Direction = "Prev", silent = false });
            return;
        end;
    end;
    
    if param.Input == "Next" then
        if currentoption then
            MESSAGEMAN:Broadcast("ChangeProperty", { Player = nil, Input = param.Input, Option = currentoption });
            MESSAGEMAN:Broadcast("OptionsMenuChanged", { Player = param.Player, Direction = "Next", silent = true });
            THEMECONFIG:save("ProfileSlot_Invalid");
            return;
        else
            Global.selection = Global.selection+1;
            if Global.selection > #option_stack[#option_stack] then Global.selection = 1 end;
            if Global.selection < 1 then Global.selection = #option_stack[#option_stack] end;
            MESSAGEMAN:Broadcast("OptionsMenuChanged", { Player = param.Player, Direction = "Next", silent = false });
            return;
        end;
    end;

    if param.Input == "Cancel" or param.Input == "Back" then

        if currentoption then

            Global.selection = GetEntry(currentoption, option_stack[#option_stack]);
            currentoption = nil;
            MESSAGEMAN:Broadcast("Return", { Target = "OptionsMenu" });
            MESSAGEMAN:Broadcast("OptionsMenuChanged", { silent = true });
            return;

        elseif #option_stack > 1 then

            Global.selection = selection_stack[#selection_stack];
            table.remove(selection_stack, #selection_stack);
            table.remove(option_stack, #option_stack);
            MESSAGEMAN:Broadcast("Return", { Target = "OptionsMenu" });
            MESSAGEMAN:Broadcast("OptionsMenuChanged", { silent = true });
            return;

        else

            Global.level = 1; 
            Global.selection = 6; 
            Global.state = "MainMenu";  
            MESSAGEMAN:Broadcast("StateChanged"); 
            MESSAGEMAN:Broadcast("Return");

        end;
    end;
end;

--//================================================================

function SelectOptionsMenu()


    if currentoption ~= nil then

        currentoption = nil;
        MESSAGEMAN:Broadcast("OptionsMenuSelected");
        MESSAGEMAN:Broadcast("OptionsMenuChanged", { silent = true });

    else

        local topstack = option_stack[#option_stack][Global.selection];

        if topstack.Options and #topstack.Options > 0 then 
            table.insert(selection_stack, Global.selection);
            table.insert(option_stack, topstack.Options);
            Global.selection = 1;
            MESSAGEMAN:Broadcast("OptionsMenuSelected");
            MESSAGEMAN:Broadcast("OptionsMenuChanged", { silent = true });
            return;

        elseif topstack.Type then

            if topstack.Action then

                topstack.Action();
                MESSAGEMAN:Broadcast("OptionsMenuSelected");
                MESSAGEMAN:Broadcast("OptionsMenuChanged", { silent = true });
                THEMECONFIG:save("ProfileSlot_Invalid");

            elseif topstack.Type == "bool" then
                MESSAGEMAN:Broadcast("ChangeProperty", { Input = "Next", Option = topstack, silent = true });
                MESSAGEMAN:Broadcast("OptionsMenuSelected");
                MESSAGEMAN:Broadcast("OptionsMenuChanged", { silent = true });
                THEMECONFIG:save("ProfileSlot_Invalid");
            else
                currentoption = topstack;
                MESSAGEMAN:Broadcast("OptionsMenuSelected");
                MESSAGEMAN:Broadcast("OptionsMenuChanged", { silent = true });
                return;
            end

        else

            if #option_stack > 1 then

                Global.selection = selection_stack[#selection_stack];
                table.remove(selection_stack, #selection_stack);
                table.remove(option_stack, #option_stack);
                MESSAGEMAN:Broadcast("Return", { Target = "OptionsMenu" });
                MESSAGEMAN:Broadcast("OptionsMenuChanged", { silent = true });
                return;
            else
                Global.level = 1; 
                Global.selection = 7; 
                Global.state = "MainMenu";  
                MESSAGEMAN:Broadcast("StateChanged"); 
                MESSAGEMAN:Broadcast("Return");
                return;
            end

        end;

    end
end;

--//================================================================

-- panel
local window_w = 320;
local window_h = 182;

local itemspacing = 16;
local sidespacing = window_w/2-24;

local scroll_index = 1;
local scroller = setmetatable({disable_wrapping = true}, item_scroller_mt)

--//================================================================

local t = PropertyActor()..{
    InitCommand=cmd(CenterX;y,SCREEN_CENTER_Y-116;diffusealpha,0;zoom,0.8);
    StateChangedMessageCommand=function(self)
        self:stoptweening();
        self:decelerate(0.125);
        if Global.state == "OptionsMenu" then
            self:playcommand("Refresh");
            self:diffusealpha(1);
            self:zoom(1)
        else
            self:diffusealpha(0);
            self:zoom(0.8);
        end;
    end;

    OnCommand=cmd(playcommand,"Refresh");
    OptionsMenuChangedMessageCommand=cmd(playcommand,"Refresh");
    OptionsMenuSelectedMessageCommand=cmd(playcommand,"Refresh");
    PropertyChangedMessageCommand=cmd(playcommand,"Refresh");
    ReturnMessageCommand=function(self,param) if param and param.Target == "OptionsMenu" then self:playcommand("Refresh"); end end;
    RefreshCommand=function()
        local info = GetCurrentStackInfo(option_stack);
        scroller:set_info_set(info, Global.selection);
        MESSAGEMAN:Broadcast("ScrollerCursor", { Focused = ScrollerFocus(scroller, Global.selection, currentoption) });
        MESSAGEMAN:Broadcast("OptionMenuDescription", { Description = info and info[Global.selection] and info[Global.selection].Description or "" });
    end;
};

--//================================================================


t[#t+1] = Def.ActorFrame{
    InitCommand=cmd(y,(window_h/2) - 32);

    -- shadow
    LoadActor(THEME:GetPathG("","dim"))..{
        InitCommand=cmd(zoomto,window_w+4,72;y,window_h/2+2;diffuse,0,0,0,0.75;valign,0.75;croptop,0.75;fadeleft,0.15;faderight,0.15);
    },

    -- black outline
    Def.Quad{ InitCommand=cmd(zoomto,window_w+4,window_h+4;diffuse,0,0,0,0.75); },

    -- fill
    Def.Quad{ InitCommand=cmd(zoomto,window_w,window_h;diffuse,0.18,0.18,0.18,0.85;diffusebottomedge,0,0.15,0.25,0.9); },

    -- checker
    LoadActor(THEME:GetPathG("","checker"))..{
        InitCommand=cmd(zoomto,window_w,window_h;customtexturerect,0,0,window_w/4,window_h/4;diffuse,0,0,0,0.15);
    },

    --lines
    Def.Quad{ InitCommand=cmd(x,-window_w/2-0.5;zoomto,1,window_h+2;diffuse,0.5,0.5,0.5,0.5); },  
    Def.Quad{ InitCommand=cmd(x,window_w/2+0.5;zoomto,1,window_h+2;diffuse,0.5,0.5,0.5,0.5); },  
    Def.Quad{ InitCommand=cmd(y,-window_h/2-0.5;zoomto,window_w,1;diffuse,0.5,0.5,0.5,0.5); },  
    Def.Quad{ InitCommand=cmd(y,window_h/2+0.5;zoomto,window_w,1;diffuse,0.5,0.5,0.5,0.5); },  

    -- glow
    LoadActor(THEME:GetPathG("","glow"))..{
        InitCommand=cmd(zoomto,window_w*1.5,window_h*1.5;y,window_h/2;diffuse,BoostColor(HighlightColor(),0.5);diffusealpha,0.4;cropbottom,0.5;cropleft,0.165;cropright,0.165;diffusetopedge,0,0,0,0;blend,Blend.Add);
    },
    -- description area
    Def.Quad{ InitCommand=cmd(y,window_h/2;zoomto,window_w,36;diffuse,HighlightColor();diffusealpha,0.1;blend,Blend.Add;vertalign,bottom); },  
    Def.Quad{ InitCommand=cmd(y,-window_h/2;zoomto,window_w,30;diffuse,0.1,0.1,0.1,0.5;vertalign,top); },  

    -- title
    Def.BitmapText{
        Font = Fonts.options["Main"];
        InitCommand=cmd(y,window_h/2-18;zoom,0.39;diffuse,HighlightColor();wrapwidthpixels,(window_w-20)/self:GetZoom();vertspacing,-12);
        OptionMenuDescriptionMessageCommand=function(self,param)
            if not currentoption and param.Description ~= self:GetText() then
                self:stoptweening();
                self:cropright(1);
                self:settext(param and param.Description or "");
                self:linear(string.len(param and param.Description or "")/150);
                self:cropright(0);
            end;
        end;
    },

    -- title
    Def.BitmapText{
        Font = Fonts.options["Main"];
        Text = "Game Options";
        InitCommand=cmd(y,-window_h/2+10;vertalign,top;zoom,0.6;strokecolor,0.125,0.125,0.125,0.5);
    },
}

--//================================================================


local cursorzoom = 0.4;
local cursorspacing = (window_w+4) / 2;

t[#t+1] = Def.ActorFrame{
    OnCommand=cmd(y,itemspacing);
    StateChangedMessageCommand=function(self)
        if Global.state == "OptionsMenu" then 
            self:stoptweening();
            self:y(itemspacing);
            self:visible(true);
        else
            self:visible(false);
        end;
    end;
    ScrollerCursorMessageCommand=function(self,param)
        self:stoptweening();
        self:decelerate(0.15)
        if param and param.Focused then
            local target = param.Focused;
            self:y(target.prev_index * itemspacing);
        end;
    end;


    Def.Quad{
        InitCommand=cmd(diffuse,HighlightColor();fadeleft,0.1;faderight,0.1;diffusealpha,0);
        OnCommand=cmd(zoomto,window_w*0.95,1);
        ReturnMessageCommand=cmd(stoptweening;decelerate,0.15;diffusealpha,0);
        OptionsMenuSelectedMessageCommand=function(self,param)
            self:stoptweening();
            self:decelerate(0.15);
            if currentoption ~= nil then
                self:diffusealpha(0.25);
            else
                self:diffusealpha(0);
            end;
        end;
    },


    Def.ActorFrame{
        Name = "Normal";
        ReturnMessageCommand=cmd(playcommand,"Refresh");
        OptionsMenuSelectedMessageCommand=cmd(playcommand,"Refresh");
        RefreshCommand=function(self)
            self:stoptweening();
            self:decelerate(0.2);
            if currentoption == nil then
                self:diffuse(0.6,0.6,0.6,0.95);
            else
                self:diffuse(0.8,0.8,0.8,1);
            end;
        end;

        LoadActor(THEME:GetPathG("","miniarrow"))..{
            InitCommand=cmd(animate,false;x,-cursorspacing;zoom,cursorzoom;shadowlengthy,1);
        },  
        LoadActor(THEME:GetPathG("","miniarrow"))..{
            InitCommand=cmd(animate,false;x,cursorspacing;zoom,cursorzoom;zoomx,-cursorzoom;shadowlengthy,1);
        },
    },

    Def.ActorFrame{
        Name = "Glow";
        LoadActor(THEME:GetPathG("","miniarrow"))..{
            InitCommand=cmd(animate,false;setstate,1;x,-cursorspacing;zoom,cursorzoom;diffusealpha,0;blend,"BlendMode_Add");
            GlowCommand=cmd(stoptweening;diffusealpha,1;sleep,0.1;decelerate,0.2;diffusealpha,0);
            OptionsMenuChangedMessageCommand=function(self,param)
                if param and param.Direction == "Prev" and currentoption then
                    self:playcommand("Glow");
                end;
            end;
        },  
        LoadActor(THEME:GetPathG("","miniarrow"))..{
            InitCommand=cmd(animate,false;setstate,1;x,cursorspacing;zoom,cursorzoom;zoomx,-cursorzoom;diffusealpha,0;blend,"BlendMode_Add");
            GlowCommand=cmd(stoptweening;diffusealpha,1;sleep,0.1;decelerate,0.2;diffusealpha,0);
            OptionsMenuChangedMessageCommand=function(self,param)
                if param and param.Direction == "Next" and currentoption then
                    self:playcommand("Glow");
                end;
            end;
        },
    },
};

local fontsize = 0.45;
local sidespacing = (window_w/2)-20;
local scroller_actor = Def.ActorFrame{

    -- name
    Def.BitmapText{
        Name = "Name";
        Font = Fonts.options["Main"];
        InitCommand=cmd(horizalign,left;x,-sidespacing;zoom,fontsize;strokecolor,0.2,0.2,0.2,1);
        GainFocusCommand=cmd(stoptweening;decelerate,0.15;diffuse,HighlightColor();strokecolor,BoostColor(HighlightColor(),0.2));
        LoseFocusCommand=cmd(stoptweening;decelerate,0.15;diffuse,1,1,1,1;strokecolor,0.2,0.2,0.2,0.8);
        DisabledCommand=cmd(stoptweening;decelerate,0.15;diffuse,0.6,0.6,0.6,0.5;strokecolor,0.2,0.2,0.2,0.8);
    },

    -- value
    Def.BitmapText{
        Name = "Value";
        Font = Fonts.options["Main"];
        InitCommand=cmd(horizalign,right;x,sidespacing;zoom,fontsize;strokecolor,0.2,0.2,0.2,1);
        GainFocusCommand=cmd(stoptweening;decelerate,0.15;diffuse,HighlightColor();strokecolor,BoostColor(HighlightColor(),0.2));
        LoseFocusCommand=cmd(stoptweening;decelerate,0.15;diffuse,1,1,1,1;strokecolor,0.2,0.2,0.2,0.8);
        DisabledCommand=cmd(stoptweening;decelerate,0.15;diffuse,0.6,0.6,0.6,0.5;strokecolor,0.2,0.2,0.2,0.8);
    }, 

}

local scroller_item = OptionScrollerItem(16,scroller_actor);
t[#t+1] = scroller:create_actors("OptionsMenu", maxitems, scroller_item, 0, 0);


-- QUADS BG
local bg = Def.ActorFrame{
    InitCommand=cmd(CenterX;y,SCREEN_CENTER_Y-10.5;diffusealpha,0);
    StateChangedMessageCommand=function(self)
        self:stoptweening();
        self:decelerate(0.2);
        self:diffusealpha(Global.state == "OptionsMenu" and 1 or 0);
    end;

    Def.Quad{
        InitCommand=cmd(zoomto,_screen.h*(16/9)*(2/3),_screen.h;cropbottom,1/3;
            diffuse,BoostColor(Global.bgcolor,0.5);diffusebottomedge,BoostColor(AlphaColor(Global.bgcolor,0.5),0.5);fadeleft,0.25;faderight,0.25);
    },

    Def.Quad{
        InitCommand=cmd(zoomto,_screen.h*(16/9)*(2/3),_screen.h;diffuse,0.2,0.2,0.2,0.75;cropbottom,1/3;fadeleft,0.25;faderight,0.25);
    },

    LoadActor(THEME:GetPathG("","_pattern"))..{
        InitCommand=cmd(zoomto,_screen.h*(16/9)*(2/3),_screen.h;blend,Blend.Add;
            diffuse,BoostColor(HighlightColor(),0.125);diffusebottomedge,0.1,0.1,0.1,0.25;cropbottom,1/3;fadeleft,0.25;faderight,0.25;
                customtexturerect,0,0,(_screen.h*(16/9)) / 384 * 2.5 *(2/3),_screen.h / 384 * 2.5;texcoordvelocity,0,-0.075);
    },
};




return Def.ActorFrame{ bg, t };