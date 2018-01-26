--Ripped right out of Simply Love
function getRandomBackground(p)
    -- Allow users to artbitrarily add new judgment graphics to /Graphics/_judgments/
    -- without needing to modify this script;
    -- instead of hardcoding a list of judgment fonts, get directory listing via FILEMAN.
    local path = THEME:GetPathG("",p)
    local files = FILEMAN:GetDirListing(path.."/")
    local backgrounds = {}
    local backgroundsLength=0 --Fucking lua

    for k,filename in ipairs(files) do

        local name = filename:sub(1, -5)
        backgrounds[#backgrounds+1] = name
        backgroundsLength = backgroundsLength + 1;
        -- A user might put something that isn't a suitable judgment graphic
        -- into /Graphics/_judgments/ (also sometimes hidden files like .DS_Store show up here).
        -- Do our best to filter out such files now.
        --[[if string.match(filename, " %dx%d") then
            -- use regexp to get only the name of the graphic, stripping out the extension
            local name = filename:gsub(" %dx%d", ""):gsub(".png", "")
            backgrounds[#backgrounds+1] = name
            backgroundsLength = backgroundsLength+1;
        end]]
    end
    
   
	if backgroundsLength > 0 then
		local bg = backgrounds[math.random(backgroundsLength)]
		return THEME:GetPathG("",p.."/"..bg);
	end;
	
	assert("No backgrounds found!");
	return nil

end;

function randomBackgrounds(path, delay)
	if not delay then delay = 10 end;
	return Def.ActorFrame{
		
		InitCommand=function(self)
			local bg = getRandomBackground(path);
			if not bg then
				local bgActor = self:GetChild('Background');
				bgActor:diffuse(Color("Black"));
				self:GetChild('Text'):diffusealpha(1);
			else
				--SCREENMAN:SystemMessage(bg);
			end;
		end;
		
		Def.Quad{
			Name = 'Background';
			InitCommand=cmd(diffusealpha,0);
			OnCommand=cmd(Load,getRandomBackground(path);Center;scaletocover,SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM;sleep,.1;linear,1;diffusealpha,1;sleep,delay;linear,1;diffusealpha,0;queuecommand,"On");
		};

		LoadFont("Common Normal")..{
			Name = 'Text';
			Text="No backgrounds found in 'Graphics/"..path.."/'";
			InitCommand=cmd(Center;diffuse,Color("White");diffusealpha,0);
		};
	};
end;

--It's like the above except there's no background looping
function randomBackground(path)
	return Def.ActorFrame{
		
		InitCommand=function(self)
			local bg = getRandomBackground(path);
			local bgActor = self:GetChild('Background');
			if not bg then
				bgActor:diffuse(Color("Black"));
				self:GetChild('Text'):diffusealpha(1);
			else
				bgActor:Load(bg);
				bgActor:scaletocover(SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM);
			end;
		end;
		
		Def.Quad{
			Name = 'Background';
			InitCommand=cmd(Center);
		};

		LoadFont("Common Normal")..{
			Name = 'Text';
			Text="No backgrounds found in 'Graphics/"..path.."/'";
			InitCommand=cmd(Center;diffuse,Color("White");diffusealpha,0);
		};
	};
end;