BounceComponent = {
  gunCooldown = 0,
  weaponDamage = 20,
  fireRate = 2,
  firing = false
}

BounceComponent.__index = BounceComponent

function BounceComponent.new(entity)
  local i = {}
  setmetatable(i, BounceComponent)
  i.entity = entity
  return i
end

function BounceComponent:update(dt)
  if self.firing and self.gunCooldown <= 0 then
    self:fire()
    self.gunCooldown = 1/self.fireRate
  elseif self.gunCooldown > 0 then
    self.gunCooldown = self.gunCooldown - dt
  end
end

function BounceComponent:fire()
  if self.entity.components.life.health <= 0 then
    return
  end

  local move = self.entity.components.move
  self.entity.components.score.shots = self.entity.components.score.shots + 1

  local x = move.x + (10 * math.sin(move.rotation)) 
  local y = move.y + (10 * -math.cos(move.rotation))
  bullet = Bullet.new(x,y,700,move.rotation, self.weaponDamage,2)
  bullet.bounce = true
  table.insert(self.entity.bullets, bullet)
end


return BounceComponent