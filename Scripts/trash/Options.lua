function DefaultOptionScrollerActor(fontsize,sidespacing)
    return Def.ActorFrame{
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
end;

function OptionScrollerItem(spacing, actor)
    local spacing = spacing or 16;
    local move_time = 0.15;
    local item_mt = {
        __index = {
            prev_index = -1;
            create_actors = function(self, params)
                self.name = params.name;
                self.spacing = spacing;
                self.move_time = move_time;
                if actor then 
                    return actor..{
                        InitCommand=function(subself)
                            self.container = subself;
                        end;
                    } 
                else 
                    return DefaultOptionScrollerActor(self,0.5,64)..{
                        InitCommand=function(subself)
                            self.container = subself;
                        end;
                    } 
                end;
            end;

            transform = function(self, item_index, num_items, is_focus)
                self.container:stoptweening();
                self.container:y(item_index * self.spacing);
                self.prev_index = item_index;
            end;

            set = function(self, info)
                if info and info.Name then
                    self.container:GetChild("Name"):settext(tostring(info.Name));
                else
                    self.container:GetChild("Name"):settext("");
                end;
                if info and info.Value then
                    self.container:GetChild("Value"):settext(tostring(info.Value));
                else
                    self.container:GetChild("Value"):settext("");
                end;
            end;
        }
    }
    return item_mt;
end;

--//================================================================

function GetCurrentStackInfo(stack, pn)
    if not stack then return {} end;

    local infotable = {};
    local cur = stack[#stack] 

    for i=1,#cur do
        local info = {}
        info.Name = cur[i].Name; 
        if cur[i].Type ~= "noteskin" then
            if cur[i].Type == "action" then
                info.Value = "";
            elseif cur[i].Options then
                info.Value = "";
            elseif cur[i].Type then
                local optiondata = { 
                    Option = cur[i],
                    Player = pn,
                }
                info.Value = GetConfig(optiondata);
            else
                info.Value = "";
            end;
        end;

        info = FormatOptionConfigs(info.Name, info.Value, pn);
        table.insert(infotable, info);
    end
    return infotable;
end

--//================================================================

function ScrollerFocus(s, index, currentoption)
    local focused = s:get_items_by_info_index(index)[1];
    for i=1,#s.items do
        if s.items[i] == focused then
            s.items[i].container:playcommand("GainFocus");
        else
            s.items[i].container:playcommand(currentoption ~= nil and "Disabled" or "LoseFocus");
        end;
    end;
    return focused;
end;

--//================================================================
--[[
        param.Input = "Prev", "Next"
        param.Player = PLAYER_1, PLAYER_2
        param.Option = {
            Type = "pref", "config", "options"
            Field = field name
            Config = config file (if needed)
            Default = "baz", 0, etc
            Choices = { true, false, "foo", "bar", 5 }
            Range = { Min = 0, Max = 10, Step = 1 }
        };
]]--
--//================================================================

function ConfigRange(conf, field, default, min, max, step)
    return {
        Name = field,
        Type = "range",
        Field = field, 
        Config = conf, 
        Default = default, 
        Range = { Min = min, Max = max, Step = step } ,
    }
end;

function ConfigChoices(conf, field, default, choices)
    return { 
        Name = field,
        Type = "choices",
        Field = field, 
        Config = conf, 
        Default = default, 
        Choices = choices,
    }
end;

function ConfigBool(conf, field, default, choices)
    return { 
        Name = field,
        Type = "bool",
        Field = field, 
        Config = conf, 
        Default = default, 
        Choices = choices or { true, false },
    }
end;

function ConfigNoteskin(name)
    return {
        Name = name,
        Field = name,
        Type = "noteskin",
    }
end;

function ConfigAction(label, func)
    return { 
        Name = label,
        Type = "action",
        Action = func,
    }
end;

function ConfigExit(label)
    return { 
        Name = label
    }
end;

function GetConfig(param)
    local pn = param and param.Player or nil;
    local conf = param.Option.Config;
    local field = param.Option.Field;
    local ret = get_element_by_path(conf:get_data(pn), field)
    return ((ret ~= nil or ret == 0) and ret) or false
end;

local function ChangeConfig(param)
    local pn = param.Player or nil;
    local conf = param.Option.Config;
    local field = param.Option.Field;
    local default = param.Option.Default;
    local current;

    current = GetConfig(param);
    if type(current) == "number" then
        current = math.round(current * 100000)/100000
    end;

    if param.Option.Choices and #param.Option.Choices > 1 then
        local choices = param.Option.Choices;
        local entry = GetEntry(current,choices);
        if param.Input == "Prev" then entry = entry-1; end;
        if param.Input == "Next" then entry = entry+1; end;
        if entry < 1 then entry = #choices; end;
        if entry > #choices then entry = 1; end;
        newvalue = choices[entry];

    elseif param.Option.Range then
        local min = param.Option.Range.Min;
        local max = param.Option.Range.Max;
        local step = param.Option.Range.Step;
        if param.Input == "Prev" then newvalue = current - step; end;
        if param.Input == "Next" then 
            if current < step and min >= 0 then newvalue = step else newvalue = current + step; end;
        end;
        newvalue = clamp(newvalue, min, max);
        newvalue = math.round(newvalue * 100000)/100000
    else
        LuaError("Invalid option choices/range");
    end;

    set_element_by_path(conf:get_data(pn), field, newvalue);
    conf:set_dirty(pn);
end;

--//================================================================

function PropertyActor()
    return Def.ActorFrame{
        ChangePropertyMessageCommand=function(self,param)
            if param and param.Input then
                ChangeConfig(param);
                MESSAGEMAN:Broadcast("PropertyChanged", param);
            end;
        end;
    };
end;
