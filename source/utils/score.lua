local score = 0

Score = {}

-- Read Score

function Score.read()
    return score
end

-- Update Score

function Score.update(increment)
    score += increment
end

-- Reset Score

function Score.reset()
    score = 0
end
