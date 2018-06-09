local t = Def.ActorFrame{
	InitCommand=cmd(hibernate,3);
}

function FitInsideAvoidLetter(self, height)
	local yscale= height / self:GetHeight()
	self:zoom(yscale)
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function determineContainerHeight(numStages)
	if numStages <= 3 then
		return 100;
	elseif numStages == 4 then
		return 88;
	else
		return 50;
	end;
end;

local numStagesPlayed = STATSMAN:GetStagesPlayed();
--SCREENMAN:SystemMessage(tostring(numStagesPlayed));
local containerHeight = determineContainerHeight(numStagesPlayed);
--Because STATSMAN:GetPlayedStageStats() accepts stages ago as the parameter, count down
--Well, actually this has no effect... just use sStats:GetStageIndex()+1
for i=numStagesPlayed,1,-1 do
	local sStats = STATSMAN:GetPlayedStageStats(i);
	local song = sStats:GetPlayedSongs()[1];
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(xy,SCREEN_CENTER_X,10+(containerHeight+5)*(sStats:GetStageIndex()+1));


		Def.Sprite{
			InitCommand=cmd(LoadFromSongBanner,song;--[[fadeleft,.1;faderight,.1]]);
			OnCommand=function(self)
				FitInsideAvoidLetter(self, containerHeight-2)
			end;
		};
		
		--container bg
		Def.Quad {
			InitCommand=cmd(diffuse,0,0,0,0.4;setsize,SCREEN_WIDTH,containerHeight-2;);

		};
		
		--Stage num
		--[[Def.Quad{
			InitCommand=cmd(setsize,55,15;addy,-containerHeight/2+10;diffuse,Color("Black");fadeleft,.3;faderight,.3);
		
		};]]
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=cmd(addy,-containerHeight/2+10;zoom,0.4;diffuse,color("#fffFFF");diffusebottomedge,color("#CCCCCC");shadowlength,0.8);
			Text="Stage "..tostring(sStats:GetStageIndex()+1);
		};
		
		--Song Title & Group
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=cmd(addy,-8;maxwidth,225;zoomy,0.55;zoomx,0.58;diffuse,color("#FFFF66FF");diffusebottomedge,color("#DDAA44FF");shadowlength,0.8;);
			Text=string.upper(song:GetDisplayMainTitle().." "..song:GetDisplaySubTitle())
		};

		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=cmd(addy,8;zoom,0.4;diffuse,color("#fffFFF");diffusebottomedge,color("#CCCCCC");shadowlength,0.8);
			Text=string.upper(string.gsub(song:GetGroupName(),"^%d%d? ?%- ?", ""));
			--Text=song:GetDisplayArtist();
		};
		
		--Player stats are added down below.
		
		--Container lines
		Def.Quad {
			InitCommand=cmd(diffuse,color("#C2C2C2");setsize,SCREEN_WIDTH,2;y,containerHeight/2;fadeleft,.1;faderight,.1);

		};

		Def.Quad {
			InitCommand=cmd(diffuse,color("#C2C2C2");setsize,SCREEN_WIDTH,2;y,-containerHeight/2;fadeleft,.1;faderight,.1);

		};

	};
end

--[[
Because player 2 might not be present, I don't want to load their
empty stats (and it will probably crash the game). So instead of
being in the previous ActorFrame, it's on top.
]]

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	for i=numStagesPlayed,1,-1 do
		--Player stats
		local sStats = STATSMAN:GetPlayedStageStats(i);
		t[#t+1] = LoadActor("PlayerStats",pn,sStats,containerHeight)..{
			InitCommand=cmd(xy,SCREEN_CENTER_X,10+(containerHeight+5)*(sStats:GetStageIndex()+1));
		};
	end;

end


--[[for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	--Calculate positioning of items based on aspect ratio. (16:9 is the default.)
	local numbers_xPos = 133*PREFSMAN:GetPreference("DisplayAspectRatio");
	local grades_xPos = 180*PREFSMAN:GetPreference("DisplayAspectRatio");
	-- position = pn==PLAYER_2 ? 1 : -1;
	local position = (pn == "PlayerNumber_P2") and 1 or -1;
	local sPosition = AllowSuperb and 154 or 123;
	
	t[#t+1] = LoadActor("PlayerNumbers", pn)..{
		InitCommand=cmd(xy,SCREEN_CENTER_X+numbers_xPos*position,sPosition);
		OnCommand=function(self)
			--SCREENMAN:SystemMessage(numbers_xPos);
		end;
	};
	t[#t+1] = LoadActor("PlayerGrade", pn)..{
		InitCommand=cmd(xy,SCREEN_CENTER_X+grades_xPos*position,SCREEN_CENTER_Y);
	};
end]]

t[#t+1] = LoadActor(THEME:GetPathG("","footer"), true)..{
	InitCommand=cmd(draworder,100);
}


--These lights are headache inducing. I don't know why anyone likes them.
--If you want your lights so badly, please just use the lights on the arcade...
t[#t+1] = LoadActor(THEME:GetPathG("","header"), false)..{
	InitCommand=cmd(draworder,100);
};



--TITLE
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,100;rotationx,30;diffuse,0.08,0.08,0.08,1;diffusetopedge,0.2,0.2,0.2,1;shadowlengthy,-1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_TOP+37;zoomx,0.7;zoomy,0.725;);
	Text="TOTAL RESULTS"
}


--TIMER

t[#t+1] = LoadActor("B0") .. {
	InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,-0.55);

};

t[#t+1] = LoadActor("B1") .. {
	InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

};

t[#t+1] = LoadActor("B2") .. {
	InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

};

t[#t+1] = LoadFont("venacti/_venacti 13px bold diffuse")..{
		InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,-0.8;shadowlength,-0.8;horizalign,left;x,SCREEN_CENTER_X+185 ;y,SCREEN_TOP+16;zoom,0.40);
		Text="TIMER"
}





return t;
