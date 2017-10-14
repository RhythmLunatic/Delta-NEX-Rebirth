return Def.ActorFrame {
		InitCommand=cmd();
		
		LoadFont("venacti/_venacti 26px bold diffuse")..{
		OnCommand=cmd(zoom,0.425;shadowlength,1;maxwidth,600);
		SetMessageCommand=function(self,params)
			if params.Song then
			--self:LoadFromSongBackground(params.Song);
			--self:settext(""..params.Song:GetDisplayMainTitle());
			end;
		end;
		
		
		}
		
		
}


