local player = ...;
local t = Def.ActorFrame{
	CurrentStepsP1ChangedMessageCommand=function(self)


		song = GAMESTATE:GetCurrentSong();
		local radar;
		if song and GAMESTATE:GetCurrentSteps(player) then
			radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
			totalnotes = radar:GetValue('RadarCategory_TapsAndHolds') + radar:GetValue('RadarCategory_Jumps') + radar:GetValue('RadarCategory_Hands');
			average = (math.ceil(((totalnotes/song:MusicLengthSeconds())*(radar:GetValue('RadarCategory_Stream')*(radar:GetValue('RadarCategory_Voltage'))))*100))/100;

			voltage = ((GAMESTATE:GetCurrentSteps(player):GetRadarValues(player):GetValue('RadarCategory_Voltage')*average)/8)*1.5-0.5


			stream = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player):GetValue('RadarCategory_Stream')*3-2;
			stream = clamp(stream,0,1);
			cVoltage = clamp(voltage,0,1);


			timing = GAMESTATE:GetCurrentSteps(player):GetTimingData();

			if timing:HasBPMChanges() or timing:HasScrollChanges() or timing:HasSpeedChanges() then bpm = 5 else bpm = 0 end;
			if timing:HasDelays() or timing:HasStops() then stop = 2 else stop = 0 end;
			if timing:HasFakes() or GAMESTATE:GetCurrentSteps(player):GetRadarValues(player):GetValue('RadarCategory_Fakes') ~= 0 then fake = 1 else fake = 0 end;
			if timing:HasNegativeBPMs() or timing:HasWarps() then warp = 2 else warp = 0 end;

			gimmick = ((bpm+stop+fake+warp)/10);
			chaos = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player):GetValue('RadarCategory_Chaos')*2-1;
			chaos = clamp(chaos,0,1);
			complex = ((chaos*1.5)+(gimmick*1.5))/3;
			complex = clamp(complex,0,1);

		end;
		
	end;
}



return t;
