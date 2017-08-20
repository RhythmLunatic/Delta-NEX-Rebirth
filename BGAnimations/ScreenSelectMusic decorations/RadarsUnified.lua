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






--graph P1

t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	InitCommand=cmd(horizalign,left;draworder,100;zoom,0.325;diffusealpha,0;x,-105;y,72);
	SongChosenMessageCommand=cmd(finishtweening;linear,0.3;diffusealpha,1);
	TwoPartConfirmCanceledMessageCommand=cmd(finishtweening;linear,0.3;diffusealpha,0);
	SongUnchosenMessageCommand=cmd(finishtweening;linear,0.3;diffusealpha,0);
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"SetText");
	CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"SetText");
	SetTextCommand=function(self)
		self:settext("Avg. notes/sec:\n"..average);
	end;
};






t[#t+1] = Def.Quad{
	InitCommand=cmd(vertalign,bottom;draworder,100;zoomto,15,30;diffusealpha,0;x,-18;y,95);
	OnCommand=cmd(diffuse,0,0.7,0.9,0;diffusetopedge,0.3,0.9,1,0;blend,Blend.Add);
	TwoPartConfirmCanceledMessageCommand=cmd(finishtweening;decelerate,0.3;diffusealpha,0);
	SongUnchosenMessageCommand=cmd(finishtweening;decelerate,0.3;diffusealpha,0);
	SongChosenMessageCommand=cmd(finishtweening;decelerate,0.3;diffusealpha,1;queuecommand,"Set");
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
	SetCommand=function(self)
		self:finishtweening();
		self:decelerate(0.3);
		self:zoomto(15,stream*29+1);
	end;
};








t[#t+1] = Def.Quad{
	InitCommand=cmd(vertalign,bottom;draworder,100;zoomto,15,30;diffusealpha,0;x,21;y,95);
	OnCommand=cmd(diffuse,0.9,0.3,0.1,0;diffusetopedge,1,0.4,0.2,0;blend,Blend.Add);
	TwoPartConfirmCanceledMessageCommand=cmd(finishtweening;decelerate,0.3;diffusealpha,0);
	SongUnchosenMessageCommand=cmd(finishtweening;decelerate,0.3;diffusealpha,0);
	SongChosenMessageCommand=cmd(finishtweening;decelerate,0.3;diffusealpha,1;queuecommand,"Set");
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
	SetCommand=function(self)
		self:finishtweening();
		self:decelerate(0.3);
		self:zoomto(15,cVoltage*29+1);
	end;
};

t[#t+1] = Def.Quad{
	InitCommand=cmd(vertalign,bottom;draworder,100;zoomto,15,30;diffusealpha,0;x,60;y,95);
	OnCommand=cmd(diffuse,0.2,0.9,0.3,0;diffusetopedge,0.3,1,0.4,0;blend,Blend.Add);
	TwoPartConfirmCanceledMessageCommand=cmd(finishtweening;decelerate,0.3;diffusealpha,0);
	SongUnchosenMessageCommand=cmd(finishtweening;decelerate,0.3;diffusealpha,0);
	SongChosenMessageCommand=cmd(finishtweening;decelerate,0.3;diffusealpha,1;queuecommand,"Set");
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
	SetCommand=function(self)


		self:finishtweening();
		self:decelerate(0.3);
		self:zoomto(15,complex*29+1);
	end;
};


t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	InitCommand=cmd(horizalign,left;draworder,100;zoom,0.31;diffusealpha,0;x,-35;y,102;shadowlength,1);
	SongChosenMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,1;visible,GAMESTATE:IsHumanPlayer(player));
	TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	SongUnchosenMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	Text="STREAM     BURST   COMPLEX "; -- EFFECTS";
};



return t;
