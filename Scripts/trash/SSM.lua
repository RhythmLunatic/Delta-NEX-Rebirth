--//================================================================    

function SetSSM()
    if IsRoutine() then
        GAMESTATE:UnjoinPlayer(OtherPlayer[Global.master]);
        GAMESTATE:SetCurrentStyle("single");
    end;

    Global.pnskin[PLAYER_1] = -1;
    Global.pnskin[PLAYER_2] = -1;

    Global.master = GAMESTATE:GetMasterPlayerNumber();
    Global.mastersteps = Global.pncursteps[Global.master];
    Global.selection = SetWheelSelection()
    Global.steps = FilterSteps(Global.song);

    for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
        --if not Global.pncursteps[pn] and SideJoined(pn) then
            local entry = GetEntry(GAMESTATE:GetCurrentSteps(pn), Global.steps);
            if Global.pncursteps[pn] ~= Global.steps[Global.pnsteps[pn]] then
                Global.pnsteps[pn] = entry;
                Global.pncursteps[pn] = Global.steps[Global.pnsteps[pn]];
                --GAMESTATE:SetCurrentSteps(pn, Global.pncursteps[pn]);
            end;
        --end
    end;

    FixStyleForSteps(Global.pncursteps[Global.master]);

    MESSAGEMAN:Broadcast("BuildMusicList", { first = true });
    MESSAGEMAN:Broadcast("StepsChanged", { silent = true });
    
    Global.level = 1;
    Global.confirm[PLAYER_1] = 0;
    Global.confirm[PLAYER_2] = 0;

    Global.selection = 4; 
    Global.prevstate = "MainMenu"
    Global.state = "MainMenu"
    Global.blocksteps = true;
    Global.lockinput = true;
    Global.disqualify = false;
    
    MESSAGEMAN:Broadcast("StateChanged");
end;

--//================================================================    

function SetGroups()
    Global.allgroups = SONGMAN:GetSongGroupNames();
    Global.allgroups = FilterGroups(Global.allgroups);

    local pref = GAMESTATE:GetPreferredSong()
    local first = Global.allgroups[1]["Songs"];
    local prefgroup = -1;

    if pref then
        for i=1,#Global.allgroups do
            if Global.allgroups[i]["Name"] == pref:GetGroupName() then prefgroup = i; end;
        end;

        if #FilterSteps(pref) > 0 then
            Global.songlist = Global.allgroups[prefgroup]["Songs"];
            Global.songgroup = pref:GetGroupName();
            Global.song = pref;

        elseif prefgroup > 0 then
            Global.songlist = Global.allgroups[prefgroup]["Songs"];
            Global.songgroup = Global.allgroups[prefgroup]["Name"];
            Global.song = Global.allgroups[prefgroup]["Songs"][1];
        else
            Global.songlist = first;
            Global.songgroup = first[1]:GetGroupName();
            Global.song = first[SetWheelSelection()];

        end;
    else
        Global.songlist = Global.allgroups[1]["Songs"]
        Global.songgroup = Global.allgroups[1]["Name"]
        Global.song = Global.allgroups[1]["Songs"][1]
    end;

    GAMESTATE:SetCurrentSong(Global.song);
    --MESSAGEMAN:Broadcast("SongGroup"); 
end;

--//================================================================

