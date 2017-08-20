local t = Def.ActorFrame{}




--bot quad
t[#t+1] = Def.Quad {
	--InitCommand=cmd(diffuse,color("0,0,0,0.6");vertalign,bottom;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;zoomto,SCREEN_WIDTH,188;fadetop,0.2);
InitCommand=cmd(diffuse,0,0,0,0.5;vertalign,bottom;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;zoomto,SCREEN_WIDTH,188;);
}


--[[t[#t+1] = LoadActor("listbg") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X-1;y,SCREEN_CENTER_Y;zoomy,0.675;zoomx,0.65);

};]]



--for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
--[[for pn in ivalues(PlayerNumber) do
	t[#t+1] = Def.ActorFrame{
		LoadActor(THEME:GetPathG("ScreenSelectMusic", "PaneDisplay"), ToEnumShortString(pn))..{
			InitCommand=cmd(xy,100,150);
		};
	};
end]]

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = Def.ActorFrame{
		LoadActor("stepsDisplay", pn)..{
			--InitCommand=cmd(xy,160,180);
			InitCommand=function(self)
				if pn == "PlayerNumber_P2" then
					self:x(SCREEN_WIDTH-160)
                else
                    self:x(160);
                end;
				self:y(180);
			end;
		};
	};
end









--P1 SHIT
if GAMESTATE:IsSideJoined(PLAYER_1) then
	t[#t+1] = Def.ActorFrame {
	--[[
	InitCommand=cmd(visible,false);
	SongChosenMessageCommand=cmd(visible,true);
	TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
	SongUnchosenMessageCommand=cmd(visible,false);]]
	InitCommand=cmd(xy,230,-250);

		Def.Sprite {
		InitCommand=cmd(skewx,-0.1;draworder,100;x,-86;y,SCREEN_CENTER_Y+92;zoom,0.525;fadetop,1;);
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
		PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
		SetCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
			if song then
				self:diffusealpha(1);
				profile = PROFILEMAN:GetMachineProfile();
				scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_1));
				assert(scorelist);
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];

					if topscore then

								local dancepoints = topscore:GetPercentDP()*100
								local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
								local grade;

						if dancepoints >= 50 then
							grade = "Tier06";
							if dancepoints >= 60 then
								grade = "Tier05";
								if dancepoints >= 70 then
									grade = "Tier04";
									if dancepoints >= 80 then
										grade = "Tier03";
										if misses==0 then
											grade = "Tier02";
											if dancepoints >= 99 then
												grade = "Tier01";
												if dancepoints == 100 then
													grade = "Tier00";
												end
											end
										end
									end
								end
							end
						else
							grade = "Tier07";
						end


					--SCREENMAN:SystemMessage(grade);
					self:Load(THEME:GetPathG("","GradeDisplayPane/"..grade));
				else
					--if no score
					self:diffusealpha(0);
				end
			else
				--if no song
				self:diffusealpha(0);
			end;
		end;
		};




		Def.Quad {
		InitCommand=cmd(diffuse,color("1,1,1,0.2");x,-66;y,SCREEN_CENTER_Y+115;zoomto,110,1;visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
		PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
	};

	--(((math.floor(topscore:GetPercentDP()*100000))/1000).."%");

			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				InitCommand=cmd(shadowlength,0.8;horizalign,left;draworder,100;x,-116;y,SCREEN_CENTER_Y+88-14;zoomx,0.39;zoomy,0.37;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
				CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
				SetCommand=function(self)
					local song = GAMESTATE:GetCurrentSong();
					if song then
						profile = PROFILEMAN:GetMachineProfile();
						scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_1));
						assert(scorelist);
						local scores = scorelist:GetHighScores();
						local topscore = scores[1];

						if topscore then
								text = topscore:GetName();
						else
								text = "No Score";
						end

						self:diffusealpha(1);
						if text=="EVNT" then
							self:settext("BEST");
						else
							self:settext(text);
						end
					else
						self:settext("---");
						self:diffusealpha(0.4);
					end

				end
			};

		LoadFont("venacti/_venacti_outline 26px bold monospace numbers")..{
			InitCommand=cmd(shadowlength,0.8;horizalign,right;draworder,100;y,SCREEN_CENTER_Y+102-13;zoomx,0.375;zoomy,0.36;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
			SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				profile = PROFILEMAN:GetMachineProfile();
				scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_1));
				assert(scorelist);
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];

				if topscore then
							text = scorecap(topscore:GetScore())

				else
						text = "0";
				end
				self:diffusealpha(1);
				self:settext(text);


			else
				self:settext("0");
				self:diffusealpha(0.4);
			end

			end
		};

		LoadFont("venacti/_venacti_outline 26px bold monospace numbers")..{
			InitCommand=cmd(shadowlength,0.8;horizalign,right;draworder,100;x,-4;y,SCREEN_CENTER_Y+102-1;zoomx,0.375;zoomy,0.36;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
			SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				profile = PROFILEMAN:GetMachineProfile();
				scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_1));
				assert(scorelist);
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];

				if topscore then
						if string.find(PREFSMAN:GetPreference("VideoRenderers"), "d3d,") then
							text = math.floor(topscore:GetPercentDP()*100).."%"
						else
							text = (((math.floor(topscore:GetPercentDP()*100000))/1000).."%");
						end
				else
						text = "0%";
				end
				self:diffusealpha(1);
				self:settext(text);
			else
				self:settext("0%");
				self:diffusealpha(0.4);
			end

			end;
		};
	}
end;

--P2 SHIT
if GAMESTATE:IsSideJoined(PLAYER_2) then
t[#t+1] = Def.ActorFrame {--[[
InitCommand=cmd(visible,false);
SongChosenMessageCommand=cmd(visible,true);
TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
SongUnchosenMessageCommand=cmd(visible,false);]]


	Def.Sprite {
	InitCommand=cmd(skewx,-0.1;draworder,100;x,SCREEN_CENTER_X+275;y,SCREEN_CENTER_Y+92;zoom,0.525;fadetop,1;visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
	SetCommand=function(self)
	local song = GAMESTATE:GetCurrentSong();
		if song then
			self:diffusealpha(1);
			profile = PROFILEMAN:GetMachineProfile();
			scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_2));
			assert(scorelist);
			local scores = scorelist:GetHighScores();
			local topscore = scores[1];

				if topscore then

							local dancepoints = topscore:GetPercentDP()*100
							local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
							local grade;

					if dancepoints >= 50 then
						grade = "Tier06";
						if dancepoints >= 60 then
							grade = "Tier05";
							if dancepoints >= 70 then
								grade = "Tier04";
								if dancepoints >= 80 then
									grade = "Tier03";
									if misses==0 then
										grade = "Tier02";
										if dancepoints >= 99 then
											grade = "Tier01";
											if dancepoints == 100 then
												grade = "Tier00";
											end
										end
									end
								end
							end
						end
					else
						grade = "Tier07";
					end


				--SCREENMAN:SystemMessage(grade);
				self:Load(THEME:GetPathG("","GradeDisplayPane/"..grade));
			else
				--if no score
				self:diffusealpha(0);
			end
		else
			--if no song
			self:diffusealpha(0);
		end;
	end;
	};




Def.Quad {
	InitCommand=cmd(diffuse,color("1,1,1,0.2");x,SCREEN_CENTER_X+255;y,SCREEN_CENTER_Y+115;zoomto,110,1;visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
};

		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		InitCommand=cmd(shadowlength,0.8;horizalign,right;draworder,100;x,SCREEN_CENTER_X+305;y,SCREEN_CENTER_Y+88-14;zoomx,0.39;zoomy,0.37;visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
		PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
		SetCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		if song then
			profile = PROFILEMAN:GetMachineProfile();
			scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_2));
			assert(scorelist);
			local scores = scorelist:GetHighScores();
			local topscore = scores[1];

			if topscore then
					text = topscore:GetName();
			else
					text = "No Score";
			end

			self:diffusealpha(1);
			if text=="EVNT" then
				self:settext("BEST");
			else
				self:settext(text);
			end
		else
			self:settext("---");
			self:diffusealpha(0.4);
		end
		end
};

