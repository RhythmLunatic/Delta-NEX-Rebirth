local t = Def.ActorFrame{}
local baseZoom = 0.3
local spacing = 29;
local delay = 2

local baseX = -(spacing*5.5);
local baseY = 80;


t[#t+1] = Def.Quad{
	InitCommand=cmd(vertalign,top;zoomto,SCREEN_WIDTH,60;diffuse,0,0,0,1;fadebottom,0.9);
	--[[CurrentStepsP1ChangedMessageCommand=cmd(stoptweening;diffusealpha,0.6;sleep,delay;linear,0.2;diffusealpha,0);
	CurrentStepsP2ChangedMessageCommand=cmd(stoptweening;diffusealpha,0.6;sleep,delay;linear,0.2;diffusealpha,0);
	CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0.6;sleep,delay;linear,0.2;diffusealpha,0);
	OnCommand=cmd(diffusealpha,0);]]
}


--[[
t[#t+1] = LoadActor(THEME:GetPathG("","upTap"))..{
	InitCommand=cmd(draworder,100;x,-200;y,60;zoom,0.50);
	CurrentStepsP1ChangedMessageCommand=cmd(stoptweening;linear,0.15;y,60;sleep,delay;linear,0.15;y,0);
	CurrentStepsP2ChangedMessageCommand=cmd(stoptweening;linear,0.15;y,60;sleep,delay;linear,0.15;y,0);
	CurrentSongChangedMessageCommand=cmd(stoptweening;linear,0.15;y,60;sleep,delay;linear,0.15;y,0);
}
t[#t+1] = LoadActor(THEME:GetPathG("","upTap"))..{
	InitCommand=cmd(draworder,100;x,200;y,60;zoomy,0.50;zoomx,-0.50);
	CurrentStepsP1ChangedMessageCommand=cmd(stoptweening;linear,0.15;y,60;sleep,delay;linear,0.15;y,0);
	CurrentStepsP2ChangedMessageCommand=cmd(stoptweening;linear,0.15;y,60;sleep,delay;linear,0.15;y,0);
	CurrentSongChangedMessageCommand=cmd(stoptweening;linear,0.15;y,60;sleep,delay;linear,0.15;y,0);
}]]--

local difficulties = {
	diff1 = "Beginner",
	diff2 = "Easy",
	diff3 = "Medium",
	diff4 = "Hard",
	diff5 = "Challenge",
	diff6 = "Edit",
};

for i=1,12 do

	t[#t+1] = LoadActor("_icon")..{
		InitCommand=cmd(zoom,baseZoom-0.05;x,baseX+spacing*(i-1);y,baseY;animate,false);
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Refresh");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Refresh");
		CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
		NextSongMessageCommand=cmd(playcommand,"Refresh");
		PreviousSongMessageCommand=cmd(playcommand,"Refresh");
		RefreshCommand=function(self)
				self:stoptweening();
				local song = GAMESTATE:GetCurrentSong()

				if song then
					if i>6 then

						if GAMESTATE:GetNumSidesJoined() == 2 then
							self:setstate(0);
							if song:HasStepsTypeAndDifficulty("StepsType_Pump_Routine","Difficulty_"..difficulties["diff"..i-6]) then
									self:diffusealpha(1);
								else
									self:setstate(3);
									self:diffusealpha(0.3);
							end
							if song:GetOneSteps("StepsType_Pump_Routine","Difficulty_"..difficulties["diff"..i-6]):IsAutogen()==true then
								self:setstate(1);
							end
						else
							self:setstate(4);
							if song:HasStepsTypeAndDifficulty("StepsType_Pump_Double","Difficulty_"..difficulties["diff"..i-6]) then
								self:diffusealpha(1);
							else
								self:setstate(3);
								self:diffusealpha(0.3);
							end
						end


						--[[if song:GetOneSteps("StepsType_Pump_Double","Difficulty_"..difficulties["diff"..i-6]):IsAutogen()==true then
							self:setstate(6);
						end]]
					else


						self:setstate(5);
						if song:HasStepsTypeAndDifficulty("StepsType_Pump_Single","Difficulty_"..difficulties["diff"..i]) then
							self:diffusealpha(1);
						else
							self:setstate(3);
							self:diffusealpha(0.3);
						end

						--[[if song:GetOneSteps("StepsType_Pump_Single","Difficulty_"..difficulties["diff"..i]):IsAutogen()==true then
							self:setstate(2);
						end]]
				end




					--if i==6 then
					--self:setstate(3);
					--	if song:GetOneSteps("StepsType_Pump_Single","Difficulty_Edit"):IsAutogen()==true then
					--		self:setstate(4);
					--	end
					--end



					--if i==12  then
					--self:setstate(3);
					--	if song:GetOneSteps("StepsType_Pump_Double","Difficulty_Edit"):IsAutogen()==true then
					--		self:setstate(4);
					--	end

					--end




				else
						self:diffusealpha(0.3);
				end


				--[[
				self:sleep(delay);
				self:linear(0.2);
				self:diffusealpha(0);]]
		end
	}



	t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		InitCommand=cmd(zoomx,baseZoom+0.1;zoomy,baseZoom+0.075;shadowlength,0.8;shadowcolor,color("0,0,0,1");x,baseX-0.33+spacing*(i-1);y,baseY-0.33;);
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Refresh");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Refresh");
		CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
		NextSongMessageCommand=cmd(playcommand,"Refresh");
		PreviousSongMessageCommand=cmd(playcommand,"Refresh");
		RefreshCommand=function(self)
		self:stoptweening();
		local song = GAMESTATE:GetCurrentSong()

		if song then

		if i>6 then
			if GAMESTATE:GetNumSidesJoined() == 2 then

				if song:HasStepsTypeAndDifficulty("StepsType_Pump_Routine","Difficulty_"..difficulties["diff"..i-6]) then
					self:settext(song:GetOneSteps("StepsType_Pump_Routine","Difficulty_"..difficulties["diff"..i-6]):GetMeter());
					self:diffusealpha(1);
				else
					self:diffusealpha(0.3);
					self:settext("--");
				end
			else
				if song:HasStepsTypeAndDifficulty("StepsType_Pump_Double","Difficulty_"..difficulties["diff"..i-6]) then
					self:settext(song:GetOneSteps("StepsType_Pump_Double","Difficulty_"..difficulties["diff"..i-6]):GetMeter());
					self:diffusealpha(1);
				else
					self:diffusealpha(0.3);
					self:settext("--");
				end
			end
		else
			if song:HasStepsTypeAndDifficulty("StepsType_Pump_Single","Difficulty_"..difficulties["diff"..i]) then
				self:settext(song:GetOneSteps("StepsType_Pump_Single","Difficulty_"..difficulties["diff"..i]):GetMeter());
				self:diffusealpha(1);
			else
				self:diffusealpha(0.3);
				self:settext("--");
			end
		end

		else
				self:diffusealpha(0.3);
				self:settext("--");
		end


		--[[self:sleep(delay);
		self:linear(0.2);
		self:diffusealpha(0);]]
		end


	}


