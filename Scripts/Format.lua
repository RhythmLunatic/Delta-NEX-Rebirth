function JudgeToTNS(name)
    local tns = {
        ["Flawless"] = "TapNoteScore_W1",
        ["Perfect"] = "TapNoteScore_W2",
        ["Great"] = "TapNoteScore_W3",
        ["Good"] = "TapNoteScore_W4",
        ["Bad"] = "TapNoteScore_W5",
        ["Miss"] = "TapNoteScore_Miss",
    }

    return tns[name] or ""
end;

function TNSToJudge(tns)
    local names = {
        ["TapNoteScore_W1"] = "Flawless",
        ["TapNoteScore_W2"] = "Perfect",
        ["TapNoteScore_W3"] = "Great",
        ["TapNoteScore_W4"] = "Good",
        ["TapNoteScore_W5"] = "Bad",
        ["TapNoteScore_Miss"] = "Miss",
    }
    return names[tns] or ""
end;

function JudgmentLabels()
    return {
        { Key = "TapNoteScore_W1", Value = "Flawless", Lite = "FL" },
        { Key = "TapNoteScore_W2", Value = "Perfect", Lite = "PF" },
        { Key = "TapNoteScore_W3", Value = "Great", Lite = "GR" },
        { Key = "TapNoteScore_W4", Value = "Good", Lite = "GD" },
        { Key = "TapNoteScore_W5", Value = "Bad", Lite = "BD" },
        { Key = "TapNoteScore_Miss", Value = "Miss", Lite = "MS" },
        { Key = "HoldNoteScore_Held", Value = "Held", Lite = "OK" },
        { Key = "HoldNoteScore_LetGo", Value = "Let Go", Lite = "NG" },
    }
end;

function JudgmentGrade()
    return {
        { Label = JudgmentLabels()[1].Value,       Key = "W1",        Color = JudgmentColor("Flawless"),    Enabled = THEMECONFIG:get_data().AllowW1 },
        { Label = JudgmentLabels()[2].Value,       Key = "W2",        Color = JudgmentColor("Perfect"),     Enabled = true },
        { Label = JudgmentLabels()[3].Value,       Key = "W3",        Color = JudgmentColor("Great"),       Enabled = true },
        { Label = JudgmentLabels()[4].Value,       Key = "W4",        Color = JudgmentColor("Good"),        Enabled = true },
        { Label = JudgmentLabels()[5].Value,       Key = "W5",        Color = JudgmentColor("Bad"),         Enabled = true },
        { Label = JudgmentLabels()[6].Value,       Key = "Miss",      Color = JudgmentColor("Miss"),        Enabled = true },
        { Label = JudgmentLabels()[7].Value,       Key = "Held",      Color = color("#ffffff"),             Enabled = ShowHoldJudgments() },
        { Label = JudgmentLabels()[8].Value,       Key = "Let Go",    Color = color("#ffffff"),             Enabled = ShowHoldJudgments() },
        { Label = "Max Combo",                     Key = "Combo",     Color = color("#ffffff"),             Enabled = true },
        { Label = "Score",                         Key = "Score",     Color = color("#ffffff"),             Enabled = true },
    }
end;


--//================================================================

function PureType(steps)
    if steps then
        return string.gsub(ToEnumShortString(steps:GetStepsType()),Game().."_","");
    else
        return nil;
    end;
end;

--//================================================================

function FormatDP(f)
    return string.format("%.2f",f*100).."%";
end;

--//================================================================

function FormatMeter(s)
    if s >= 50 then
        return "??"
    elseif s <= 0 then
        return "--"
    else
        if s < 10 then
            return "0"..s;
        else
            return s;
        end
    end
end;

--//================================================================

function CapDigits(num, cap, digits)
    local len = string.len(num)
    local rep = clamp(digits - len, 0, digits)
    return string.rep(tostring(cap), rep) .. tostring(num);

end;

--//================================================================

function FormatDate(date)
    local temp = tostring(date);
    temp = string.gsub(temp,"-","/")
    temp = string.gsub(temp," ","   ")
    return temp
end

--//================================================================

function RawDate(date)
    local temp = tostring(date);
    temp = string.gsub(temp,"-","")
    temp = string.gsub(temp,":","")
    temp = string.gsub(temp," ","")
    return temp
end

--//================================================================

function FormatSpeed(value, stype)
    local mode = stype and string.lower(stype) or ""
    if mode == 3 or mode == "m" or mode == "maximum" then
        return "M"..value;
    elseif mode == 2 or mode == "c" or mode == "constant" then
        return "C"..value;
    elseif mode == 1 or mode == "x" or mode == "multiple" then
        return string.format("%.2f",value/100).."X";
    else
        LuaError("Invalid or nil speed mode");
        return value;
    end;

end;

--//================================================================

function UppercaseFirst(str)
    return (str:gsub("^%l", string.upper))
end

--//================================================================

function FormatGrade(grade)
    if grade == "Grade_Tier01" then return "AAAA"
    elseif grade == "Grade_Tier02" then return "AAA"
    elseif grade == "Grade_Tier03" then return "AA"
    elseif grade == "Grade_Tier04" then return "A"
    elseif grade == "Grade_Tier05" then return "B"
    elseif grade == "Grade_Tier06" then return "C"
    elseif grade == "Grade_Tier07" then return "D"
    elseif grade == "Grade_Tier08" then return "F"
    elseif grade == "Grade_Failed" then return "Failed"
    else return "--"
    end;
