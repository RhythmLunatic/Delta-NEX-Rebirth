function PIUScoring(pn, param, beat)
    local judge_table = {
        ["TapNoteScore_W1"]                 = { Bonus = true,   Value =  1000 }, -- superb
        ["TapNoteScore_W2"]                 = { Bonus = true,   Value =  1000 }, -- perfect
        ["TapNoteScore_W3"]                 = { Bonus = true,   Value =   500 }, -- great
        ["TapNoteScore_W4"]                 = { Bonus = false,  Value =   100 }, -- good
        ["TapNoteScore_W5"]                 = { Bonus = false,  Value =  -200 }, -- bad
        ["TapNoteScore_Miss"]               = { Bonus = false,  Value =  -500 }, -- miss
        ["TapNoteScore_CheckpointHit"]      = { Bonus = true,   Value =     0 }, -- superb or perfect
        ["TapNoteScore_CheckpointMiss"]     = { Bonus = false,  Value =  -300 }, -- miss
        ["TapNoteScore_HitMine"]            = { Bonus = false,  Value =  -500 }, -- mine
    }

    if not judge_table[param.TapNoteScore] then return 0 end;
    local superb_timing = PREFSMAN:GetPreference("AllowW1") ~= "AllowW1_Never";
    judge_table["TapNoteScore_CheckpointHit"] = superb_timing and judge_table["TapNoteScore_W1"] or judge_table["TapNoteScore_W2"];

    local steps = Global.pncursteps[pn] or GAMESTATE:GetCurrentSteps(pn);
    local combo = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetCurrentCombo();

    local note_base_value = 0;
    local note_combo_bonus = 0;
    local note_row_bonus = 0;

    local notes_in_row = 0;
    if param.Notes then
        for _ in pairs(param.Notes) do
            notes_in_row = notes_in_row + 1;
        end;
    end;

    local note_level_multiplier = steps:GetMeter() > 10 and steps:GetMeter()/10 or 1;
    local note_double_multiplier = PureType(steps) == "Double" and 1.2 or 1;

    ---

    if judge_table[param.TapNoteScore] then
        note_base_value = judge_table[param.TapNoteScore].Value;
        
        if judge_table[param.TapNoteScore].Bonus then
            if notes_in_row > 2 then
                note_row_bonus = (1000 * (notes_in_row-2));
            end;
            if combo + BeatToCombo(beat, pn)[1] >= 51 then
                note_combo_bonus = 1000;
            end;
        end;

    end;

    note_final_value = ( note_base_value + note_combo_bonus + note_row_bonus ) * note_level_multiplier * note_double_multiplier;
    --SCREENMAN:SystemMessage(notes_in_row.."\n"..note_final_value.."\nScore: "..Global.piuscoring[pn].."\nCombo: "..combo); 
    --SCREENMAN:SystemMessage(Global.piuscoring[PLAYER_1].."\n"..Global.piuscoring[PLAYER_2]); 
    return note_final_value;
end;

function PIUGrading(pn)
    local curstats = STATSMAN:GetCurStageStats();
    local pss = curstats:GetPlayerStageStats(pn);
    local curdp = pss:GetActualDancePoints();
    local maxdp = pss:GetCurrentPossibleDancePoints();
    local dp = curdp / clamp(maxdp,1,maxdp);

    local misscount = pss:GetTapNoteScores('TapNoteScore_Miss') + pss:GetTapNoteScores('TapNoteScore_CheckpointMiss') + pss:GetHoldNoteScores('HoldNoteScore_MissedHold');

    if not pss:GetFailed() then
        if pss:FullComboOfScore('TapNoteScore_W1') then return "Grade_Tier01" -- SSS
        elseif pss:FullComboOfScore('TapNoteScore_W2') then return "Grade_Tier01" -- SS
        elseif pss:FullComboOfScore('TapNoteScore_W3') then return "Grade_Tier02" -- gold S
        elseif misscount == 0 and dp >= 0.75 then return "Grade_Tier03" -- silver S
        elseif dp >= 0.8 then return "Grade_Tier04" -- A
        elseif dp >= 0.7 then return "Grade_Tier05" -- B
        elseif dp >= 0.6 then return "Grade_Tier06" -- C
        elseif dp >= 0.5 then return "Grade_Tier07" -- D
        else return "Grade_Tier08" -- F
        end;
    end;
    return "Grade_Failed";
end;

function PIUHighScoreGrade(hs)
    if hs:GetGrade() == "Grade_Failed" then return "Grade_Failed" end
    local dp = hs:GetPercentDP()
    local misscount = GetMissCount(hs);

    if misscount == 0 and dp >= 0.75 then 
        if hs:GetTapNoteScore(JudgeToTNS("Bad")) > 0 then return "Grade_Tier03"
        elseif hs:GetTapNoteScore(JudgeToTNS("Good")) > 0 then return "Grade_Tier03"
        elseif hs:GetTapNoteScore(JudgeToTNS("Great")) > 0 then return "Grade_Tier02"
        elseif hs:GetTapNoteScore(JudgeToTNS("Perfect")) > 0 then return "Grade_Tier01"
        else return "Grade_Tier01" end
    else
        if dp >= 0.8 then return "Grade_Tier04"
        elseif dp >= 0.7 then return "Grade_Tier05"
        elseif dp >= 0.6 then return "Grade_Tier06"
        elseif dp >= 0.5 then return "Grade_Tier07"
        else return "Grade_Tier08" end
    end;

end;

-- return the scoring rounded down + the final bonuses 
function PostProcessPIUScores(pn)
    local final_score = Global.piuscoring[pn];
    local grade_bonuses = {
        ["Grade_Tier01"] = 300000, -- SS
        ["Grade_Tier02"] = 150000, -- gold S
        ["Grade_Tier03"] = 100000, -- silver S
    };

    local grade = PIUGrading(pn);
    if grade_bonuses[grade] then
        final_score = final_score + grade_bonuses[grade];
    end;

    final_score = final_score - Global.piuscoring[pn] % 100;
    return final_score;
end;

-- get the combo value at a certain beat for the current steps
function BeatToCombo(curbeat, pn)
    local multiplier = { 1, 1 };
    local player = pn or GAMESTATE:GetMasterPlayerNumber();
    local timing = GAMESTATE:GetCurrentSteps(player):GetTimingData(true);
    local combos = timing:GetCombos(true);

    if timing and combos and #combos > 1 then
        for i=1,#combos do
            local beat = combos[i][1];
            local limit = math.huge;

            if i+1 <= #combos then 
                limit = combos[i+1][1]; 
            end;

            if(curbeat >= beat and curbeat < limit) then
                multiplier = { combos[i][2], combos[i][3] };
            end;
        end;
    end;

    return multiplier;
end;