LoadFont("venacti/_venacti_outline 26px bold monospace numbers")..{
		InitCommand=cmd(shadowlength,0.8;horizalign,left;draworder,100;x,SCREEN_CENTER_X+190;y,SCREEN_CENTER_Y+102-13;zoomx,0.375;zoomy,0.36;visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
		PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
		SetCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		if song then
			profile = PROFILEMAN:GetMachineProfile();
			scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_2));
			assert(scorelist);
			local scores = scorelist:GetHighScores();
			local topscore = scores[1];

			if topscore then
					text = scorecap(topscore:GetScore())
			else
					text = "0";
			end
			self:diffusealpha(1);
			self:settext(text);


		else
			self:settext("0");
			self:diffusealpha(0.4);
		end

		end
};

LoadFont("venacti/_venacti_outline 26px bold monospace numbers")..{
		InitCommand=cmd(shadowlength,0.8;horizalign,left;draworder,100;x,SCREEN_CENTER_X+196;y,SCREEN_CENTER_Y+102-1;zoomx,0.375;zoomy,0.36;visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
		PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
		SetCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		if song then
			profile = PROFILEMAN:GetMachineProfile();
			scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_2));
			assert(scorelist);
			local scores = scorelist:GetHighScores();
			local topscore = scores[1];

			if topscore then
					if string.find(PREFSMAN:GetPreference("VideoRenderers"), "d3d,") then
						text = math.floor(topscore:GetPercentDP()*100).."%"
					else
						text = (((math.floor(topscore:GetPercentDP()*100000))/1000).."%");
					end
			else
					text = "0%";
			end
			self:diffusealpha(1);
			self:settext(text);
		else
			self:settext("0%");
			self:diffusealpha(0.4);
		end

		end;
};

};
end;

t[#t+1] = Def.Quad {
	InitCommand=cmd(draworder,2;visible,true;diffuse,color("0,0,0,1");x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-100;scaletoclipped,260+1,160;diffusealpha,0.7);

}
--[[t[#t+1] = Def.Quad {
	InitCommand=cmd(draworder,2;visible,true;diffuse,color("1,0,0.2,0");x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-100;scaletoclipped,262,130;diffusealpha,0.4;fadetop,0.4;fadebottom,0.4);
]]--

-- BANNER CENTRAL -- BACKGROUND


t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-100);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		if song then
			self:linear(0.2)
			self:diffusealpha(1);
		else
			self:linear(0.2)
			self:diffusealpha(0);
		end
	end;
	Def.Quad {
		InitCommand=cmd(visible,true;diffuse,color("0,0,0,1");setsize,290,160;diffusealpha,1);
	};
	Def.Sprite {
		CurrentSongChangedMessageCommand=cmd(finishtweening;queuecommand,"ModifySongBackground");
		ModifySongBackgroundCommand=function(self)
			self:stoptweening();
			if GAMESTATE:GetCurrentSong() then
				self:LoadFromSongBackground(GAMESTATE:GetCurrentSong());
				--self:scaletoclipped(290,160);
				--self:cropto(200,200);
				--self:customtexturerect(100,100,100,100);
				--self:zoomto(290,160);
				--self:setsize(290,160);
				--self:SetWidth(290);
				self:scaletocover(-145,-80,145,80);
				local tex = self:GetTexture();
				if round(tex:GetImageWidth()/tex:GetImageHeight(), 1) == 1.3 then
					self:croptop(.13);
					self:cropbottom(.13);
				else
					self:croptop(0);
					self:cropbottom(0);
				end;
				--SCREENMAN:SystemMessage(tostring(tex:GetImageWidth()).." / "..tostring(tex:GetImageHeight()).." = "..tostring(tex:GetImageWidth()/tex:GetImageHeight()));
				
				self:diffusealpha(0);
				self:linear(0.5);
				self:diffusealpha(1);
			end;
		end;
	};
	Def.Sprite {
		CurrentSongChangedMessageCommand=cmd(finishtweening;queuecommand,"ModifySongBackground");

		ModifySongBackgroundCommand=function(self)
			self:stoptweening();
			if GAMESTATE:GetCurrentSong() ~= nil then
				if GAMESTATE:GetCurrentSong():HasPreviewVid() then
					--self:sleep(1);
					self:LoadBackground( GAMESTATE:GetCurrentSong():GetPreviewVidPath() );
					self:scaletofit(-145,-80,145,80);
					(cmd(visible,true;diffusealpha,0;bouncebegin,1;diffusealpha,1))(self);
				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end
		end;
	};
	Def.Quad{
		InitCommand=cmd(setsize,284,30;diffuse,color("0,0,0,.8");addy,65;fadetop,.2);
	};
	
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(addy,67;zoom,.5;maxwidth,530);
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				self:settext(song:GetDisplayFullTitle());
			else
				self:settext("");
			end;
		end;
	};
};

-- BANNER MASK

t[#t+1] = LoadActor("bannermask") .. {
	InitCommand=cmd(draworder,5;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-101;zoomy,0.58;zoomx,0.58);

};

t[#t+1] = LoadActor("A1") .. {
	InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X-133;y,SCREEN_CENTER_Y-100;draworder,2;diffusealpha,0);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	PreviousSongMessageCommand=cmd(horizalign,right;diffusealpha,0.9;stoptweening;zoomy,0.5;zoomx,0.5;linear,0.2;zoomx,0.3;diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,0);
	SongUnchosenMessageCommand=cmd(diffusealpha,0);
	ChangeStepsMessageCommand=function(self, params)
		if  params.Direction == 1 then
			--Nothing here???
		elseif params.Direction == -1 then
			self:stoptweening();
			self:horizalign(right);
			self:diffusealpha(0.7);
			self:zoomy(0.5);
			self:zoomx(0.5);
			self:linear(0.2);
			self:zoomx(0.2);
			self:diffusealpha(0);
		end;
	end;

}

t[#t+1] = LoadActor("A2") .. {
	InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X-133;y,SCREEN_CENTER_Y-100;draworder,2;diffusealpha,0);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	PreviousSongMessageCommand=cmd(horizalign,right;diffusealpha,0.9;stoptweening;zoomy,0.5;zoomx,0.5;linear,0.2;zoomx,0.3;diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,0);
	SongUnchosenMessageCommand=cmd(diffusealpha,0);
	ChangeStepsMessageCommand=function(self, params)
		if  params.Direction == 1 then
		elseif params.Direction == -1 then
		self:stoptweening();
		self:horizalign(right);
		self:diffusealpha(0.7);
		self:zoomy(0.5);
		self:zoomx(0.5);
		self:linear(0.2);
		self:zoomx(0.2);
		self:diffusealpha(0);
		end;
		end;

}


t[#t+1] = LoadActor("A1") .. {
	InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X+133;y,SCREEN_CENTER_Y-100;draworder,2;diffusealpha,0;rotationy,180);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	NextSongMessageCommand=cmd(horizalign,right;diffusealpha,0.9;stoptweening;zoomy,0.5;zoomx,0.5;linear,0.2;zoomx,0.3;diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,0);
	SongUnchosenMessageCommand=cmd(diffusealpha,0);
		ChangeStepsMessageCommand=function(self, params)
		if  params.Direction == 1 then
		self:stoptweening();
		self:horizalign(right);
		self:diffusealpha(0.7);
		self:zoomy(0.5);
		self:zoomx(0.5);
		self:linear(0.2);
		self:zoomx(0.2);
		self:diffusealpha(0);
		elseif params.Direction == -1 then
		end;
		end;
}

