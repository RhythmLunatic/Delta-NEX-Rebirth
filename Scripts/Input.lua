--//================================================================

local gamecodes = {
    ["Options"] = {
        ["dance"]   = "Left,Right,Left,Right,Left,Right",
        ["pump"]    = "DownLeft,DownRight,DownLeft,DownRight,DownLeft,DownRight",
        ["default"] = "MenuLeft,MenuRight,MenuLeft,MenuRight,MenuLeft,MenuRight"
    }
}

function GameCode(code)
    if gamecodes and gamecodes[code] and gamecodes[code][string.lower(Game())] then
        return gamecodes[code][string.lower(Game())];
    else
        return gamecodes[code]["default"];
    end;
end;

--//================================================================

local function MenuInputGame(button)
    local game = string.lower(Game());
    local inputs = {
        ["pump"] = {
            ["MenuUp"] = "Back",
            ["MenuDown"] = "Back",
            ["MenuLeft"] = "Prev",
            ["MenuRight"] = "Next",
        },
        ["default"] = {
            ["MenuUp"] = "Prev",
            ["MenuDown"] = "Next",
            ["MenuLeft"] = "Prev",
            ["MenuRight"] = "Next",
        },
    }

    if inputs[game] and inputs[game][button] then
        return inputs[game][button]
    elseif inputs["default"][button] then
        return inputs["default"][button]
    else
        return ""
    end;
end;

--//================================================================

function MenuInputActor()
    return Def.ActorFrame{
        UnlockCommand=function() Global.lockinput = false; MESSAGEMAN:Broadcast("Unlock"); end;
        MenuUpP1MessageCommand=function(self,param) MESSAGEMAN:Broadcast("MenuInput", { Input = MenuInputGame("MenuUp"), Button = "Up", Player = PLAYER_1 }); end; 
        MenuUpP2MessageCommand=function(self,param) MESSAGEMAN:Broadcast("MenuInput", { Input = MenuInputGame("MenuUp"), Button = "Up", Player = PLAYER_2 }); end; 
        MenuDownP1MessageCommand=function(self,param) MESSAGEMAN:Broadcast("MenuInput", { Input = MenuInputGame("MenuDown"), Button = "Down", Player = PLAYER_1 }); end; 
        MenuDownP2MessageCommand=function(self,param) MESSAGEMAN:Broadcast("MenuInput", { Input = MenuInputGame("MenuDown"), Button = "Down", Player = PLAYER_2 }); end; 
        MenuLeftP1MessageCommand=function(self,param) MESSAGEMAN:Broadcast("MenuInput", { Input = MenuInputGame("MenuLeft"), Button = "Left", Player = PLAYER_1 }); end;
        MenuLeftP2MessageCommand=function(self,param) MESSAGEMAN:Broadcast("MenuInput", { Input = MenuInputGame("MenuLeft"), Button = "Left", Player = PLAYER_2 }); end; 
        MenuRightP1MessageCommand=function(self,param) MESSAGEMAN:Broadcast("MenuInput", { Input = MenuInputGame("MenuRight"), Button = "Right", Player = PLAYER_1 }); end; 
        MenuRightP2MessageCommand=function(self,param) MESSAGEMAN:Broadcast("MenuInput", { Input = MenuInputGame("MenuRight"), Button = "Right", Player = PLAYER_2 }); end; 
        CodeMessageCommand=function(self,param) MESSAGEMAN:Broadcast("MenuInput", { Input = param.Name, Button = "", Player = param.PlayerNumber });  end;
    }
end;

--//================================================================

function MouseInputActor()
    return Def.ActorFrame{
        UnlockCommand=function() Global.lockinput = false; MESSAGEMAN:Broadcast("Unlock"); end;
        LeftClickMessageCommand=function(self,param) MESSAGEMAN:Broadcast("MenuInput", { Input = "Choose", Button = "LMB", Player = Global.master }); end;
        RightClickMessageCommand=function(self,param) MESSAGEMAN:Broadcast("MenuInput", { Input = "Context", Button = "RMB", Player = Global.master }); end;
        MiddleClickMessageCommand=function(self,param) MESSAGEMAN:Broadcast("MenuInput", { Input = "", Button ="MMB", Player = Global.master }); end;
        MouseWheelUpMessageCommand=function(self,param) 
            if Global.debounce <= 0 then 
                MESSAGEMAN:Broadcast("MenuInput", { Input = "Up", Button = "WheelUp", Player = Global.master }); 
            end; 
            Global.debounce = Global.delta/1.75; 
            Global.wheel = Global.wheel - 1;
        end; 
        MouseWheelDownMessageCommand=function(self,param) 
            if Global.debounce <= 0 then 
                MESSAGEMAN:Broadcast("MenuInput", { Input = "Down", Button = "WheelDown", Player = Global.master }); 
            end;
            Global.debounce = Global.delta/1.75;  
            Global.wheel = Global.wheel + 1;
        end;
    }
end;

--//================================================================

function MouseOver(self, range)
	local radius;
	if range == nil then radius = 0.8; else radius = range end;

	if Global.mouseX >= self:GetX() - (self:GetWidth()*self:GetZoomX()*radius) and
	   Global.mouseX <= self:GetX() + (self:GetWidth()*self:GetZoomX()*radius) and
	   Global.mouseY >= self:GetY() - (self:GetHeight()*self:GetZoomY()*radius) and 
	   Global.mouseY <= self:GetY() + (self:GetHeight()*self:GetZoomY()*radius) then
		return true;
	else
		return false;
	end
end;

--//================================================================

function MouseDown(self, range, scr)
	if ButtonHover(self,range) then
		self:stoptweening();
		self:glow(1,1,1,1);
		self:linear(0.2)
		self:glow(1,1,1,0);
		Global.screen = SCREENMAN:GetTopScreen():GetName();
		if GAMESTATE:GetNumSidesJoined() == 0 then
			GAMESTATE:JoinPlayer(PLAYER_1);
		end;
		SCREENMAN:SetNewScreen(scr)
	end;
end;	

--//================================================================

function ButtonHover(self,range)
	if MouseOver(self,range) then
		self:playcommand("GainFocus");
		return true;
	else
		self:playcommand("LoseFocus");
		return false;
	end;
end;	

--//================================================================