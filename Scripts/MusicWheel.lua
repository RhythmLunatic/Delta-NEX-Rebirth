function WheelFunction (self,offsetFromCenter,itemIndex,numItems) 
	if offsetFromCenter<=0 then
			self:y(offsetFromCenter*(clamp(35-(math.abs(offsetFromCenter*2.8)), 5, 30))+137.5);
		else
			self:y(offsetFromCenter*(clamp(42-(math.abs(offsetFromCenter*3)), 24, 40))+137.5);
	end
end