t[#t+1] = LoadActor("A2") .. {
	InitCommand=cmd(draworder,4;x,SCREEN_CENTER_X+133;y,SCREEN_CENTER_Y-100;draworder,2;diffusealpha,0;rotationy,180);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	NextSongMessageCommand=cmd(horizalign,right;diffusealpha,0.9;stoptweening;zoomy,0.5;zoomx,0.5;linear,0.2;zoomx,0.3;diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,0);
	SongUnchosenMessageCommand=cmd(diffusealpha,0);
		ChangeStepsMessageCommand=function(self, params)
		if  params.Direction == 1 then
		self:stoptweening();
		self:horizalign(right);
		self:diffusealpha(0.7);
		self:zoomy(0.5);
		self:zoomx(0.5);
		self:linear(0.2);
		self:zoomx(0.2);
		self:diffusealpha(0);
		elseif params.Direction == -1 then
		end;
		end;
}

--[[t[#t+1] = LoadActor("bannermaskleftlight") .. {
	InitCommand=cmd(diffusealpha,0;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-14;zoomy,0.52;zoomx,0.64;blend,Blend.Add);
	PreviousSongMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,0.15;linear,0.3;diffusealpha,0);
}

t[#t+1] = LoadActor("bannermaskrightlight") .. {
	InitCommand=cmd(diffusealpha,0;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-14;zoomy,0.52;zoomx,0.64;blend,Blend.Add);
	NextSongMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,0.15;linear,0.3;diffusealpha,0);
}]]--





-- aparte
--[[
t[#t+1] = LoadActor("wheel_mask") .. {
	InitCommand=cmd(draworder,80;x,SCREEN_CENTER_X-1;y,SCREEN_CENTER_Y;zoomy,0.675;zoomx,0.65;diffusealpha,0.75;cropbottom,0.0575);

};
t[#t+1] = LoadActor("wheel_selection") .. {
	InitCommand=cmd(draworder,80;x,SCREEN_CENTER_X-1;y,SCREEN_CENTER_Y;zoomy,0.675;zoomx,0.65;diffusealpha,0;cropbottom,0.0575);
SongChosenMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,1);
TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
SongUnchosenMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
};
]]



if GAMESTATE:IsSideJoined(PLAYER_1) then
	t[#t+1] = LoadActor("RadarsUnified", PLAYER_1) .. {
		InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
	};
end
if GAMESTATE:IsSideJoined(PLAYER_2) then
	t[#t+1] = LoadActor("RadarsUnified", PLAYER_2) .. {
		InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X+50;y,SCREEN_CENTER_Y+97;);
	};
end;





--[[t[#t+1] = LoadActor("cursor_body") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+3;zoom,0.675);

};]]


--Why is there two of them?
--[[
t[#t+1] = LoadActor("jacket_light") .. {
	InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X-1.5;y,SCREEN_CENTER_Y+3;effectclock,"bgm";zoom,0.675;blend,Blend.Add);

	SongChangedMessageCommand=cmd(playcommand,"CheckSteps");
	CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"CheckSteps");
	CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"CheckSteps");

	CheckStepsCommand=function(self,params)

		local stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1);
		local stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2);
		local threshold = THEME:GetMetric("SongManager","ExtraColorMeter");

			if not stepsP1 then
				meterP1 = 0
			else
				meterP1 = stepsP1:GetMeter()
			end

			if not stepsP2 then
				meterP2 = 0
			else
				meterP2 = stepsP2:GetMeter()
			end


			if meterP1>=threshold or meterP2>=threshold then
				self:playcommand("Extra");
			else
				self:playcommand("Normal");
			end;

	end;

	NormalCommand=cmd(blend,Blend.Add;diffuseshift;effectcolor1,color("#66BBFFFF");effectcolor2,color("#66BBFF33"));
	ExtraCommand=cmd(blend,Blend.Add;diffuseshift;effectcolor1,color("#FFCC00FF");effectcolor2,color("#FFCC0033"));

}
]]

t[#t+1] = LoadActor("jacket_light") .. {
	InitCommand=cmd(draworder,100;xy,SCREEN_CENTER_X,SCREEN_CENTER_Y+126;zoomx,.86;zoomy,.78;effectclock,"bgm";blend,Blend.Add);

	CurrentSongChangedMessageCommand=function(self)
		--local JacketOrBanner;
		local song = GAMESTATE:GetCurrentSong();
		self:finishtweening();
		self:linear(.5);
		if song then
			if song:HasJacket() then
				self:zoomx(.86);
				self:diffusealpha(1);
			elseif song:HasBanner() then
				self:zoomx(1.14);
				self:diffusealpha(1);
			end;
			--SCREENMAN:SystemMessage(
		else
			self:diffusealpha(0);
		end;
		self:playcommand("CheckSteps");
	end;
	CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"CheckSteps");
	CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"CheckSteps");

	CheckStepsCommand=function(self,params)

		local stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1);
		local stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2);
		local threshold = THEME:GetMetric("SongManager","ExtraColorMeter");

			if not stepsP1 then
				meterP1 = 0
			else
				meterP1 = stepsP1:GetMeter()
			end

			if not stepsP2 then
				meterP2 = 0
			else
				meterP2 = stepsP2:GetMeter()
			end


			if meterP1>=threshold or meterP2>=threshold then
				self:playcommand("Extra");
			else
				self:playcommand("Normal");
			end;

	end;

	NormalCommand=cmd(blend,Blend.Add;diffuseshift;effectcolor1,color("#88CCFFFF");effectcolor2,color("#88CCFF33"));
	ExtraCommand=cmd(blend,Blend.Add;diffuseshift;effectcolor1,color("#FFCC00FF");effectcolor2,color("#FFCC0033"));

}


t[#t+1] = LoadActor("leftpress") .. {
	InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X;vertalign,top;diffusealpha,0;zoom,0.675;blend,Blend.Add);
	PreviousSongMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,0.15;linear,0.3;diffusealpha,0);
}

t[#t+1] = LoadActor("rightpress") .. {
	InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X;vertalign,top;diffusealpha,0;zoom,0.675;blend,Blend.Add);
	NextSongMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,0.15;linear,0.3;diffusealpha,0);
}








-- DIFFICULT BAR

t[#t+1] = LoadActor(THEME:GetPathG("bg","diff_12"))..{
	InitCommand=cmd(draworder,7;vertalign,top;y,SCREEN_TOP-150;x,SCREEN_CENTER_X;zoomy,0.71;zoomx,0.665;visible,GAMESTATE:GetCurrentGame():GetName() == "pump");
	SongChosenMessageCommand=cmd(stoptweening;decelerate,0.25;y,SCREEN_TOP);
	TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;decelerate,0.25;y,SCREEN_TOP-150);
	SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.25;y,SCREEN_TOP-150);
}


t[#t+1] = LoadActor(THEME:GetPathG("","DifficultyDisplay"))..{
	InitCommand=cmd(draworder,8;vertalign,top;y,SCREEN_TOP-85;x,SCREEN_CENTER_X;visible,GAMESTATE:GetCurrentGame():GetName() == "pump");
	SongChosenMessageCommand=cmd(stoptweening;decelerate,0.25;y,SCREEN_TOP+15);
	TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;decelerate,0.25;y,SCREEN_TOP-85);
	SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.25;y,SCREEN_TOP-85);
}

-- LONG SONG

t[#t+1] = LoadActor("long_normal") .. {
	InitCommand=cmd(draworder,25;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-3;zoom,0.575);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	--PlayerJoinedMessageCommand=cmd(playcommand,"Init");
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsLong());
		else
		self:visible(false)
		end
	end;

};

t[#t+1] = LoadActor("long_add") .. {
	InitCommand=cmd(draworder,25;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-3;zoom,0.575;blend,Blend.Add);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	--PlayerJoinedMessageCommand=cmd(playcommand,"Init");
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFFD0");effectcolor2,color("#FFFFFF00"));
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsLong());
		else
		self:visible(false)
		end
	end;

};


t[#t+1] = LoadActor("marathon_normal") .. {
	InitCommand=cmd(draworder,25;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-3;zoom,0.575);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	--PlayerJoinedMessageCommand=cmd(playcommand,"Init");
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsMarathon());
		else
		self:visible(false)
		end
	end;

};