end



if GAMESTATE:IsSideJoined(PLAYER_2) then
	t[#t+1] = LoadActor("UnifiedCursor", PLAYER_2)..{
	InitCommand=cmd(zoom,baseZoom-0.05;x,baseX;y,baseY;rotationx,180;rotationz,180;spin;playcommand,"Set");
	CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	NextSongMessageCommand=cmd(playcommand,"Set");
	PreviousSongMessageCommand=cmd(playcommand,"Set");

	SetCommand=function(self)
		steps = GAMESTATE:GetCurrentSteps(PLAYER_2);
		if steps then
			steptype = steps:GetStepsType();
			stepdiff = steps:GetDifficulty();
		end;

		local song = GAMESTATE:GetCurrentSong();
		if song then
			if GAMESTATE:IsHumanPlayer(PLAYER_2) then
				self:visible(true);
			else
				self:visible(false);
			end
		else
			self:visible(false);
		end



			if steptype=="StepsType_Pump_Single" then
				col2 = 0;
			end
		if steptype=="StepsType_Pump_Double" or steptype=="StepsType_Pump_Routine" then
				col2 = spacing*6;
			end


				if stepdiff=="Difficulty_Beginner" then
					self:x(baseX+col2);
				end
				if stepdiff=="Difficulty_Easy" then
					self:x(baseX+spacing+col2);
				end
				if stepdiff=="Difficulty_Medium" then
					self:x(baseX+spacing*2+col2);
				end
				if stepdiff=="Difficulty_Hard" then
					self:x(baseX+spacing*3+col2);
				end
				if stepdiff=="Difficulty_Challenge" then
					self:x(baseX+spacing*4+col2);
				end
				if stepdiff=="Difficulty_Edit" then
					self:x(baseX+spacing*5+col2);
				end



	end;
	}
end;

