local player = ...
if not player then SCREENMAN:SystemMessage("Need a player, dingus"); end;
return Def.ActorFrame{
	--[[
	InitCommand=cmd(visible,false);
	SongChosenMessageCommand=cmd(visible,true);
	TwoPartConfirmCanceledMessageCommand=cmd(visible,false);
	SongUnchosenMessageCommand=cmd(visible,false);]]
	InitCommand=cmd(xy,230,-250);

	Def.Sprite{
		InitCommand=cmd(skewx,-0.1;draworder,100;x,-86;y,SCREEN_CENTER_Y+92;zoom,0.525;fadetop,1;);
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
		PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(player);queuecommand,"Set");
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				self:diffusealpha(1);
				profile = PROFILEMAN:GetMachineProfile();
				scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(player));
				assert(scorelist);
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];

					if topscore then

								local dancepoints = topscore:GetPercentDP()*100
								local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
								local grade;


						--TODO: Fix this garbage
						if dancepoints == 100 then
							grade = "Tier00";
						--PIU ONLY!!
						elseif misses==0 and GAMESTATE:GetCurrentGame():GetName() == "pump" then
							grade = "Tier02";
						elseif dancepoints >= 99 then
							grade = "Tier01";
						elseif dancepoints >= 80 then
							grade = "Tier03";
						elseif dancepoints >= 70 then
							grade = "Tier04";
						elseif dancepoints >= 60 then
							grade = "Tier05";
						elseif dancepoints >= 50 then
							grade = "Tier06";
						--?????
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
		InitCommand=cmd(diffuse,color("1,1,1,0.2");x,-66;y,SCREEN_CENTER_Y+115;zoomto,110,1;visible,GAMESTATE:IsHumanPlayer(player));
		PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(player));
	};

	--(((math.floor(topscore:GetPercentDP()*100000))/1000).."%");

		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=cmd(shadowlength,0.8;horizalign,left;draworder,100;x,-116;y,SCREEN_CENTER_Y+88-14;zoomx,0.39;zoomy,0.37;visible,GAMESTATE:IsHumanPlayer(player);queuecommand,"Set");
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			['CurrentSteps'..ToEnumShortString(player)..'ChangedMessageCommand']=cmd(playcommand,"Set");
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(player);queuecommand,"Set");
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				if song and GAMESTATE:GetCurrentSteps(player) then
					profile = PROFILEMAN:GetMachineProfile();
					scorelist = profile:GetHighScoreList(song,GAMESTATE:GetCurrentSteps(player));
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
		InitCommand=cmd(shadowlength,0.8;horizalign,right;draworder,100;y,SCREEN_CENTER_Y+102-13;zoomx,0.375;zoomy,0.36;visible,GAMESTATE:IsHumanPlayer(player);queuecommand,"Set");
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		['CurrentSteps'..ToEnumShortString(player)..'ChangedMessageCommand']=cmd(playcommand,"Set");
		PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(player);queuecommand,"Set");
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song and GAMESTATE:GetCurrentSteps(player) then
				profile = PROFILEMAN:GetMachineProfile();
				scorelist = profile:GetHighScoreList(song,GAMESTATE:GetCurrentSteps(player));
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
		InitCommand=cmd(shadowlength,0.8;horizalign,right;draworder,100;x,-4;y,SCREEN_CENTER_Y+102-1;zoomx,0.375;zoomy,0.36;visible,GAMESTATE:IsHumanPlayer(player);queuecommand,"Set");
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		['CurrentSteps'..ToEnumShortString(player)..'ChangedMessageCommand']=cmd(playcommand,"Set");
		PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(player);queuecommand,"Set");
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song and GAMESTATE:GetCurrentSteps(player) then
				profile = PROFILEMAN:GetMachineProfile();
				scorelist = profile:GetHighScoreList(song,GAMESTATE:GetCurrentSteps(player));
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
				end;
				self:diffusealpha(1);
				self:settext(text);
			else
				self:settext("0%");
				self:diffusealpha(0.4);
			end;

		end;
	};
};
