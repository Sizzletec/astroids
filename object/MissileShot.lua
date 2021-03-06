local image = love.graphics.newImage('images/missileShot.png')

MissileShot = Object.new()
MissileShot.__index = MissileShot

local tilesetBatch = love.graphics.newSpriteBatch(image)

function MissileShot.new(player,x,y,speed,rotation,damage,bulletLife)
  local s = {}
  setmetatable(s, MissileShot)
  s.player = player
  s.x = x
  s.y = y
  s.bulletLife = bulletLife or 1
  s.rotation = rotation or 0
  s.vx = speed * math.sin(s.rotation)
  s.vy = speed * -math.cos(s.rotation)
  s.lifetime = 0
  s.damage = damage
  s.rotationSpeed = 2
  s.throttle = 0
  s.topSpeed = 200
  s.acceleration = 300
  s.throttle = 0
  s.angularInput = 0
  return s
end

function MissileShot:update(dt)
  self.lifetime = self.lifetime + dt
  Mover.ApplyAcceleration(self, dt)
  Mover.ApplyVelocity(self, dt)

  players = Game.getPlayers()
  local playerDist = 1920

  for p, otherPlayer in pairs(players) do
    if otherPlayer ~= self.player and otherPlayer.components.life.alive then
      local otherMove = otherPlayer.components.move

      xPow = math.pow(self.x - otherMove.x, 2)
      yPow = math.pow(self.y - otherMove.y, 2)

      dist = math.sqrt(xPow + yPow)

      if moveToPoint then
        if playerDist > dist then
          moveToPoint = {x = otherMove.x, y = otherMove.y}
          playerDist = dist
        end
      else
        moveToPoint = {x = otherMove.x, y = otherMove.y}
        playerDist = dist
      end

            -- if dist < 20 then
            --   player.health = player.health - self.damage

            --   if player.health < 0 then
            --     player.health = 0
            --   end
            --   table.remove(self.player.bullets, b)
            -- end
    end
  end

  if moveToPoint then
    Mover.MoveTowards(self,moveToPoint.x-self.x,moveToPoint.y-self.y,dt)
  end

  Mover.ApplyRotation(self,dt)

  self.vx = self.topSpeed * math.sin(self.rotation)
  self.vy = self.topSpeed * -math.cos(self.rotation)


  Mover.StageWrap(self)
  tilesetBatch:add(self.x, self.y, self.rotation, 1,1 , 3,3)
end


function MissileShot.draw()
  tilesetBatch:flush()
  love.graphics.draw(tilesetBatch)
  tilesetBatch:clear()
end

return MissileShot