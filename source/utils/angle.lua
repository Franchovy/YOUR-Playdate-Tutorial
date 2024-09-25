
function getRotationComponents(rotationRadians, velocity)
    return velocity * math.cos(rotationRadians), velocity * math.sin(rotationRadians)
end
