function playdate.graphics.sprite:handleScreenWrapping()
    if self.x < -10 then
        self:moveTo(410, self.y)
    elseif self.x > 410 then
        self:moveTo(-10, self.y)
    end

    if self.y < -10 then
        self:moveTo(self.x, 250)
    elseif self.y > 250 then
        self:moveTo(self.x, -10)
    end
end

function playdate.graphics.sprite:hasGroup(group)
    return self:getGroupMask() & 2 ^ (group - 1) ~= 0
end
