function GetSongGroupJacketPath(groupName)
    if not SONGMAN:DoesSongGroupExist(groupName) then return nil
    else
		--By Kyzentun
        local path= SONGMAN:GetSongGroupBannerPath(groupName)
		if path == "" then return nil end
		local last_slash= path:reverse():find("/")
		path = path:sub(1, -last_slash) .. "jacket.png";
		if FILEMAN:DoesFileExist(path) then
			return path
		else
			return nil;
		end 
    end
end