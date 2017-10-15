--[[function WheelFunction (self,offsetFromCenter,itemIndex,numItems) 
	if offsetFromCenter<=0 then
			self:y(offsetFromCenter*(clamp(35-(math.abs(offsetFromCenter*2.8)), 5, 30))+137.5);
		else
			self:y(offsetFromCenter*(clamp(42-(math.abs(offsetFromCenter*3)), 24, 40))+137.5);
	end
end]]


--Init needs to reset on screen in.
local init = 0;
local inGroupSelect = true;

--Stolen from some PIU Prime theme
function PrimeWheel(self,offsetFromCenter,itemIndex,numItems)
	if offsetFromCenter == 0 and init < 250 then
		init = init+5
	end
	local nx = math.abs(offsetFromCenter)*250;
	if math.abs(offsetFromCenter) > 1 then
		nx = ( ( math.abs( offsetFromCenter ) -1 ) *(69-(math.abs(offsetFromCenter)*-8)) )+250
	end
	local morlss = offsetFromCenter ~= 0 and (offsetFromCenter/math.abs(offsetFromCenter)) or 1
	local yfun = math.min(math.abs(offsetFromCenter),1)
	local y = 100
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
	--This doesn't work.
	--[[if inGroupSelect == true then
		self:y(SCREEN_CENTER_Y);
	else
		self:y(SCREEN_CENTER_Y+125);
	end;]]
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