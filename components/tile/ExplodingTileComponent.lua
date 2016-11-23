ExplodingTileComponent = {}

ExplodingTileComponent.__index = ExplodingTileComponent

function ExplodingTileComponent.new(entity)
  local i = {}
  setmetatable(i, ExplodingTileComponent)
  i.entity = entity
  i.wall = false
  return i
end

function ExplodingTileComponent:update(dt)
  players = Game.getPlayers()
  for _, player in pairs(players) do
    for i, bullet in pairs(player.bullets) do
      local ts = self.entity.tileset
      if ts then
        cx = self.entity.x + ts.tileSize/2
        cy = self.entity.y + ts.tileSize/2

        local move = bullet.components.move

        local powX = math.pow(cx - move.x, 2)
        local powY = math.pow(cy - move.y, 2)
        local dist = math.sqrt(powX + powY)

        if dist < 16 and self.id ~= 0 then
          self.wall = true
          bullet:OnWallHit(self.entity,dt)
          local sw = AoE.new(bullet.entity,cx,cy,10,40,1,10000)
          table.insert(bullet.entity.AoE, sw)

          if bullet.lifetime > bullet.bulletLife then
            bullet:Remove()
            table.remove(player.bullets, i)
          end
        end
      end
    end

    for i, aoe in pairs(player.AoE) do
      local ts = self.entity.tileset
      if ts then
        cx = self.entity.x + ts.tileSize/2
        cy = self.entity.y + ts.tileSize/2

        local powX = math.pow(cx - aoe.x, 2)
        local powY = math.pow(cy - aoe.y, 2)
        local dist = math.sqrt(powX + powY)

        if dist < (16 + aoe.radius) and self.id ~= 0 and not self.wall  then
          self.wall = true
          -- aoe:OnWallHit(self.entity,dt)
          local sw = AoE.new(aoe.entity,cx,cy,10,40,1,10000)
          table.insert(aoe.entity.AoE, sw)
        end
      end
    end


  end
end




function ExplodingTileComponent:draw()
  if self.wall then
    ts = self.entity.tileset.tileSize
    love.graphics.rectangle("fill", self.entity.x-2, self.entity.y-2, ts+4, ts+4)
    self.wall = false
    self.entity.id = 0
    self.entity.components = {}
  end
end

return ExplodingTileComponent