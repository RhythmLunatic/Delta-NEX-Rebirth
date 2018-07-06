function GetOrCreateChild(tab, field, kind)
    kind = kind or 'table'
    local out
    if not tab[field] then
        if kind == 'table' then
            out = {}
        elseif kind == 'number' then
            out = 0
        elseif kind == 'boolean_df' or kind == 'boolean' then
            out = false
        elseif kind == 'boolean_dt' then
            out = true
        else
            error("GetOrCreateChild: I don't know a default value for type "..kind)
        end
        tab[field] = out
    else out = tab[field] end
    return out
end

--Thank you, DDR SN3 team!
--This function is a port of https://github.com/Inorizushi/DDR-X3/blob/master/Scripts/Starter.lua, please credit them if you want to put it in your theme
local outputPath = "/Themes/"..THEME:GetCurThemeName().."/Other/SongManager BasicMode.txt";
local isolatePattern = "/([^/]+)/?$" --in English, "everything after the last forward slash unless there is a terminator"
local combineFormat = "%s/%s"
function AssembleBasicMode()
	if not (SONGMAN and GAMESTATE) then return end
	local set = {}
	--populate the groups
	for _, song in pairs(SONGMAN:GetAllSongs()) do
		local steps = song:GetStepsByStepsType('StepsType_Pump_Single');
		local doublesSteps = song:GetStepsByStepsType('StepsType_Pump_Double');
		--Trace(song:GetDisplayMainTitle());
		if #steps >= 3 and #doublesSteps >= 1 then --Somehow doublesSteps can be non nil despite having no doubles steps.
			if steps[1]:GetMeter() < 9 and steps[2]:GetMeter() < 9 and steps[3]:GetMeter() < 9 and doublesSteps[1]:GetMeter() < 9 then
				
				local shortSongDir = string.match(song:GetSongDir(),isolatePattern)
				--Trace("sDir: "..shortSongDir)
				local groupName = song:GetGroupName()
				local groupTbl = GetOrCreateChild(set, groupName)
				table.insert(groupTbl,
					string.format(combineFormat, groupName, shortSongDir))
			end
		end
	end
	--sort all the groups and collect their names, then sort that too
	local groupNames = {}
	for groupName, group in pairs(set) do
		if next(group) == nil then
			set[groupName] = nil
		else
			table.sort(group)
			table.insert(groupNames, groupName)
		end
	end
	table.sort(groupNames)
	--then, let's make a representation of our eventual file in memory.
	local outputLines = {}
	for _, groupName in ipairs(groupNames) do
		--table.insert(outputLines, "---"..groupName)
		for _, path in ipairs(set[groupName]) do
			table.insert(outputLines, path)
		end
	end
	--now, slam it all out to disk.
	local fHandle = RageFileUtil.CreateRageFile()
	--the mode is Write+FlushToDiskOnClose
	fHandle:Open(outputPath, 10)
	fHandle:Write(table.concat(outputLines,'\n'))
	fHandle:Close()
	fHandle:destroy()
end
--Lol
AssembleBasicMode();
	
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

--gsub ignore case
function gisub(s, pat, repl, n)
    pat = string.gsub(pat, '(%a)', 
               function (v) return '['..string.upper(v)..string.lower(v)..']' end)
    if n then
        return string.gsub(s, pat, repl, n)
    else
        return string.gsub(s, pat, repl)
    end
end

--[[function WheelFunction (self,offsetFromCenter,itemIndex,numItems) 
	if offsetFromCenter<=0 then
			self:y(offsetFromCenter*(clamp(35-(math.abs(offsetFromCenter*2.8)), 5, 30))+137.5);
		else
			self:y(offsetFromCenter*(clamp(42-(math.abs(offsetFromCenter*3)), 24, 40))+137.5);
	end
end]]


--Init needs to reset on screen in.
--local init = 0;
--local inGroupSelect = true;

--Stolen from some PIU Prime theme
function PrimeWheel(self,offsetFromCenter,itemIndex,numItems)
	--[[if offsetFromCenter == 0 and init < 250 then
		init = init+5
	end]]
	local nx = math.abs(offsetFromCenter)*250;
	if math.abs(offsetFromCenter) > 1 then
		nx = ( ( math.abs( offsetFromCenter ) -1 ) *(69-(math.abs(offsetFromCenter)*-8)) )+250
	end
	local morlss = offsetFromCenter ~= 0 and (offsetFromCenter/math.abs(offsetFromCenter)) or 1
	local yfun = math.min(math.abs(offsetFromCenter),1)
	--Y value is set in ScreenSelectMusic overlay.
	--local y = 0
	if yfun >= 2 then
		ypos = (yfun-2)*3
	end
	function zoomw(offsetFromCenter)
		local ofsfc = math.abs(offsetFromCenter)
		if ofsfc >=1 then ofsfc=1 end
		return 1-ofsfc*.2
	end;
	function zooma(offsetFromCenter)
		local ofsfc = math.abs(offsetFromCenter)
		if ofsfc >=1 then ofsfc=1 end
		return 1-ofsfc*.2
	end;
 	self:x(nx*morlss)
	self:zoomx(zooma(offsetFromCenter))
	self:zoomy(zoomw(offsetFromCenter))
	self:z(		20-(	math.min(math.abs(offsetFromCenter),8)*8	)	)
	self:rotationx( 0 );
	self:rotationy( morlss*(math.min(math.abs(offsetFromCenter)*98,50)) );
	self:rotationz( 0 );
end;

--[[function X3Wheel(self,offsetFromCenter,itemIndex,numItems) \
	local function GetZoom(offsetFromCenter) \
		if math.abs(offsetFromCenter) >= 1 then \
			return 0.8; \
		else \
			return (10.0-math.abs(offsetFromCenter)*2)/10; \
		end; \
	end; \
	local function GetDistence(offsetFromCenter) \
		if offsetFromCenter >= 1 then \
			return offsetFromCenter*90+84; \
		elseif offsetFromCenter <= -1 then \
			return offsetFromCenter*90-84; \
		else \
			return 90*offsetFromCenter + 84*offsetFromCenter \
		end; \
	end; \
	local function GetRotationY(offsetFromCenter) \
		if offsetFromCenter > 0.9 then \
			return 64+(offsetFromCenter-0.9)*9.8; \
		elseif offsetFromCenter < -0.9 then \
			return -64+(offsetFromCenter+0.9)*9.8; \
		else \
			return offsetFromCenter*64/0.9; \
		end; \
	end; \
	local function GetRotationZ(offsetFromCenter) \
		if offsetFromCenter < 0 then \
			return -offsetFromCenter*0.5; \
		else \
			return 0; \
		end; \
	end; \
	local function GetRotationX(offsetFromCenter) \
		if math.abs(offsetFromCenter) < 0.1 then \
			return 0; \
		else \
			return 4; \
		end; \
	end; \
	self:linear(5.8); \
	self:x( GetDistence(offsetFromCenter) ); \
	self:y(2); \
	self:z(1-math.abs(offsetFromCenter)); \
	self:draworder( math.abs(offsetFromCenter)*10 ); \
	self:zoom( GetZoom(offsetFromCenter) ); \
	self:rotationx( 0 );\
	self:rotationy( GetRotationY(offsetFromCenter) ); \
	self:rotationz( 0 ); \
end;]]
