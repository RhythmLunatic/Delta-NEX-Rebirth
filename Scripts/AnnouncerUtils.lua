function ANNOUNCER_PlaySound(category, name)
	local announcer = ANNOUNCER:GetCurrentAnnouncer();
	if announcer ~= nil then
		local file = "";
		local fullpath = "Announcers/"..announcer.."/"..category.."/"..name
		--SCREENMAN:SystemMessage("ANN. UTILS: "..fullpath);
		local wav = fullpath..".wav"
		local ogg = fullpath..".ogg"
		local mp3 = fullpath..".mp3"
		
		if (FILEMAN:DoesFileExist(ogg)) then file = ogg;
		elseif (FILEMAN:DoesFileExist(mp3)) then file = mp3;
		elseif (FILEMAN:DoesFileExist(wav)) then file = wav;
		else
			return false;
		end;
			
		SOUND:PlayOnce(file);
	else
		--SCREENMAN:SystemMessage("ANN. UTILS: No announcer enabled.");
		return;
	end;
end;