t[#t+1] = LoadActor("marathon_add") .. {
	InitCommand=cmd(draworder,25;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-3;zoom,0.575;blend,Blend.Add);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	--PlayerJoinedMessageCommand=cmd(playcommand,"Init");
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFFD0");effectcolor2,color("#FFFFFF00"));
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsMarathon());
		else
		self:visible(false)
		end
	end;

};

--[[


t[#t+1] = LoadActor("long_normal") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+3;zoom,0.675);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsLong());
		else
		self:visible(false)
		end
	end;

};

t[#t+1] = LoadActor("long_add") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+3;zoom,0.675;blend,Blend.Add);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFFD0");effectcolor2,color("#FFFFFF00"));
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsLong());
		else
		self:visible(false)
		end
	end;

};


t[#t+1] = LoadActor("marathon_normal") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+3;zoom,0.675);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsMarathon());
		else
		self:visible(false)
		end
	end;

};

t[#t+1] = LoadActor("marathon_add") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+3;zoom,0.675;blend,Blend.Add);
	SongChosenMessageCommand=cmd(diffusealpha,0);
	TwoPartConfirmCanceledMessageCommand=cmd(diffusealpha,1);
	SongUnchosenMessageCommand=cmd(diffusealpha,1);
	OnCommand=cmd(diffuseshift;effectcolor1,color("#FFFFFFD0");effectcolor2,color("#FFFFFF00"));
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
		self:visible(song:IsMarathon());
		else
		self:visible(false)
		end
	end;

};



]]--



--READY BANNER


t[#t+1] = LoadActor("rdy_add")..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-20;diffusealpha,0;zoom,0.8;draworder,100;blend,Blend.Multiply;);
	SongChosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,1);
	TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
	SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
};

t[#t+1] = LoadActor("rdy_add")..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-20;zoom,0.8;diffusealpha,0;draworder,100;blend,Blend.Add;);
	SongChosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,1);
	TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
	SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
};


t[#t+1] = LoadActor("rdy_sub")..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+17;zoom,0.75;diffusealpha,0;draworder,100;diffuse,0,0,0,0);
	SongChosenMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+17;diffusealpha,1);
	TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+37;diffusealpha,0);
	SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+37;diffusealpha,0);
};




t[#t+1] = LoadActor("rdy_logo")..{
	InitCommand=cmd(x,SCREEN_CENTER_X+3;y,SCREEN_CENTER_Y-42;zoom,0.4;draworder,100;thump;effectperiod,2;;diffuse,0,0,0,0;diffusetopedge,0.25,0.25,0.25,0);
	SongChosenMessageCommand=cmd(stoptweening;linear,0.2;;diffusealpha,1);
	TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;);
	SongUnchosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;);
};


t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-20;zoom,0.35;zoomy,0.325;shadowlengthy,0.8;draworder,100;diffuse,0.65,0.65,0.65,0;diffusetopedge,0.8,0.8,0.8,0);
	SongChosenMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y-18;diffusealpha,1);
	TwoPartConfirmCanceledMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+16;diffusealpha,0);
	SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;y,SCREEN_CENTER_Y+18;diffusealpha,0);
	Text=" - PRESS CENTER STEP TO START - "
};












t[#t+1] = Def.ActorFrame{
	LoadActor("mid")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+3;zoom,0.675);
		--OnCommand=cmd(draworder,1);
	};
};

t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay")..{
	InitCommand=cmd(draworder,100);
}


t[#t+1] = StandardDecorationFromFileOptional("SortOrder","SortOrderText") .. {
	BeginCommand=cmd(draworder,106;playcommand,"Set");
	SortOrderChangedMessageCommand=cmd(playcommand,"Set";);
	SetCommand=function(self)
		local s = SortOrderToLocalizedString( GAMESTATE:GetSortOrder() );
		self:settext( s );
		self:playcommand("Sort");
	end;
};

t[#t+1] = StandardDecorationFromFileOptional("SongTime","SongTime") .. {
	InitCommand=cmd(draworder,100);
	SetCommand=function(self)
		local curSelection = nil;
		local length = 0.0;
		if GAMESTATE:IsCourseMode() then
			curSelection = GAMESTATE:GetCurrentCourse();
			self:playcommand("Reset");
			if curSelection then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				if trail then
					length = TrailUtil.GetTotalSeconds(trail);
				else
					length = 0.0;
				end;
			else
				length = 0.0;
			end;
		else
			curSelection = GAMESTATE:GetCurrentSong();
			self:playcommand("Reset");
			if curSelection then
				length = curSelection:MusicLengthSeconds();
				if curSelection:IsLong() then
					self:playcommand("Long");
				elseif curSelection:IsMarathon() then
					self:playcommand("Marathon");
				else
					self:playcommand("Reset");
				end
			else
				length = 0.0;
				self:playcommand("Reset");
			end;
		end;
		self:settext( SecondsToMSS(length) );
	end;
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
}


t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(diffuse,0.6,0.6,0.6,1;diffusetopedge,1,1,1,1;draworder,100;horizalign,left;x,SCREEN_CENTER_X-98;y,SCREEN_CENTER_Y-2;zoomx,0.35;zoomy,0.35;shadowlengthy,1;shadowlengthx,0.8);
		Text="BPM"
}



t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(diffuse,0.6,0.6,0.6,1;diffusetopedge,1,1,1,1;draworder,100;horizalign,right;x,SCREEN_CENTER_X+98;y,SCREEN_CENTER_Y-2;zoomx,0.35;zoomy,0.35;shadowlengthy,1;shadowlengthx,0.8);
		Text="TIME"
}


t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(diffuse,0.6,0.6,0.6,1;diffusetopedge,1,1,1,1;draworder,100;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-2;zoomx,0.35;zoomy,0.35;shadowlengthy,1;shadowlengthx,0.8);
		Text="ARTIST"
}

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(maxwidth,350;draworder,100;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+22;zoomx,0.385;zoomy,0.38;shadowlength,1);
	OnCommand=cmd(diffusealpha,0;strokecolor,Color("Outline");shadowlength,1;sleep,0.3;linear,0.8;diffusealpha,1);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
			self:settext(song:GetDisplayArtist());
			self:diffusealpha(1);
		else
			self:settext("---")
			self:diffusealpha(0.3);
		end

	end;
}


t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(maxwidth,450;diffusetopedge,0.5,0.88,0.95,1;diffusebottomedge,1,1,1,1;uppercase,true;draworder,110;horizalign,center;x,SCREEN_WIDTH*.1;y,23;zoomx,0.385;zoomy,0.38;shadowlength,1);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
			self:settext(song:GetGroupName());
			self:diffusealpha(1);
		else
			self:settext("---")
			self:diffusealpha(0.3);
		end

	end;
}

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	Text="SORT";
	InitCommand=cmd(xy,SCREEN_WIDTH*.9,10;uppercase,true;draworder,101;strokecolor,Color("Outline");zoom,0.45;shadowlength,1);

};

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(diffusetopedge,0.5,0.88,0.95,1;diffusebottomedge,1,1,1,1;uppercase,true;draworder,110;horizalign,center;x,SCREEN_WIDTH*.9;y,23;zoomx,0.385;zoomy,0.38;shadowlength,1);
	CurrentSongChangedMessageCommand=function(self)
		self:settext(ToEnumShortString(GAMESTATE:GetSortOrder()));
	end;
}




--[[t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(draworder,110;maxwidth,720;diffusebottomedge,0.7,0.7,0.7,1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+137;zoomx,0.375;zoomy,0.38;shadowlength,0.8);
	SongChosenMessageCommand=cmd(hurrytweening,0.5);
	CurrentSongChangedMessageCommand=function(self)
		self:stoptweening();
		local song = GAMESTATE:GetCurrentSong()
		if song then
			self:settext(song:GetDisplayArtist());
			self:diffusealpha(0);
			self:sleep(0.35);
			self:linear(0.2);
			self:diffusealpha(1);
		else
			self:diffusealpha(0);
		end
	end;
}]]

