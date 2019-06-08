local function getWavyText(s,x,y)
	local letters = Def.ActorFrame{}
	local spacing = 15
	for i = 1, #s do
		local c = s:sub(i,i)
		--local c = "a"
		letters[i] = LoadFont("soms2/_soms2 techy")..{
			Text=c;
			InitCommand=cmd(x,x-(#s)*spacing/2+i*15;y,y;effectoffset,i*.1;bob;);
			--OnCommand=cmd(sleep,i*.1-.1;decelerate,.2;zoom,1);
		};
	end;
	return letters;
end;

local xVelocity = 0
local t = Def.ActorFrame{
	Def.ActorFrame{
		FOV=90;
		LoadActor(THEME:GetPathG("CreditsLogo","RL"))..{
			InitCommand=cmd(rainbow;customtexturerect,0,0,5,5;setsize,750,750;Center;texcoordvelocity,0,1.5;rotationx,-90/4*3.5;fadetop,1);
			CodeMessageCommand=function(self, params)
				if params.Name == "Start" or params.Name == "Center" then
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
				elseif params.Name == "Left" then
					xVelocity=xVelocity+.5;
				elseif params.Name == "Right" then
					xVelocity=xVelocity-.5;
				else
					SCREENMAN:SystemMessage("Unknown button: "..params.Name);
				end;
				self:texcoordvelocity(xVelocity,1.5);
			end;
		};
	}
};
t[#t+1] = getWavyText("Pump It Up: Delta 2",SCREEN_CENTER_X,SCREEN_CENTER_Y-100);
t[#t+1] = getWavyText("Coded by Rhythm Lunatic",SCREEN_CENTER_X,SCREEN_CENTER_Y);
t[#t+1] = getWavyText("Greetz to the other themers out there",SCREEN_CENTER_X,SCREEN_CENTER_Y+100);

return t;