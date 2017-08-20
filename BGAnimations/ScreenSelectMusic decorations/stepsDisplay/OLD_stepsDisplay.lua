--Probably horrible code
function getDifficulty(song, diff)
	local steps;
	steps = song:GetOneSteps("StepsType_Dance_Single",diff);
	if not steps then
		steps = song:GetOneSteps("StepsType_Pump_Single",diff);
	end;
	return steps;
end;
	

--I want my arrays to start at 0!
local colorArray = {}
colorArray[0] = Color("HoloBlue");
colorArray[1] = Color("HoloOrange");
colorArray[2] = color("1,0,1,1");
colorArray[3] = Color("Green");
colorArray[4] = color("#9900ff");

local t = Def.ActorFrame{
	--I don't think there's any way to load quads on the fly.
	--No idea how PIU themes add and remove difficulties
	--on the fly
	
	--[[
	Anyway, here's how to not waste code.
	If you're going to use the same command over and over,
	Just put it in the InitCommand/OnCommand/etc of the ActorFrame.
	]]
};
for i=0,4 do
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(xy,-20,-45);
		--If rotationz is outside the Quad, it will rotate first and THEN do the positioning math.
		Def.Quad{
			InitCommand=cmd(addx,30*i;rotationz,60;setsize,110,20;diffuse,colorArray[i];diffusealpha,.6;faderight,.3;horizalign,left);
		};
		
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			--WARNING: halign(-.1) is a hack! halign is only supposed to go from 0 to 1.
			InitCommand=cmd(addx,30*i;halign,-.05;valign,.6;zoom,.5;rotationz,60;diffuse,Color("White"));
			Text="Test!";
			CurrentSongChangedMessageCommand=cmd(playcommand,"On");
			OnCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				if song then
					steps = getDifficulty(song, i);
					if steps then
						self:settext(ToEnumShortString(steps:GetDifficulty()));
					else
						self:settext("");
					end;
				end;
			end;
		};
		
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=cmd(xy,30*i+35,60;halign,0;valign,.6;zoom,.5;rotationz,60;diffuse,Color("White"));
			Text="Test!";
			CurrentSongChangedMessageCommand=cmd(playcommand,"On");
			OnCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				if song then
					steps = getDifficulty(song, i);
					if steps then
						self:settext("Lv. "..steps:GetMeter());
					else
						self:settext("");
					end;
				end;
			end;
		};

	};
end;

return t;