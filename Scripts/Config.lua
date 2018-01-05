--//================================================================

local theme_conf_default = {
    BGBrightness = 100,
    DefaultBG = false,
    DisableBGA = false,
    CenterPlayer = false,
    MusicRate = 1.0,
    FailType = "delayed",
    FailMissCombo = true,
    AllowW1 = true,
    TimingDifficulty = 4,
    LifeDifficulty = 4,
}

--[[THEMECONFIG = create_lua_config{
    name = "THEMECONFIG", 
    file = "theme_config.lua",
    default = theme_conf_default,
}

THEMECONFIG:load("ProfileSlot_Invalid");
THEMECONFIG:set_dirty("ProfileSlot_Invalid");
THEMECONFIG:save("ProfileSlot_Invalid");]]

--//================================================================

function ResetThemeSettings()
    local tconf = THEMECONFIG:get_data("ProfileSlot_Invalid");
    tconf.BGBrightness = 100;
    tconf.DefaultBackground = false;
    tconf.DisableBGA = false;
    tconf.CenterPlayer = false;
    tconf.MusicRate = 1.0;
    tconf.FailType = "delayed";
    tconf.FailMissCombo = true;
    tconf.AllowW1 = true;
    tconf.TimingDifficulty = 4;
    tconf.LifeDifficulty = 4;
    THEMECONFIG:save();
end;

--//================================================================

function ResetDisplayOptions()
    local tconf = THEMECONFIG:get_data("ProfileSlot_Invalid");
    tconf.BGBrightness = 100;
    tconf.DefaultBG = false;
    tconf.DisableBGA = false;
    tconf.CenterPlayer = false;
    THEMECONFIG:save();
end;

function ResetSongOptions()
    local tconf = THEMECONFIG:get_data("ProfileSlot_Invalid");
    tconf.MusicRate = 1.0;
    tconf.FailType = "delayed";
    tconf.FailMissCombo = true;
    THEMECONFIG:save();
end;

function ResetJudgmentOptions()
    local tconf = THEMECONFIG:get_data("ProfileSlot_Invalid");
    tconf.AllowW1 = true;
    tconf.TimingDifficulty = 4;
    tconf.LifeDifficulty = 4;
    THEMECONFIG:save();
end;

--//================================================================

function ApplyThemeSettings()
    local tconf = THEMECONFIG:get_data("ProfileSlot_Invalid");

    tconf.BGBrightness      = clamp(tconf.BGBrightness,0,100);
    tconf.MusicRate         = clamp(tconf.MusicRate,0.5,2.0);
    tconf.TimingDifficulty  = clamp(tconf.TimingDifficulty,1,9);
    tconf.LifeDifficulty    = clamp(tconf.LifeDifficulty,1,7);
    if string.lower(tconf.FailType) ~= "delayed" and
       string.lower(tconf.FailType) ~= "immediate" and
       string.lower(tconf.FailType) ~= "off" then
       tconf.FailType = "delayed";
    end;

    -------------------------------------------------------------------------------------------------------
    local timing_mapping = { 1.5, 1.33, 1.16, 1.00, 0.84, 0.66, 0.50, 0.33, 0.20 };
    local life_mapping = { 1.6, 1.40, 1.20, 1.00, 0.80, 0.60, 0.40 };

    PREFSMAN:SetPreference("BGBrightness",          tconf.DefaultBG and 0 or math.round(tconf.BGBrightness*100)/10000);
    PREFSMAN:SetPreference("Center1Player",         tconf.CenterPlayer);
    PREFSMAN:SetPreference("TimingWindowScale",     timing_mapping[tconf.TimingDifficulty] );
    PREFSMAN:SetPreference("LifeDifficultyScale",   life_mapping[tconf.LifeDifficulty] );
    --PREFSMAN:SetPreference("AllowW1",               tconf.AllowW1 and "AllowW1_Everywhere" or "AllowW1_Never" );

    -------------------------------------------------------------------------------------------------------
    local sops= GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred");
    sops:MusicRate(tconf.MusicRate);
    sops:StaticBackground(tconf.DisableBGA);
    GAMESTATE:ApplyPreferredSongOptionsToOtherLevels();

    -------------------------------------------------------------------------------------------------------
    local fail_mapping  = {
        ["immediate"]   = "FailType_Immediate",
        ["delayed"]     = "FailType_ImmediateContinue",
        ["off"]         = "FailType_Off",
    };

    for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
        local pstate = GAMESTATE:GetPlayerState(pn);
        local plops = pstate:get_player_options_no_defect("ModsLevel_Preferred");
        plops:FailSetting(fail_mapping[string.lower(tconf.FailType)])
        pstate:ApplyPreferredOptionsToOtherLevels();
    end;

end;

--//================================================================

local player_conf_default= {
    ShowOffsetMeter = false,
    ShowEarlyLate = false,
    ShowJudgmentList = false,
    ShowPacemaker = "off",
    ReverseJudgment = false,
    ScreenFilter = 0,
    SpeedModifier = 25,
}

NOTESCONFIG = notefield_prefs_config;
PLAYERCONFIG = create_lua_config{
    name = "PLAYERCONFIG", 
    file = "player_config.lua",
    default = player_conf_default,
}

add_standard_lua_config_save_load_hooks(PLAYERCONFIG);
set_notefield_default_yoffset(170)

--//================================================================

pacemaker_targets = {
    "off",
    "no target", 
    "best score", 
    "grade: D", 
    "grade: C", 
    "grade: B", 
    "grade: A", 
    "grade: AA", 
    "grade: AAA"
}

--//================================================================

function ResetPlayerSpeed(pn)
    local nconf = NOTESCONFIG:get_data(pn);
    local pconf = PLAYERCONFIG:get_data(pn);
    nconf.speed_mod = 250;
    pconf.SpeedModifier = 25;
    nconf.speed_type = "maximum";

    NOTESCONFIG:set_dirty(pn);
    PLAYERCONFIG:set_dirty(pn);
end;

function ResetPlayerZoom(pn)
    local nconf = NOTESCONFIG:get_data(pn);
    nconf.zoom = 1;
    nconf.zoom_x = 1;
    nconf.zoom_y = 1;
    nconf.zoom_z = 1;

    NOTESCONFIG:set_dirty(pn);
end;

function ResetPlayerRotation(pn)
    local nconf = NOTESCONFIG:get_data(pn);
    nconf.rotation_x = 0;
    nconf.rotation_y = 0;
    nconf.rotation_z = 0;

    NOTESCONFIG:set_dirty(pn);
end;

function ResetPlayerView(pn)
    local nconf = NOTESCONFIG:get_data(pn);
    nconf.reverse = 1;
    nconf.yoffset = 170;
    nconf.fov = 60;

    NOTESCONFIG:set_dirty(pn);
end;

function ResetPlayerDisplay(pn)
    local nconf = NOTESCONFIG:get_data(pn);
    local pconf = PLAYERCONFIG:get_data(pn);
    nconf.hidden = false;
    nconf.sudden = false;
    nconf.hidden_offset = 120;
    nconf.sudden_offset = 190;
    nconf.fade_distance = 40;
    nconf.glow_during_fade = true;
    pconf.ReverseJudgment = false;

    NOTESCONFIG:set_dirty(pn);
    PLAYERCONFIG:set_dirty(pn);
end;

function ResetPlayerTransform(pn)
    ResetPlayerZoom(pn)
    ResetPlayerRotation(pn)
    ResetPlayerView(pn)
end;


