function GetMissCount(score)
    return score:GetTapNoteScore("TapNoteScore_Miss") + 
    score:GetTapNoteScore("TapNoteScore_CheckpointMiss") +
    score:GetHoldNoteScore("HoldNoteScore_MissedHold")
end;

--//================================================================

function SortScoresByMissCount(a,b)
    if GetMissCount(a) ~= GetMissCount(b) then
        return GetMissCount(a) > GetMissCount(b)
    else
        return SortScoresByDP(a,b)
    end;
end;

--//================================================================

function SortScoresByMaxCombo(a,b)
    if a:GetMaxCombo() ~= b:GetMaxCombo() then
        return a:GetMaxCombo() > b:GetMaxCombo()
    else
        return SortScoresByDP(a,b)
    end;
end;

--//================================================================

function SortScoresByDP(a,b)
    if a:GetPercentDP() ~= b:GetPercentDP() then
        return a:GetPercentDP() > b:GetPercentDP()
    else
        return SortScoresByDate(a,b)
    end;
end;

--//================================================================

function SortScoresByDate(a,b)
    return tonumber(RawDate(a:GetDate())) > tonumber(RawDate(b:GetDate()))
end;

--//================================================================

function GetMachineAndPlayerProfile(int, pn)
    if int == 1 then
        return PROFILEMAN:GetMachineProfile()
    else
        return PROFILEMAN:GetProfile(pn)
    end;
end;

--//================================================================

function GetHighScoreValue(hs, field)
    if not hs then return 0 end

    local w1 = THEMECONFIG:get_data().AllowW1;

    if field == "TapNoteScore_W1" or field == "Flawless" then
        return w1 and (hs:GetTapNoteScore("TapNoteScore_W1") + hs:GetTapNoteScore("TapNoteScore_CheckpointHit")) or 0
    elseif field == "TapNoteScore_W2" or field == "Perfect" then
        return w1 and hs:GetTapNoteScore("TapNoteScore_W2") or (hs:GetTapNoteScore("TapNoteScore_W1") + hs:GetTapNoteScore("TapNoteScore_W2") + hs:GetTapNoteScore("TapNoteScore_CheckpointHit"))
    elseif field == "TapNoteScore_W3" or field == "Great" then
        return hs:GetTapNoteScore("TapNoteScore_W3")
    elseif field == "TapNoteScore_W4" or field == "Good" then
        return hs:GetTapNoteScore("TapNoteScore_W4")
    elseif field == "TapNoteScore_W5" or field == "Bad" then
        return hs:GetTapNoteScore("TapNoteScore_W5")
    elseif field == "TapNoteScore_Miss" or field == "Miss" then
        return hs:GetTapNoteScore("TapNoteScore_Miss") + hs:GetTapNoteScore("TapNoteScore_CheckpointMiss") + hs:GetHoldNoteScore("HoldNoteScore_MissedHold")
    elseif (field == "HoldNoteScore_Held" or field == "Held") and ShowHoldJudgments() then
        return hs:GetHoldNoteScore("HoldNoteScore_Held")
    elseif (field == "HoldNoteScore_LetGo" or field == "Let Go") and ShowHoldJudgments() then
        return hs:GetHoldNoteScore("HoldNoteScore_LetGo")
    elseif string.find(string.lower(field),"combo") then
        return hs:GetMaxCombo();
    else
        return 0;
    end

end;

--//================================================================

function FetchScores(pn, profile, sort)
    local song = Global.song or GAMESTATE:GetCurrentSong();
    local steps = Global.pncursteps[pn] or GAMESTATE:GetCurrentSteps(pn);

    local _list = {};
    local _scores = {};
    local _best = nil;

    if steps then 
        _list = profile:GetHighScoreListIfExists(song, steps)

        if _list then 
            _scores = _list:GetHighScores();

            if _scores and #_scores>0 then 

                if sort == "dp" then table.sort(_scores,function(a,b) return SortScoresByDP(a,b) end)
                elseif sort == "misscount" then table.sort(_scores,function(a,b) return SortScoresByMissCount(a,b) end)
                elseif sort == "maxcombo" then table.sort(_scores,function(a,b) return SortScoresByMaxCombo(a,b) end)
                elseif sort == "date" then table.sort(_scores,function(a,b) return SortScoresByDate(a,b) end)
                end

                _best = _scores[1];
                return _best;
            else
                --no scores on the scores list
                return nil
            end
        else
            --no scores list available
            return nil      
        end;
    else
        --invalid steps
        return nil
    end;
end;

--//================================================================

function GetTopScoreForProfile(song,steps,profile)
    local _list = {};
    local _scores = {};
    local _best = nil;

    if steps then 
        _list = profile:GetHighScoreListIfExists(song, steps)

        if _list then 
            _scores = _list:GetHighScores();

            if _scores and #_scores>0 then 
                table.sort(_scores,function(a,b) return SortScoresByDP(a,b) end)
                _best = _scores[1];
                return _best;
            else
                --no scores on the scores list
                return nil
            end
        else
            --no scores list available
            return nil      
        end;
    else
        --invalid steps
        return nil
    end;

end;

--//================================================================

function GetLatestScore(song,steps,profile)

    local machine = PROFILEMAN:GetMachineProfile();

    local machine_list = {}
    local machine_scores = {};

    local profile_list = {};
    local profile_scores = {};

    local final_scores = {};
    local final_latest = nil;


    if steps then 
        machine_list = machine:GetHighScoreListIfExists(song, steps)
        profile_list = profile:GetHighScoreListIfExists(song, steps)

        --ADDING MACHINE SCORES TO FINAL LIST
        if machine_list then 
            machine_scores = machine_list:GetHighScores();

            if machine_scores and #machine_scores>0 then 
                for a=1,#machine_scores do
                    table.insert(final_scores, machine_scores[a]);
                end;
            else
                --no scores in the scores list, skipping
            end
        else
            --no scores list available, skipping.
        end;

        --ADDING PROFILE SCORES TO FINAL LIST
        if profile_list then 
            profile_scores = profile_list:GetHighScores();

            if profile_scores and #profile_scores>0 then 
                for b=1,#profile_scores do
                    table.insert(final_scores, profile_scores[b]);
                end;
            else
                --no scores in the scores list, skipping
            end
        else
            --no scores list available, skipping.
        end;

        --FINAL LIST DONE, HOW DO IT SORT???? LOL
        if final_scores and #final_scores>0 then
            table.sort(final_scores,function(a,b) return SortScoresByDate(a,b) end) --jk
            return final_scores[1]; --the champion
        else
            --no scores found at all, exiting
            return nil
        end;

    else
        --invalid steps
        return nil
    end;

end;

---//================================================================