end;

--//================================================================

function FormatGradePIU(grade)
    if grade == "Grade_Tier01" then return "SS"
    elseif grade == "Grade_Tier02" then return "S+"
    elseif grade == "Grade_Tier03" then return "S"
    elseif grade == "Grade_Tier04" then return "A"
    elseif grade == "Grade_Tier05" then return "B"
    elseif grade == "Grade_Tier06" then return "C"
    elseif grade == "Grade_Tier07" then return "D"
    elseif grade == "Grade_Tier08" then return "F"
    elseif grade == "Grade_Failed" then return "Failed"
    else return "--"
    end;
end;

--//================================================================

function FormatAward(award)
    if award == "StageAward_FullComboW3" then return "Full Combo!"
    elseif award == "StageAward_SingleDigitW3" then return "Single Digit Greats!"
    elseif award == "StageAward_OneW3" then return "One Great!"
    elseif award == "StageAward_FullComboW2" then return "Full Perfect!"
    elseif award == "StageAward_SingleDigitW2" then return "Single Digit Perfects!"
    elseif award == "StageAward_OneW2" then return "One Perfect!"
    elseif award == "StageAward_FullComboW1" then return "Absolutely Flawless!"
    else return ""
    end;
end;

--//================================================================

function FormatFailType(fail)
    if fail == "FailType_Immediate" then return "Immediate";
    elseif fail == "FailType_ImmediateContinue" then return "Delayed"
    elseif fail == "FailType_EndOfSong" then return "End of song"
    elseif fail == "FailType_Off" then return "Off";
    else return "" end;
end;

--//================================================================

function FormatSpeedType(t)
    if t == "maximum" then return "Automatic";
    elseif t == "constant" then return "Constant"
    elseif t == "multiple" then return "Multiple"
    else return "" end;
end;

--//================================================================

local function dict_bool(val)
    return val and "On" or "Off";
end;

local function dict_reverse(val)
    return val == -1 and "On" or "Off";
end;

local function dict_float(val, suf)
    local suffix = suf or ""
    if tonumber(val) then val = math.round(tonumber(val)*10000)/10000 end
    if string.len(tostring(val)) == 1 then return tostring(val)..".00"..suffix end;
    if string.len(tostring(val)) == 3 then return tostring(val).."0"..suffix end;
    if string.len(tostring(val)) == 4 then return tostring(val)..suffix end;
end;

local dict_fail = {
    ["off"] = "Disabled",
    ["delayed"] = "Delayed",
    ["immediate"] = "Instant"
}

local dict_timing = {
    "1 (Easiest)",
    "2 (Easy)",
    "3 (Easier)",
    "4 (Normal)",
    "5 (Medium)",
    "6 (Hard)",
    "7 (Very Hard)",
    "8 (Hardest)",
    "9 (Justice)",
}

local dict_life = {
    "1 (Easiest)",
    "2 (Easy)",
    "3 (Easier)",
    "4 (Normal)",
    "5 (Hard)",
    "6 (Very Hard)",
    "7 (Hardest)",
}

function FormatOptionConfigs(str, val, pn)
    local prefs = pn and notefield_prefs_config:get_data(pn)

    local format = {
        ["BGBrightness"]        = tostring(val).."%",
        ["DefaultBG"]           = dict_bool(val),
        ["DisableBGA"]          = dict_bool(val),
        ["CenterPlayer"]        = dict_bool(val),
        ["MusicRate"]           = dict_float(val,"x"),
        ["FailType"]            = dict_fail[val],
        ["FailMissCombo"]       = dict_bool(val),
        ["AllowW1"]             = dict_bool(val),
        ["TimingDifficulty"]    = dict_timing[val],
        ["LifeDifficulty"]      = dict_life[val],

        ["speed_mod"]           = prefs and FormatSpeed(prefs.speed_mod, prefs.speed_type) or val,
        ["speed_type"]          = prefs and FormatSpeedType(prefs.speed_type) or val,
        ["hidden"]              = dict_bool(val),
        ["sudden"]              = dict_bool(val),
        ["glow_during_fade"]    = dict_bool(val),
        ["ReverseJudgment"]     = dict_bool(val),
        ["reverse"]             = dict_reverse(val),

        ["zoom"]                = prefs and (prefs.zoom * 100).."%" or val,
        ["zoom_x"]              = prefs and (prefs.zoom_x * 100).."%" or val,
        ["zoom_y"]              = prefs and (prefs.zoom_y * 100).."%" or val,
        ["zoom_z"]              = prefs and (prefs.zoom_z * 100).."%" or val,
        ["rotation_x"]          = tostring(val).."°",
        ["rotation_y"]          = tostring(val).."°",
        ["rotation_z"]          = tostring(val).."°",

        ["ScreenFilter"]        = tostring(val) == "0" and "Off" or tostring(val).."%",
        ["ShowEarlyLate"]       = dict_bool(val),
        ["ShowJudgmentList"]    = dict_bool(val),
        ["ShowOffsetMeter"]     = dict_bool(val),
        ["ShowPacemaker"]       = UppercaseFirst(tostring(val)),
    }

    local a = THEME:HasString("Configs", str) and THEME:GetString("Configs", str) or str;
    local b = format[str] or val;
    local c = THEME:HasString("ConfigsDescriptions", str) and THEME:GetString("ConfigsDescriptions", str) or "";
    return { Name = a, Value = b, Description = c }
end;
