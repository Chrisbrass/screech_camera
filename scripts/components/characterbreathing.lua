local CharacterBreathing = Class(function(self, inst)
    self.inst = inst

    self.inst:ListenForEvent( "change_breathing", function(it, data)
        self:StartBreathing(data.intensity, data.duration)
    end, self.inst)
    
    self.inst:ListenForEvent( "stop_breathing", function(it, data)
        self:StopBreathing()
    end, self.inst)

    self.inst:ListenForEvent( "change_default_breathing", function(it, data)
        self.default_intensity = data.intensity
        if self.default_intensity > self.intensity then
            self:StartBreathing( self.default_intensity, -1 )
        end
    end, self.inst)

    self.inst:StartUpdatingComponent(self)

    self.default_intensity = 1
    self.intensity = -1
    self.duration = -1
end)

function CharacterBreathing:StartBreathing( intensity, duration )
    --stop the current breathing

    if intensity < self.default_intensity then
        --only go upward
        return
    end

    if self.intensity ~= intensity then
        self.inst.SoundEmitter:KillSound("breathing")
        if intensity == 1 then
            self.inst.SoundEmitter:PlaySound("scary_mod/stuff/breathing", "breathing")
        elseif intensity == 2 then
            self.inst.SoundEmitter:PlaySound("scary_mod/stuff/breathing_med", "breathing")
        else
            self.inst.SoundEmitter:PlaySound("scary_mod/stuff/breathing_fast", "breathing")
        end
    end

    self.intensity = intensity
    self.duration = duration
    self.inst:StartUpdatingComponent(self)
end

function CharacterBreathing:StopBreathing()
    self.inst.SoundEmitter:KillSound("breathing")
    self.inst:StopUpdatingComponent(self)
end

function CharacterBreathing:OnUpdate(dt)
    if self.duration > 0 then
        self.duration = self.duration - dt

        if self.duration <= 0 then 
            --revert back to original breathing
            self:StartBreathing(self.default_intensity, -1)
        end
    end
end

return CharacterBreathing