t[#t+1] = LoadActor("UnifiedCursor", PLAYER_1)..{
	InitCommand=cmd(zoom,baseZoom-0.05;x,baseX;y,baseY;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);spin;effectperiod,1;playcommand,"Set");
	CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	NextSongMessageCommand=cmd(playcommand,"Set");
	PreviousSongMessageCommand=cmd(playcommand,"Set");
	SetCommand=function(self)


		steps = GAMESTATE:GetCurrentSteps(PLAYER_1);
		if steps then
			steptype = steps:GetStepsType();
			stepdiff = steps:GetDifficulty();
		end;

		local song = GAMESTATE:GetCurrentSong();
		if song then
			if GAMESTATE:IsHumanPlayer(PLAYER_1) then
				self:visible(true);
			else
				self:visible(false);
			end
		else
			self:visible(false);
		end


		--[[if steptype=="StepsType_Pump_Single" then
			col2 = 0;
		end]]
		if steptype=="StepsType_Pump_Double" or steptype=="StepsType_Pump_Routine" then
				col2 = spacing*6;
		else
				col2 = 0;
		end;


				if stepdiff=="Difficulty_Beginner" then
					self:x(baseX+col2);
				end
				if stepdiff=="Difficulty_Easy" then
					self:x(baseX+spacing+col2);
				end
				if stepdiff=="Difficulty_Medium" then
					self:x(baseX+spacing*2+col2);
				end
				if stepdiff=="Difficulty_Hard" then
					self:x(baseX+spacing*3+col2);
				end
				if stepdiff=="Difficulty_Challenge" then
					self:x(baseX+spacing*4+col2);
				end
				if stepdiff=="Difficulty_Edit" then
					self:x(baseX+spacing*5+col2);
				end

	end;
}


t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
InitCommand=cmd(diffuse,0.3,0.5,0.85,1;diffusetopedge,0.6,0.8,1,1;shadowlength,0.8;shadowcolor,color("0,0,0,1");zoomx,0.35;zoomy,0.3);
CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
NextSongMessageCommand=cmd(playcommand,"Set");
PreviousSongMessageCommand=cmd(playcommand,"Set");
Text="1P";
SetCommand=function(self)

	self:stoptweening();


	steps = GAMESTATE:GetCurrentSteps(PLAYER_1);
	if steps then
		steptype = steps:GetStepsType();
		stepdiff = steps:GetDifficulty();
	end;

	local song = GAMESTATE:GetCurrentSong();
	if song then
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			self:visible(true);
		else
			self:visible(false);
		end
	else
		self:visible(false);
	end


		if steptype=="StepsType_Pump_Single" then
			col2 = 0;
		end
		if steptype=="StepsType_Pump_Double" or steptype=="StepsType_Pump_Routine" then
			col2 = spacing*6;
		end

			self:y(baseY-13)
			if stepdiff=="Difficulty_Beginner" then
				self:x(baseX+col2);
			end
			if stepdiff=="Difficulty_Easy" then
				self:x(baseX+spacing+col2);
			end
			if stepdiff=="Difficulty_Medium" then
				self:x(baseX+spacing*2+col2);
			end
			if stepdiff=="Difficulty_Hard" then
				self:x(baseX+spacing*3+col2);
			end
			if stepdiff=="Difficulty_Challenge" then
				self:x(baseX+spacing*4+col2);
			end
			if stepdiff=="Difficulty_Edit" then
				self:x(baseX+spacing*5+col2);
			end
			self:addx(-10);
			--self:playcommand("Fade");
end;
--FadeCommand=cmd(stoptweening;diffusealpha,1;sleep,2;linear,0.2;diffusealpha,0);
}



if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	InitCommand=cmd(diffuse,0.85,0.5,0.3,1;diffusetopedge,1,0.8,0.6,1;shadowlength,0.8;shadowcolor,color("0,0,0,1");zoomx,0.35;zoomy,0.3);
	CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	NextSongMessageCommand=cmd(playcommand,"Set");
	PreviousSongMessageCommand=cmd(playcommand,"Set");
	Text="2P";
	SetCommand=function(self)
		self:stoptweening();
		--self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2));
		steps = GAMESTATE:GetCurrentSteps(PLAYER_2);
		if steps then
			steptype = steps:GetStepsType();
			stepdiff = steps:GetDifficulty();
		end;
		local song = GAMESTATE:GetCurrentSong();
		if song then
			self:visible(true);
		else
			self:visible(false);
		end

		if steptype=="StepsType_Pump_Single" then
			col2 = 0;
		end
		if steptype=="StepsType_Pump_Double" or steptype=="StepsType_Pump_Routine" then
			col2 = spacing*6;
		end

		self:y(baseY+13)
		if stepdiff=="Difficulty_Beginner" then
			self:x(baseX+col2);
		end
		if stepdiff=="Difficulty_Easy" then
			self:x(baseX+spacing+col2);
		end
		if stepdiff=="Difficulty_Medium" then
			self:x(baseX+spacing*2+col2);
		end
		if stepdiff=="Difficulty_Hard" then
			self:x(baseX+spacing*3+col2);
		end
		if stepdiff=="Difficulty_Challenge" then
			self:x(baseX+spacing*4+col2);
		end
		if stepdiff=="Difficulty_Edit" then
			self:x(baseX+spacing*5+col2);
		end
		self:addx(10);
		--self:playcommand("Fade");
	end;
	--FadeCommand=cmd(stoptweening;diffusealpha,1;sleep,2;linear,0.2;diffusealpha,0);
	}
end;

return t