--Use an ActorFrame, there should be no reason to copy and paste
--the same code twice and have all this extra logic. And there should be no need
--to position the graphic inside the Actor!!
--In fact, why was the join checking code inside the actor in the first place?
--You could have just put it outside the actor and added it here!!
--Even if you didn't know how to use args in LoadActor, you still
--would know how to do this!!
--[[t[#t+1] = LoadActor("JoinOverlay")..{
	InitCommand=cmd(draworder,110;visible,THEME:GetMetric("GameState", "AllowLateJoin"));
}]]
t[#t+1] = Def.ActorFrame{
	LoadActor("JoinOverlay")..{
		InitCommand=cmd(xy,SCREEN_WIDTH*.2,SCREEN_CENTER_Y;visible,THEME:GetMetric("GameState", "AllowLateJoin");playcommand,"RefreshPlayer");
		PlayerJoinedMessageCommand=cmd(playcommand,"RefreshPlayer");
		CoinModeChangedMessageCommand=cmd(playcommand,"RefreshPlayer");
		CoinInsertedMessageCommand=cmd(playcommand,"RefreshPlayer");
		RefreshPlayerCommand=function(self)
			self:visible(not GAMESTATE:IsHumanPlayer(PLAYER_1))
		end;
	};
	LoadActor("JoinOverlay")..{
		InitCommand=cmd(xy,SCREEN_WIDTH*.9,SCREEN_CENTER_Y;visible,THEME:GetMetric("GameState", "AllowLateJoin");playcommand,"RefreshPlayer");
		PlayerJoinedMessageCommand=cmd(playcommand,"RefreshPlayer");
		CoinModeChangedMessageCommand=cmd(playcommand,"RefreshPlayer");
		CoinInsertedMessageCommand=cmd(playcommand,"RefreshPlayer");
		RefreshPlayerCommand=function(self)
			self:visible(not GAMESTATE:IsHumanPlayer(PLAYER_2))
		end;
	};
};




t[#t+1] = LoadActor(THEME:GetPathG("","_press dance 5x2.png"))..{
	Frames = Sprite.LinearFrames(10,.3);
	InitCommand=cmd(x,SCREEN_CENTER_X-110;y,SCREEN_CENTER_Y-64;zoom,0.45;visible,false;draworder,100);
	SongChosenMessageCommand=cmd(setstate,0;visible,true);
	TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
	SongUnchosenMessageCommand=cmd(visible,false);
};
t[#t+1] = LoadActor(THEME:GetPathG("","_press dance 5x2.png"))..{
	Frames = Sprite.LinearFrames(10,.3);
	InitCommand=cmd(x,SCREEN_CENTER_X+110;y,SCREEN_CENTER_Y-64;zoom,0.45;visible,false;draworder,100);
	SongChosenMessageCommand=cmd(setstate,0;visible,true);
	TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
	SongUnchosenMessageCommand=cmd(visible,false);
};


--TODO: Fix PlayerJoinedMessageCommand
if GAMESTATE:IsSideJoined(PLAYER_1) then
	t[#t+1] = LoadActor(THEME:GetPathG("","PlayerSteps"), PLAYER_1)..{
		InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X-262;y,SCREEN_CENTER_Y+27);
		--OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
		--PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
		--CurrentStepsP1ChangedMessageCommand=cmd(stoptweening;diffusealpha,0;zoomx,0;decelerate,0.075;zoomx,1;diffusealpha,1);
	}
end;

if GAMESTATE:IsSideJoined(PLAYER_2) then
	t[#t+1] = LoadActor(THEME:GetPathG("","PlayerSteps"), PLAYER_2)..{
		InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X+232;y,SCREEN_CENTER_Y+27);
		--OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
		--PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
		--CurrentStepsP2ChangedMessageCommand=cmd(stoptweening;zoomx,0;diffusealpha,0;decelerate,0.075;zoomx,1;diffusealpha,1);
	}
end;


t[#t+1] = LoadActor(THEME:GetPathS("","EX_Confirm"))..{
CodeMessageCommand = function(self, params)

	if params.PlayerNumber == PLAYER_1 then
		--=============================================================
		if params.Name == 'SpeedUp' then
			self:play()

			local P1State = GAMESTATE:GetPlayerState(PLAYER_1);
			local P1Options = P1State:GetPlayerOptionsString("ModsLevel_Preferred");
			--local Speed = (P1State:GetCurrentPlayerOptions():GetXMod()+1).."x";


			--[[if Speed == nil then
				Speed = "1.5x";
			end

			local XMod = P1State:GetCurrentPlayerOptions():GetXMod()
			if XMod >= 7.25 then
				Speed = "1.5x";
			end]]
			local speed = P1State:GetCurrentPlayerOptions():XMod()[0];




				--P1State:SetPlayerOptions("ModsLevel_Preferred", P1Options..","..Speed..","..FailMode());


		end
		--=============================================================
		if params.Name == 'SpeedDown' then
			self:play()

			local P1State = GAMESTATE:GetPlayerState(PLAYER_1);
			local P1Options = P1State:GetPlayerOptionsString("ModsLevel_Preferred");
			local Speed = (P1State:GetCurrentPlayerOptions():GetXMod()-1).."x";

			if Speed == nil then
				Speed = "1.5x";
			end

			local XMod = P1State:GetCurrentPlayerOptions():GetXMod()
			if XMod <= 2 then
				Speed = "8x";
			end



				P1State:SetPlayerOptions("ModsLevel_Preferred", P1Options..","..Speed..","..FailMode());


		end
		--=============================================================
		if params.Name == 'SpeedHalfUp' then
			self:play()

			local P1State = GAMESTATE:GetPlayerState(PLAYER_1);
			local P1Options = P1State:GetPlayerOptionsString("ModsLevel_Preferred");
			local Speed = (P1State:GetCurrentPlayerOptions():GetXMod()+0.5).."x";

			if Speed == nil then
				Speed = "1.5x";
			end

			local XMod = P1State:GetCurrentPlayerOptions():GetXMod()
			if XMod >= 7.75 then
				Speed = "1.5x";
			end



				P1State:SetPlayerOptions("ModsLevel_Preferred", P1Options..","..Speed..","..FailMode());


		end
		--=============================================================
		if params.Name == 'SpeedHalfDown' then
			self:play()

			local P1State = GAMESTATE:GetPlayerState(PLAYER_1);
			local P1Options = P1State:GetPlayerOptionsString("ModsLevel_Preferred");
			local Speed = (P1State:GetCurrentPlayerOptions():GetXMod()-0.5).."x";

			if Speed == nil then
				Speed = "1.5x";
			end

			local XMod = P1State:GetCurrentPlayerOptions():GetXMod()
			if XMod <= 1.5 then
				Speed = "8x";
			end



				P1State:SetPlayerOptions("ModsLevel_Preferred", P1Options..","..Speed..","..FailMode());


		end
		--=============================================================
		if params.Name == 'SpeedQuarterUp' then
			self:play()

			local P1State = GAMESTATE:GetPlayerState(PLAYER_1);
			local P1Options = P1State:GetPlayerOptionsString("ModsLevel_Preferred");
			local Speed = (P1State:GetCurrentPlayerOptions():GetXMod()+0.25).."x";

			if Speed == nil then
				Speed = "1.5x";
			end

			local XMod = P1State:GetCurrentPlayerOptions():GetXMod()
			if XMod >= 8 then
				Speed = "1.5x";
			end



				P1State:SetPlayerOptions("ModsLevel_Preferred", P1Options..","..Speed..","..FailMode());


		end
		--=============================================================
		if params.Name == 'SpeedQuarterDown' then
			self:play()

			local P1State = GAMESTATE:GetPlayerState(PLAYER_1);
			local P1Options = P1State:GetPlayerOptionsString("ModsLevel_Preferred");
			local Speed = (P1State:GetCurrentPlayerOptions():GetXMod()-0.25).."x";

			if Speed == nil then
				Speed = "1.5x";
			end

			local XMod = P1State:GetCurrentPlayerOptions():GetXMod()
			if XMod <= 1.5 then
				Speed = "8x";
			end



				P1State:SetPlayerOptions("ModsLevel_Preferred", P1Options..","..Speed..","..FailMode());


		end
		--=============================================================



		--SCREENMAN:SystemMessage(GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptionsString("ModsLevel_Preferred"));

	end
end
}