function FilterGroups(stringlist)
    local filter = {};
    local numsongs = {};

    for i=1, math.min(#stringlist,SONGMAN:GetNumSongGroups()) do
        local songs = {};
        songs = SONGMAN:GetSongsInGroup(stringlist[i])
        songs = FilterSongList(songs);

        if #songs > 0 then 
            filter[#filter+1] = { 
                ["Name"] = stringlist[i],
                ["Songs"] = songs, 
                ["Count"] = #songs, 
            }; 
        end;

    end;

    return filter;
end;

--//================================================================

function FilterSongList(songlist)
    local filter = {};
    local itemsteps = {};
    
    for i=1,#songlist do
        itemsteps = FilterSteps(songlist[i]);
        if #itemsteps > 0 then
            filter[#filter+1] = songlist[i];
        end;
    end;
    if #filter == 0 then filter = {} end;
    return filter
end;

--//================================================================

function SetWheelSelection()
    local selection = 1;

    if Global.song then
        for i=1,#Global.songlist do
            if Global.song == Global.songlist[i] then
                selection = i;
                break
            end
        end;
        Global.song = Global.songlist[selection];
    else
        Global.song = Global.songlist[1];
    end

    return selection;
end;

--//================================================================

function SetWheelSteps()
    Global.steps = FilterSteps(Global.song);
    for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
        Global.pnsteps[pn] = 1;
        Global.pncursteps[pn] = Global.steps[1];
    end;
end;

--//================================================================

function GetWheelSteps()
    Global.steps = FilterSteps(Global.song);
    for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
        Global.pnsteps[pn] = GetEntry(Global.pncursteps[pn], Global.steps);
        Global.pncursteps[pn] = Global.steps[Global.pnsteps[pn]];
    end;
end;

--//================================================================

function FilterSteps(song)
    local filter = {};
    local steplist = StepsList(song);
    if steplist then
        for i=1,#steplist do
            if steplist[i] and steplist[i]:GetMeter() > 0 then
                filter[#filter+1] = steplist[i]
            end
        end
        table.sort(filter,function(a,b) return SortCharts(a,b) end)
        return filter
    else
        return {};
    end;
end
--//================================================================


function FixStyleForSteps(steps)
    if steps then
        local st = ToEnumShortString(steps:GetStepsType());
        if st == "Double" then 
            GAMESTATE:SetCurrentStyle("single");
        --elseif st == "Routine" then 
        --    GAMESTATE:SetCurrentStyle("single");
        else 
            if GAMESTATE:GetNumSidesJoined() == 2 then
                GAMESTATE:SetCurrentStyle("versus");
            else
                GAMESTATE:SetCurrentStyle("single");
            end;
        end;
    end;
end;

--//================================================================

function SortCharts(a,b)
    local bST = StepsType:Compare(a:GetStepsType(),b:GetStepsType()) < 0
    if a:GetStepsType() == b:GetStepsType() then
        return a:GetMeter() < b:GetMeter()
    else
        return bST
    end;
end

--//================================================================

function StepsList(song)

    if song then
        local allsteps = song:GetAllSteps();
        local steps = {};

        for i=1,#allsteps do
            if EligibleSteps(allsteps[i]) then
                steps[#steps+1] = allsteps[i];
            end;
        end;

        table.sort(steps,function(a,b) return SortCharts(a,b) end)
        return steps;
    else
        return {};
    end

end;

--//================================================================

function EligibleSteps(steps)
    local st = steps:GetStepsType();
    local sides = GAMESTATE:GetNumSidesJoined();

    if not string.find(st, Game()) then return false end;

    local pads_required = {
        ["StepsType_Dance_Double"]      = 2,
        ["StepsType_Dance_Couple"]      = 2,
        ["StepsType_Dance_Routine"]     = 2,
        ["StepsType_Pump_Halfdouble"]   = 2,
        ["StepsType_Pump_Double"]       = 2,
        ["StepsType_Pump_Couple"]       = 2,
        ["StepsType_Pump_Routine"]      = 2,
        ["StepsType_Maniax_Double"]     = 2,
        ["StepsType_Techno_Double4"]    = 2,
        ["StepsType_Techno_Double5"]    = 2,
        ["StepsType_Techno_Double8"]    = 2,
    };

    if pads_required[st] and pads_required[st] == sides then return false end;
    return true;
end;

--//================================================================

function TotalNotes(steps,pn)
    local player = pn;
    if not pn then player = Global.master or GAMESTATE:GetMasterPlayerNumber(); end;

    local song = Global.song or GAMESTATE:GetCurrentSong();
        if song then
            local taps = steps:GetRadarValues(player):GetValue('RadarCategory_TapsAndHolds');
            local holds = steps:GetRadarValues(player):GetValue('RadarCategory_Holds');
            local jumps = steps:GetRadarValues(player):GetValue('RadarCategory_Jumps');
            local hands = steps:GetRadarValues(player):GetValue('RadarCategory_Hands');
            local rolls = steps:GetRadarValues(player):GetValue('RadarCategory_Rolls');
            local lifts = steps:GetRadarValues(player):GetValue('RadarCategory_Lifts');

        return (taps+holds+jumps+hands+rolls+lifts)
        end;
end;

--//================================================================

function AvgNotesSec(steps,pn)
    local song = Global.song;
    if song then

        local length = song:GetStepsSeconds()
        --local stream = steps:GetRadarValues(pn):GetValue('RadarCategory_Stream');
        --local avg = math.ceil(((TotalNotes(steps,pn)/length)*stream)*100)/100;
        local total = TotalNotes(steps,pn)
        local avg = math.ceil((TotalNotes(steps,pn)/length)*100)/100;

        return avg;

    end;
end;

--//================================================================

function GetRadar(steps,pn,index)
    if steps then
        if index == 1 then --taps
                return steps:GetRadarValues(pn):GetValue('RadarCategory_TapsAndHolds');
            elseif index == 2 then --jumps
                return steps:GetRadarValues(pn):GetValue('RadarCategory_Jumps');
            elseif index == 3 then --holds
                return steps:GetRadarValues(pn):GetValue('RadarCategory_Holds');
            elseif index == 4 then --hands
                return steps:GetRadarValues(pn):GetValue('RadarCategory_Hands');
            elseif index == 5 then --mines
                return steps:GetRadarValues(pn):GetValue('RadarCategory_Mines');
            elseif index == 6 then --others
                return (steps:GetRadarValues(pn):GetValue('RadarCategory_Rolls') + 
                steps:GetRadarValues(pn):GetValue('RadarCategory_Lifts') + 
                steps:GetRadarValues(pn):GetValue('RadarCategory_Fakes')); 
            else return 0;
        end;
    else
        return 0;
    end;
end;


--//================================================================

--<Kyzentun> NEWSKIN:get_all_skin_names will fetch all skin names, including ones that don't support the current stepstype.
--<Kyzentun> get_skin_names_for_stepstype will fetch the ones for a given stepstype.

function GetNoteskins()
    local g = GAMESTATE:GetCurrentGame();
    local st = GAMEMAN:GetFirstStepsTypeForGame(g);
    return NOTESKIN:get_skin_names_for_stepstype(st);
end;

--//================================================================

function SetNoteskinByIndex(pn, num)
    local g = GAMESTATE:GetCurrentGame();
    local st = GAMEMAN:GetFirstStepsTypeForGame(g);
    local noteskins = GetNoteskins();
    local index = clamp(num,1,#noteskins)
    PROFILEMAN:GetProfile(pn):set_preferred_noteskin(noteskins[index])
    return noteskins[index];
end;


--//================================================================

function SetNoteskin(pn, ns)
    local g = GAMESTATE:GetCurrentGame()
    local st = "";
    if Global.pncursteps[pn] then
        st = Global.pncursteps[pn]:GetStepsType();
    else
        st = GAMEMAN:GetFirstStepsTypeForGame(g)
    end;
    PROFILEMAN:GetProfile(pn):set_preferred_noteskin(ns)
end;

--//================================================================
            
function GetNoteskinSelection(pn)
    Global.noteskins = GetNoteskins();
    local curskin = GetPreferredNoteskin(pn);
    local defaultselection = 1;
    local selection = -1;

    for i=1,#Global.noteskins do
        if string.lower(Global.noteskins[i]) == "default" then defaultselection = i; end;
        if string.lower(curskin) == string.lower(Global.noteskins[i]) then selection = i; end;
    end;

    if selection == -1 then selection = defaultselection end;
    return selection
end;

--//================================================================

function GetPreferredNoteskin(pn)
    local g = GAMESTATE:GetCurrentGame()
    local st = "";
    if Global.pncursteps[pn] then
        st = Global.pncursteps[pn]:GetStepsType();
    else
        st = GAMEMAN:GetFirstStepsTypeForGame(g)
    end;
    return PROFILEMAN:GetProfile(pn):get_preferred_noteskin(st)
end;

