--//================================================================

local _JudgmentColor = {
    ["Flawless"] = color("#ffc4ed"),
    ["Perfect"]  = color("#6ccfff"),
    ["Great"]    = color("#a9ff63"),
    ["Good"]     = color("#ffd075"),
    ["Bad"]      = color("#ae84cf"),
    ["Miss"]     = color("#ff5252"),
}

function JudgmentColor(w)
    return _JudgmentColor[w] or {1,1,1,1}
end;

local _GradeColor = {
    ["SS"]      = color("1.00, 0.85, 0.25, 1"),
    ["S+"]      = color("1.00, 0.85, 0.25, 1"),
    ["S"]       = color("1.00, 1.00, 1.00, 1"),
    ["AAAA"]    = color("0.50, 1.00, 1.00, 1"),
    ["AAA"]     = color("0.40, 0.90, 1.00, 1"),
    ["AA"]      = color("0.30, 0.80, 1.00, 1"),
    ["A"]       = color("0.20, 0.70, 1.00, 1"),
    ["B"]       = color("0.25, 1.00, 0.50, 1"),
    ["C"]       = color("1.00, 0.75, 0.50, 1"),
    ["D"]       = color("0.80, 0.40, 1.00, 1"),
    ["F"]       = color("1.00, 0.25, 0.25, 1"),
    ["Failed"]  = color("1.00, 0.10, 0.10, 1"),
}

--//================================================================

function AlphaColor(color,alpha)
    return { color[1], color[2], color[3], alpha }
end;    

--//================================================================

function HighlightColor(alpha) 
    return {0.3,1,0.775,alpha or 1}
end;

--//================================================================

function PlayerColor(pn,alpha)
    local pncolor = {
        [PLAYER_1] = {0.40,0.85,1,alpha or 1},
        [PLAYER_2] = {0.20,1,0.40,alpha or 1}, 
    }
    return pncolor[pn] or {1,1,1,1}
end

--//================================================================

function GradeColor(letter)
    if _GradeColor[letter] ~= nil then
        return _GradeColor[letter];
    else 
        return color("1,1,1,1");
    end;
end;

--//================================================================

function StepsColor(steps)
    local tint = {1,1,1,1}; 

    if steps then
        if PureType(steps) == "Single" then
            tint = {0.95,0.75,0.1,1};               
        elseif PureType(steps) == "Double" then
            tint = {0.2,0.9,0.2,1}; 
        elseif PureType(steps) == "Halfdouble" then
            tint = {0.8,0.1,0.6,1}; 
        elseif PureType(steps) == "Routine" then
            tint = {0.3,0.85,1,1};
        elseif PureType(steps) == "Solo" or PureType(steps) == "Couple" or PureType(steps) == "Real" then
            tint = {1,0.5,0.5,1};
        end;
    end;    

    return tint;
end;