t[#t+1] = LoadActor(THEME:GetPathS("","EX_Confirm"))..{
CodeMessageCommand = function(self, params)
	if params.PlayerNumber == PLAYER_2 then
		--SCREENMAN:SystemMessage(GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptionsString("ModsLevel_Preferred"));
		--SCREENMAN:SystemMessage(GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptionsArray("ModsLevel_Preferred")[3]);
		--=============================================================
		if params.Name == 'SpeedUp' then
			self:play()

			local P2State = GAMESTATE:GetPlayerState(PLAYER_2);
			local P2Options = P2State:GetPlayerOptionsString("ModsLevel_Preferred");
			local Speed = (P2State:GetCurrentPlayerOptions():GetXMod()+1).."x";

			if Speed == nil then
				Speed = "1.5x";
			end

			local XMod = P2State:GetCurrentPlayerOptions():GetXMod()
			if XMod >= 7.25 then
				Speed = "1.5x";
			end


				P2State:SetPlayerOptions("ModsLevel_Preferred", P2Options..","..Speed..","..FailMode());


		end
		--=============================================================
		if params.Name == 'SpeedDown' then
			self:play()

			local P2State = GAMESTATE:GetPlayerState(PLAYER_2);
			local P2Options = P2State:GetPlayerOptionsString("ModsLevel_Preferred");
			local Speed = (P2State:GetCurrentPlayerOptions():GetXMod()-1).."x";

			if Speed == nil then
				Speed = "1.5x";
			end

			local XMod = P2State:GetCurrentPlayerOptions():GetXMod()
			if XMod <= 2 then
				Speed = "8x";
			end


				P2State:SetPlayerOptions("ModsLevel_Preferred", P2Options..","..Speed..","..FailMode());


		end
		--=============================================================
		if params.Name == 'SpeedHalfUp' then
			self:play()

			local P2State = GAMESTATE:GetPlayerState(PLAYER_2);
			local P2Options = P2State:GetPlayerOptionsString("ModsLevel_Preferred");
			local Speed = (P2State:GetCurrentPlayerOptions():GetXMod()+0.5).."x";

			if Speed == nil then
				Speed = "1.5x";
			end

			local XMod = P2State:GetCurrentPlayerOptions():GetXMod()
			if XMod >= 7.75 then
				Speed = "1.5x";
			end


				P2State:SetPlayerOptions("ModsLevel_Preferred", P2Options..","..Speed..","..FailMode());



		end
		--=============================================================
		if params.Name == 'SpeedHalfDown' then
			self:play()

			local P2State = GAMESTATE:GetPlayerState(PLAYER_2);
			local P2Options = P2State:GetPlayerOptionsString("ModsLevel_Preferred");
			local Speed = (P2State:GetCurrentPlayerOptions():GetXMod()-0.5).."x";

			if Speed == nil then
				Speed = "1.5x";
			end

			local XMod = P2State:GetCurrentPlayerOptions():GetXMod()
			if XMod <= 1.5 then
				Speed = "8x";
			end


				P2State:SetPlayerOptions("ModsLevel_Preferred", P2Options..","..Speed..","..FailMode());


		end
		--=============================================================
		if params.Name == 'SpeedQuarterUp' then
			self:play()

			local P2State = GAMESTATE:GetPlayerState(PLAYER_2);
			local P2Options = P2State:GetPlayerOptionsString("ModsLevel_Preferred");
			local Speed = (P2State:GetCurrentPlayerOptions():GetXMod()+0.25).."x";

			if Speed == nil then
				Speed = "1.5x";
			end

			local XMod = P2State:GetCurrentPlayerOptions():GetXMod()
			if XMod >= 8 then
				Speed = "1.5x";
			end



				P2State:SetPlayerOptions("ModsLevel_Preferred", P2Options..","..Speed..","..FailMode());


		end
		--=============================================================
		if params.Name == 'SpeedQuarterDown' then
			self:play()

			local P2State = GAMESTATE:GetPlayerState(PLAYER_2);
			local P2Options = P2State:GetPlayerOptionsString("ModsLevel_Preferred");
			local Speed = (P2State:GetCurrentPlayerOptions():GetXMod()-0.25).."x";

			if Speed == nil then
				Speed = "1.5x";
			end

			local XMod = P2State:GetCurrentPlayerOptions():GetXMod()
			if XMod <= 1.5 then
				Speed = "8x";
			end



				P2State:SetPlayerOptions("ModsLevel_Preferred", P2Options..","..Speed..","..FailMode());


		end
		--=============================================================





	end
end
}

--enabled again because noteskins aren't working
--requires further testing


t[#t+1] = LoadActor(THEME:GetPathS("","EX_Confirm"))..{

	CodeMessageCommand=function(self,params)
		if params.Name == 'GameLevelUp' then


			if GetUserPref("UserPrefGameLevel") == "Pro" then
				self:play()
				SetUserPref("UserPrefGameLevel","Ultimate");
				WritePrefToFile("UserPrefGameLevel","Ultimate");
				SCREENMAN:SystemMessage("Game Level changed to ULTIMATE");
			end


			if GetUserPref("UserPrefGameLevel") == "Standard" then
				self:play()
				SetUserPref("UserPrefGameLevel","Pro");
				WritePrefToFile("UserPrefGameLevel","Pro");
				SCREENMAN:SystemMessage("Game Level changed to PRO");
			end

			if GetUserPref("UserPrefGameLevel") == "Beginner" then
				self:play()
				SetUserPref("UserPrefGameLevel","Standard");
				WritePrefToFile("UserPrefGameLevel","Standard");
				SCREENMAN:SystemMessage("Game Level changed to STANDARD");
			end

		end;


	end
};

t[#t+1] = LoadActor(THEME:GetPathS("","EX_Confirm"))..{
	CodeMessageCommand=function(self,params)
		--SCREENMAN:SystemMessage("sdfsdf");
		if params.Name == 'GameLevelDown' then


			if GetUserPref("UserPrefGameLevel") == "Standard" then
				self:play()
				SetUserPref("UserPrefGameLevel","Beginner");
				WritePrefToFile("UserPrefGameLevel","Beginner");
				SCREENMAN:SystemMessage("Game Level changed to BEGINNER");
			end


			if GetUserPref("UserPrefGameLevel") == "Pro" then
				self:play()
				SetUserPref("UserPrefGameLevel","Standard");
				WritePrefToFile("UserPrefGameLevel","Standard");
				SCREENMAN:SystemMessage("Game Level changed to STANDARD");
			end

			if GetUserPref("UserPrefGameLevel") == "Ultimate" then
				self:play()
				SetUserPref("UserPrefGameLevel","Pro");
				WritePrefToFile("UserPrefGameLevel","Pro");
				SCREENMAN:SystemMessage("Game Level changed to PRO");
			end

		end;

	end
};



t[#t+1] = LoadActor(THEME:GetPathS("","EX_Select"))..{
CodeMessageCommand = function(self, params)
	if params.Name == 'OpenOpList' then
	--if params.PlayerNumber == pn then
	SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
	end
end;
};


--[[t[#t+1] = LoadActor("light_mid") .. {
	InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X;effectclock,"bgm";vertalign,top;zoom,0.675;blend,Blend.Add;diffuseshift;effectcolor1,color("#FFFFFF55");effectcolor2,color("#FFFFFFCC");visible,GetUserPrefB("UserPrefLite"));

}]]

--I love having seizures! /s
--Change it to true if you want the flashing lights back.
t[#t+1] = LoadActor(THEME:GetPathG("","header"), false)..{
	InitCommand=cmd(draworder,100);
}


