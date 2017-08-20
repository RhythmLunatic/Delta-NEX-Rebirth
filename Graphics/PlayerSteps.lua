local player = ...;
local t = Def.ActorFrame{}

--diff
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse") .. {
	InitCommand=cmd(maxwidth,150;x,30;zoom,0.5;y,2;vertalign,top;horizalign,right;shadowlengthy,1.2;shadowlengthx,0.8;shadowcolor,color("0,0,0,0.6");diffuse,color("1,1,1,1");diffusebottomedge,color("0.75,0.75,0.75,1");queuecommand,"Set");

	NormalColorCommand=cmd(diffuse,color("1,1,1,1");diffusebottomedge,color("0.75,0.75,0.75,1"));
	ExtraColorCommand=cmd(diffuse,color("1,1,0,1");diffusebottomedge,color("0.9,0.5,0.2,1"));
	AutogenColorCommand=cmd(diffuse,color("0.4,1,0.5,1");diffusebottomedge,color("0.3,0.8,0.3,1"));

	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
	SetCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then

			self:diffusealpha(1);
			

			
			local diff = string.gsub(string.gsub(ToEnumShortString(GAMESTATE:GetCurrentSteps(player):GetStepsType()),".*_",""), ".*", string.upper);
			local meter = GAMESTATE:GetCurrentSteps(player):GetMeter()
			local threshold = THEME:GetMetric("SongManager","ExtraColorMeter");
			self:settext(diff)
			
					if GAMESTATE:GetCurrentSteps(player):IsAutogen() then
							self:playcommand("AutogenColor");
					else
						if meter>=threshold then
							self:playcommand("ExtraColor");
						else
							self:playcommand("NormalColor");
						end
					end
		else
			self:playcommand("NormalColor");
			self:settext("---");
			self:diffusealpha(0.3);
		end
	end
};

--meter
t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers") .. {
	InitCommand=cmd(zoom,0.85;x,34;y,3;maxwidth,45;vertalign,top;horizalign,left;shadowlengthy,1.2;shadowlengthx,0.8;shadowcolor,color("0,0,0,0.6");glowshift;queuecommand,"Set");
	
	NormalColorCommand=cmd(diffuse,color("1,1,1,1");diffusebottomedge,color("0.75,0.75,0.75,1"));
	ExtraColorCommand=cmd(diffuse,color("1,1,0,1");diffusebottomedge,color("0.9,0.5,0.2,1"));
	AutogenColorCommand=cmd(diffuse,color("0.4,1,0.5,1");diffusebottomedge,color("0.3,0.8,0.3,1"));
	
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
	SetCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();

		if song then
		
		
			self:diffusealpha(1);
			local meter = GAMESTATE:GetCurrentSteps(player):GetMeter()
			local threshold = THEME:GetMetric("SongManager","ExtraColorMeter");


					
					
				

					
					if GAMESTATE:GetCurrentSteps(player):IsAutogen() then
							self:playcommand("AutogenColor");
					else
						if meter>=threshold then
							self:playcommand("ExtraColor");
						else
							self:playcommand("NormalColor");
						end
					end

				
				
					if meter < 10 then
						self:settext("0"..meter)
					else
						self:settext(meter);					
					end
				

						

		else
			self:playcommand("NormalColor");
			self:settext("00");
			self:diffusealpha(0.3);
		end
		
		
	end
};

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse") .. {
	Text="Lv.";
	InitCommand=cmd(zoom,0.3;y,14;x,26;vertalign,top;shadowlengthy,1.2;shadowlengthx,0.8;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");queuecommand,"Set");
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
	SetCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
			self:diffusealpha(1);
		else
			self:diffusealpha(0.3);
		end
	end
};


t[#t+1] = LoadFont("Common normal") .. {
	Text="AUTOGEN";
	InitCommand=cmd(visible,false;glowshift;horizalign,right;skewx,-0.1;zoom,0.375;y,15;x,18;vertalign,top;;shadowlengthy,1.2;shadowlengthx,0.8;shadowcolor,color("0,0,0,0.6");diffuse,color("0.4,1,0.6,1");diffusebottomedge,color("0.8,0.8,0.8,1");queuecommand,"Set");
	

	CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Steps");
	CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Steps");
	StepsCommand=function(self)
		local steps = GAMESTATE:GetCurrentSteps(player);
		if steps then
			self:visible(steps:IsAutogen());
		end;
	end;
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	SetCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
			self:diffusealpha(1);
		else
			self:diffusealpha(0);
		end
	end;
	

};



return t