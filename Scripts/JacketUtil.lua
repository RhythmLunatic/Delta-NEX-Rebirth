function GetSongGroupJacketPath(groupName)
    if not SONGMAN:DoesSongGroupExist(groupName) then return nil
    else
        local temp = split("/",SONGMAN:GetSongGroupBannerPath(groupName));
        local jacket = "";
        for i=1,#temp-1 do
                jacket = jacket..temp[i].."/"
        end;
        if #temp > 1 then
            jacket = jacket.."jacket.png"
            return jacket
        else
            return nil
        end
    end
end