--TITLE
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,100;rotationx,30;diffuse,0.08,0.08,0.08,1;diffusetopedge,0.2,0.2,0.2,1;shadowlengthy,-1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_TOP+37;zoomx,0.7;zoomy,0.725;);
		Text="SELECT MUSIC";
		SongChosenMessageCommand=cmd(settext,"SELECT DIFFICULTY");
		TwoPartConfirmCanceledMessageCommand=cmd(settext,"SELECT MUSIC");
		SongUnchosenMessageCommand=cmd(settext,"SELECT MUSIC");
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

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,-0.8;shadowlength,-0.8;horizalign,left;x,SCREEN_CENTER_X+185 ;y,SCREEN_TOP+16;zoom,0.40);
		Text="TIMER"
}

--STAGE

t[#t+1] = LoadActor("B0") .. {
	InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X-190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,0.55);

};

t[#t+1] = LoadActor("B1") .. {
	InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X-160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,0.6);

};

t[#t+1] = LoadActor("B2") .. {
	InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X-160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,0.6);

};

t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,0.8;shadowlengthy,-0.8;horizalign,right;x,SCREEN_CENTER_X-185;y,SCREEN_TOP+16;zoom,0.40);
		Text="STAGE"
}

t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
	InitCommand=cmd(draworder,102;diffuse,0.9,0.9,0.9,0.9;uppercase,true;horizalign,center;x,SCREEN_CENTER_X-160;maxwidth,45;zoomx,0.58;zoomy,0.58;y,SCREEN_TOP+25;shadowlengthx,1;shadowlengthy,-1);
	OnCommand=function(self)
		local stageNum=GAMESTATE:GetCurrentStageIndex()+1
		if stageNum < 10 then
			self:settext("0"..stageNum);
		else
			self:settext(stageNum);
		end
	end;
}



t[#t+1] = Def.Quad {
	InitCommand=cmd(horizalign,right;draworder,100;faderight,1;;zoomto,120,SCREEN_HEIGHT;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X-320;diffuse,0,0,0,1);
}
t[#t+1] = Def.Quad {
	InitCommand=cmd(horizalign,left;draworder,100;fadeleft,1;;zoomto,120,SCREEN_HEIGHT;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X+320;diffuse,0,0,0,1);
}








--speedmods

t[#t+1] = LoadActor("optionIcon")..{
	InitCommand=cmd(draworder,100;x,SCREEN_LEFT+5;y,SCREEN_CENTER_Y-22;zoomy,0.34;zoomx,0.425;horizalign,left;diffusealpha,0.75;visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
	}
t[#t+1] = LoadActor("optionIcon")..{
	InitCommand=cmd(draworder,100;x,SCREEN_RIGHT-5;y,SCREEN_CENTER_Y-22;zoomy,0.34;zoomx,0.425;horizalign,right;diffusealpha,0.75;visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
	}



-- noteskin

t[#t+1] = LoadActor("optionIcon")..{
	InitCommand=cmd(draworder,100;x,SCREEN_LEFT+50;y,SCREEN_CENTER_Y-22;zoomy,0.34;zoomx,0.425;horizalign,left;diffusealpha,0.75;visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
	}
t[#t+1] = LoadActor("optionIcon")..{
	InitCommand=cmd(draworder,100;x,SCREEN_RIGHT-50;y,SCREEN_CENTER_Y-22;zoomy,0.34;zoomx,0.425;horizalign,right;diffusealpha,0.75;visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
}


local function CurrentNoteSkin(p)
        local state = GAMESTATE:GetPlayerState(p)
        local mods = state:GetPlayerOptionsArray( 'ModsLevel_Preferred' )
        local skins = NOTESKIN:GetNoteSkinNames()

        for i = 1, #mods do
            for j = 1, #skins do
                if string.lower( mods[i] ) == string.lower( skins[j] ) then
                   return skins[j];
                end
            end
        end

end

t[#t+1] = Def.Sprite{
	InitCommand=cmd(draworder,100;);
	OnCommand=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
		if CurrentNoteSkin(PLAYER_1) == "delta" then
			self:Load(NOTESKIN:GetPathForNoteSkin("UpLeft", "Ready receptor", CurrentNoteSkin(PLAYER_1)));
			self:croptop(0);
			self:cropright(0);
			self:x(SCREEN_LEFT+75-3);
			self:y(SCREEN_CENTER_Y-22);
			self:zoom(0.35);
		else
			self:Load(NOTESKIN:GetPathForNoteSkin("Upleft", "Tap note", CurrentNoteSkin(PLAYER_1)));
			self:croptop(0);
			self:cropright(0);
			self:x(SCREEN_LEFT+75-3);
			self:y(SCREEN_CENTER_Y-22);
			self:zoom(0.35);
		end
	end;
	OptionsListClosedMessageCommand=cmd(queuecommand,"On");
	PlayerJoinedMessageCommand=cmd(queuecommand,"On");
	PlayerUnjoinedMessageCommand=cmd(playcommand,"On");
	CodeMessageCommand=cmd(playcommand,"On");
}


t[#t+1] = Def.Sprite{
	--InitCommand=cmd(x,SCREEN_RIGHT-22;y,SCREEN_CENTER_Y-58+8;draworder,102;zoom,0.575);
	InitCommand=cmd(draworder,100;);
	OnCommand=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2));
		if CurrentNoteSkin(PLAYER_2) == "delta" then
			self:Load(NOTESKIN:GetPathForNoteSkin("Upleft", "Ready receptor", CurrentNoteSkin(PLAYER_2)));
			self:croptop(0);
			self:cropright(0);
			self:x(SCREEN_RIGHT-75+3);
			self:y(SCREEN_CENTER_Y-22);
			self:zoom(0.35);
			self:zoomx(-0.35);
		elseif CurrentNoteSkin(PLAYER_2) == "alisson" then
			self:Load(NOTESKIN:GetPathForNoteSkin("Upright", "Tap note", CurrentNoteSkin(PLAYER_2)));
			self:croptop(0);
			self:cropright(0);
			self:x(SCREEN_RIGHT-75+3);
			self:y(SCREEN_CENTER_Y-22);
			self:zoomy(0.35);
			self:zoomx(-0.35);
		else
			self:Load(NOTESKIN:GetPathForNoteSkin("Upleft", "Tap note", CurrentNoteSkin(PLAYER_2)));
			self:croptop(0);
			self:cropright(0);
			self:x(SCREEN_RIGHT-75+3);
			self:y(SCREEN_CENTER_Y-22);
			self:zoom(0.35);
			self:zoomx(-0.35);
		end
	end;
	OptionsListClosedMessageCommand=cmd(queuecommand,"On");
	PlayerJoinedMessageCommand=cmd(queuecommand,"On");
	PlayerUnjoinedMessageCommand=cmd(playcommand,"On");
	CodeMessageCommand=cmd(playcommand,"On");
};

--fonts--
--speed--

t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	InitCommand=cmd(draworder,100;x,SCREEN_LEFT+27;y,SCREEN_CENTER_Y-22;zoomx,0.41;zoomy,0.38;diffusebottomedge,0.7,0.7,0.7,1;maxwidth,55;shadowlength,0.8);
	--OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);settext,(math.ceil(GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():XMod()*100)/100).."x");
	--sleep,0.1;queuecommand,"On");
	OptionsListClosedMessageCommand=cmd(settext,(math.ceil(GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():GetXMod()*100)/100).."x");
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);settext,(math.ceil(GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():XMod()*100)/100).."x");
	CodeMessageCommand=function(self)
		self:stoptweening()
		self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
		self:settext((math.ceil(GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():XMod()*100)/100).."x");
	end;
}
t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	InitCommand=cmd(draworder,100;x,SCREEN_RIGHT-26;y,SCREEN_CENTER_Y-22;zoomx,0.41;zoomy,0.38;diffusebottomedge,0.7,0.7,0.7,1;maxwidth,55;shadowlength,0.8);
	OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);settext,(math.ceil(GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():XMod()*100)/100).."x");
	--sleep,0.1;queuecommand,"On");
	OptionsListClosedMessageCommand=cmd(settext,(math.ceil(GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():GetXMod()*100)/100).."x");
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);settext,(math.ceil(GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():GetXMod()*100)/100).."x");
	CodeMessageCommand=function(self)
		self:stoptweening()
		self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2));
		self:settext((math.ceil(GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():XMod()*100)/100).."x");
	end;

}


