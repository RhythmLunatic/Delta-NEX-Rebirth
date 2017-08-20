function TextBannerAfterSet(self,param) 
	local Title=self:GetChild("Title"); 
	local Subtitle=self:GetChild("Subtitle"); 
	local Artist=self:GetChild("Artist"); 
	
	
	if Subtitle:GetText() == "" then 
		(cmd(maxwidth,600;zoom,0.425;shadowlength,1;settext,Title:GetText()))(Title);
		else
		(cmd(maxwidth,600;zoom,0.425;shadowlength,1;settext,Title:GetText().." "..Subtitle:GetText()))(Title);
	end
	(cmd(visible,false))(Subtitle);
	(cmd(visible,false))(Artist);

	--self:stoptweening();
end