t[#t+1] = LoadActor("optionFlash")..{
	InitCommand=cmd(draworder,100;x,SCREEN_LEFT+26;y,SCREEN_CENTER_Y-22;zoomy,0.34;zoomx,0.425;diffuse,1,1,1,0;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);sleep,0.1;blend,Blend.Add;queuecommand,"Init");
	CodeMessageCommand=function(self,params)
	if params.PlayerNumber == PLAYER_1 then
		if params.Name == 'SpeedUp' or
		params.Name == 'SpeedDown' or
		params.Name == 'SpeedHalfUp' or
		params.Name == 'SpeedHalfDown' or
		params.Name == 'SpeedQuarterUp' or
		params.Name == 'SpeedQuarterDown' then
		self:stoptweening();
		self:diffusealpha(1);
		self:sleep(0.1);
		self:linear(0.3)
		self:diffusealpha(0);
		end
	end
	end
}
t[#t+1] = LoadActor("optionFlash")..{
	InitCommand=cmd(draworder,100;x,SCREEN_RIGHT-26;y,SCREEN_CENTER_Y-22;zoomy,0.34;zoomx,0.425;diffuse,1,1,1,0;visible,GAMESTATE:IsHumanPlayer(PLAYER_2);sleep,0.1;blend,Blend.Add;queuecommand,"Init");
	CodeMessageCommand=function(self,params)
	if params.PlayerNumber == PLAYER_2 then
		if params.Name == 'SpeedUp' or
		params.Name == 'SpeedDown' or
		params.Name == 'SpeedHalfUp' or
		params.Name == 'SpeedHalfDown' or
		params.Name == 'SpeedQuarterUp' or
		params.Name == 'SpeedQuarterDown' then
		self:stoptweening();
		self:diffusealpha(1);
		self:sleep(0.1);
		self:linear(0.3)
		self:diffusealpha(0);
		end
	end
	end
}



--[[t[#t+1] = LoadActor(THEME:GetPathG("","light"))..{
	InitCommand=cmd(draworder,104);
}]]



for pn in ivalues(PlayerNumber) do


t[#t+1] = LoadActor("oplist") ..{
InitCommand=cmd(draworder,100;diffuse,color("1,0.95,0.9,0");zoom,0.675;Center;diffusealpha,0;blend,Blend.Add);

		OptionsListOpenedMessageCommand=function(self,params)
			if params.Player == pn then
				if pn == PLAYER_1 then
					self:zoomx(0.675);

				elseif pn == PLAYER_2 then
					self:zoomx(-0.675);

				end

				self:playcommand("Open");
			end
		end;


		OpenCommand=cmd(stoptweening;decelerate,0.3;diffusealpha,1;);
		OptionsListClosedMessageCommand=function(self,params)
			if params.Player == pn then

				self:stoptweening();
				self:accelerate(0.3);
				self:diffusealpha(0);

			end
		end;

}




t[#t+1] = LoadActor("oplist") ..{
InitCommand=cmd(draworder,100;diffuse,color("0.3,0.3,0.3,0");zoom,0.675;Center;diffusealpha,0;);

		OptionsListOpenedMessageCommand=function(self,params)
			if params.Player == pn then
				if pn == PLAYER_1 then
					self:zoomx(0.775);

				elseif pn == PLAYER_2 then
					self:zoomx(-0.775);

				end

				self:playcommand("Open");
			end
		end;


		OpenCommand=cmd(stoptweening;decelerate,0.3;diffusealpha,0.95;);
		OptionsListClosedMessageCommand=function(self,params)
			if params.Player == pn then

				self:stoptweening();
				self:accelerate(0.3);
				self:diffusealpha(0);

			end
		end;

}

end





t[#t+1] = LoadActor(THEME:GetPathG("","footer"))..{
	InitCommand=cmd(draworder,130);
};

--next/prev indicator
--[[
t[#t+1] = LoadActor(THEME:GetPathG("","downTap"))..{
	InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X-156;y,SCREEN_CENTER_Y+130;zoom,0.55);
	PreviousSongMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X-159;sleep,0.12;decelerate,0.2;x,SCREEN_CENTER_X-156);
}


t[#t+1] = LoadActor(THEME:GetPathG("","downTap"))..{
	InitCommand=cmd(draworder,100;x,SCREEN_CENTER_X+156;y,SCREEN_CENTER_Y+130;zoomy,0.55;zoomx,-0.55);
	NextSongMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X+159;sleep,0.12;decelerate,0.2;x,SCREEN_CENTER_X+156);
}]]

t[#t+1] = LoadActor(THEME:GetPathG("", "downTap/arrow_left"))..{
		InitCommand=cmd(draworder,131;horizalign,left;vertalign,bottom;xy,SCREEN_LEFT,SCREEN_BOTTOM;zoom,.675;);
		PreviousSongMessageCommand=cmd(stoptweening;glow,color("1,1,1,.8");xy,SCREEN_LEFT-5,SCREEN_BOTTOM+5;sleep,.12;decelerate,.2;glow,color("0,0,0,0");xy,SCREEN_LEFT,SCREEN_BOTTOM;);
	};
t[#t+1] = LoadActor(THEME:GetPathG("", "downTap/arrow_right"))..{
		InitCommand=cmd(draworder,131;horizalign,right;vertalign,bottom;xy,SCREEN_RIGHT,SCREEN_BOTTOM;zoom,.675;);
		NextSongMessageCommand=cmd(stoptweening;glow,color("1,1,1,.8");xy,SCREEN_RIGHT+5,SCREEN_BOTTOM+5;sleep,.12;decelerate,.2;glow,color("0,0,0,0");xy,SCREEN_RIGHT,SCREEN_BOTTOM;);
	};

--t[#t+1] = LoadActor("_arrows")..{InitCommand=cmd(draworder,131);};

t[#t+1] = LoadActor(THEME:GetPathS("","EX_Move"))..{
	PreviousGroupMessageCommand=cmd(play);
	NextGroupMessageCommand=cmd(play);
	OptionsListOpenedMessageCommand=cmd(play);
	OptionsListClosedMessageCommand=cmd(play);
	OptionsListRightMessageCommand=cmd(play);
	OptionsListLeftMessageCommand=cmd(play);
	OptionsListQuickChangeMessageCommand=cmd(play);
}
t[#t+1] = LoadActor(THEME:GetPathS("","EX_Confirm"))..{
	OptionsListClosedMessageCommand=cmd(play);
	OptionsListStartMessageCommand=cmd(play);
	OptionsListResetMessageCommand=cmd(play);
}
t[#t+1] = LoadActor(THEME:GetPathS("","EX_Select"))..{
	OptionsListPopMessageCommand=cmd(play);
	OptionsListPushMessageCommand=cmd(play);
}
t[#t+1] = LoadActor(THEME:GetPathS("","Common Cancel"))..{
	SongUnchosenMessageCommand=cmd(play);
}

t[#t+1] = LoadActor(THEME:GetPathS("","SSM_Select"))..{
	SongChosenMessageCommand=cmd(play);
	StepsChosenMessageCommand=cmd(play);
}
t[#t+1] = LoadActor(THEME:GetPathS("","SSM_Confirm"))..{
	OffCommand=cmd(play);
}



t[#t+1] = Def.Quad {
		InitCommand=cmd(draworder,900;Center;zoomto,SCREEN_WIDTH+1,SCREEN_HEIGHT);
		OnCommand=cmd(diffuse,color("0,0,0,0"));
		OffCommand=cmd(linear,0.2;diffusealpha,1);
};









return t;
