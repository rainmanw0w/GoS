if GetObjectName(myHero) ~= "Vayne" then return end

require('MapPositionGOS')

local VayneMenu = Menu("Vayne", "Vayne")
VayneMenu:SubMenu("Combo", "General")
VayneMenu.Combo:SubMenu("Q", "Tumble (Q)")
VayneMenu.Combo.Q:List("Mode", "Mode", 1, {"Kite", "Normal"})
VayneMenu.Combo.Q:Boolean("Enabled", "Enabled", true)
VayneMenu.Combo.Q:Boolean("KeepInvis", "Don't AA While Stealthed", true)
VayneMenu.Combo.Q:Slider("KeepInvisdis", "Only if Distance <", 230, 0, 550, 1)

VayneMenu.Combo:SubMenu("E", "Condemn (E)")
VayneMenu.Combo.E:Boolean("Enabled", "Enabled", true)
VayneMenu.Combo.E:Slider("pushdistance", "E Push Distance", 400, 350, 490, 1)
VayneMenu.Combo.E:Boolean("stuntarget", "Stun Current Target Only", false)
VayneMenu.Combo.E:Boolean("AntiRengar", "Anti-Rengar", true)
VayneMenu.Combo.E:Boolean("lowhp", "Peel with E when low health", false)
VayneMenu.Combo.E:Boolean("AutoE", "Auto Wall Condemn", true)
VayneMenu.Combo.E:Boolean("Interrupt", "Interrupt Spells (E)", true)

VayneMenu.Combo:SubMenu("R", "Final Hour (R)")
VayneMenu.Combo.R:Boolean("Enabled", "Enabled", true)
VayneMenu.Combo.R:Slider("Rifthp", "if Target Health % <", 70, 1, 100, 1)
VayneMenu.Combo.R:Slider("Rifhp", "if Health % <", 55, 1, 100, 1)
VayneMenu.Combo.R:Slider("Rminally", "Minimum Allies in Range", 2, 0, 4, 1)
VayneMenu.Combo.R:Slider("Rallyrange", "Range", 1000, 1, 2000, 10)
VayneMenu.Combo.R:Slider("Rminenemy", "Minimum Enemies in Range", 2, 1, 5, 1)
VayneMenu.Combo.R:Slider("Renemyrange", "Range", 1000, 1, 2000, 10)

VayneMenu.Combo:Key("WallTumble1", "WallTumble Mid", string.byte("T"))
VayneMenu.Combo:Key("WallTumble2", "WallTumble Drake", string.byte("U"))
VayneMenu.Combo:Boolean("Items", "Use Items", true)
VayneMenu.Combo:Slider("myHP", "if HP % <", 50, 0, 100, 1)
VayneMenu.Combo:Slider("targetHP", "if Target HP % >", 20, 0, 100, 1)
VayneMenu.Combo:Boolean("QSS", "Use QSS", true)
VayneMenu.Combo:Slider("QSSHP", "if My Health % <", 75, 0, 100, 1)


VayneMenu:SubMenu("Misc", "Misc")
VayneMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true)
VayneMenu.Misc:Boolean("Autolvl", "Auto level", true)
VayneMenu.Misc:List("Autolvltable", "Priority", 1, {"W-Q-E", "Q-W-E"})


VayneMenu:SubMenu("Drawings", "Drawings")
VayneMenu.Drawings:Boolean("Q", "Draw Q Range", true)
VayneMenu.Drawings:Boolean("E", "Draw E Range", true)
VayneMenu.Drawings:Boolean("WT", "Draw WallTumble Pos", true)

CHANELLING_SPELLS = {
    ["Caitlyn"]                     = {_R},
    ["Katarina"]                    = {_R},
    ["MasterYi"]                    = {_W},
    ["FiddleSticks"]                = {_W, _R},
    ["Galio"]                       = {_R},
    ["Lucian"]                      = {_R},
    ["MissFortune"]                 = {_R},
    ["VelKoz"]                      = {_R},
    ["Nunu"]                        = {_R},
    ["Shen"]                        = {_R},
    ["Malzahar"]                    = {_R},
    ["Pantheon"]                    = {_R},
    ["Warwick"]                     = {_R},
    ["Xerath"]                      = {_R},
}

local callback = nil
 
OnProcessSpell(function(unit, spell)    
    if not callback or not unit or GetObjectType(unit) ~= Obj_AI_Hero  or GetTeam(unit) == GetTeam(GetMyHero()) then return end
    local unitChanellingSpells = CHANELLING_SPELLS[GetObjectName(unit)]
 
        if unitChanellingSpells then
            for _, spellSlot in pairs(unitChanellingSpells) do
                if spell.name == GetCastName(unit, spellSlot) then callback(unit, CHANELLING_SPELLS) end
            end
        end
end)
 
function addInterrupterCallback( callback0 )
        callback = callback0
end

OnLoop(function(myHero)
    if IOW:Mode() == "Combo" then
	
	local target = GetCurrentTarget()
	
	if VayneMenu.Combo.Q.Mode:Value() == 2 and GoS:ValidTarget(target, 900) and VayneMenu.Combo.Q.Enabled:Value() then
	        local HeroPos = GetOrigin(myHero)
		local mousePos = GetMousePos()
                local AfterTumblePos = HeroPos + (Vector(mousePos) - HeroPos):normalized() * 300
                local DistanceAfterTumble = GoS:GetDistance(AfterTumblePos, target)
  
                if GoS:GetDistance(myHero, target) > 630 and DistanceAfterTumble < 630 then
                CastSkillShot(_Q, mousePos.x, mousePos.y, mousePos.z)
                end
        end

	if GetItemSlot(myHero,3140) > 0 and VayneMenu.Combo.QSS:Value() and GotBuff(myHero, "rocketgrab2") > 0 or GotBuff(myHero, "charm") > 0 or GotBuff(myHero, "fear") > 0 or GotBuff(myHero, "flee") > 0 or GotBuff(myHero, "snare") > 0 or GotBuff(myHero, "taunt") > 0 or GotBuff(myHero, "suppression") > 0 or GotBuff(myHero, "stun") > 0 or GotBuff(myHero, "zedultexecute") > 0 or GotBuff(myHero, "summonerexhaust") > 0 and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < VayneMenu.Combo.QSSHP:Value() then
        CastTargetSpell(myHero, GetItemSlot(myHero,3140))
        end

        if GetItemSlot(myHero,3139) > 0 and VayneMenu.Combo.QSS:Value() and GotBuff(myHero, "rocketgrab2") > 0 or GotBuff(myHero, "charm") > 0 or GotBuff(myHero, "fear") > 0 or GotBuff(myHero, "flee") > 0 or GotBuff(myHero, "snare") > 0 or GotBuff(myHero, "taunt") > 0 or GotBuff(myHero, "suppression") > 0 or GotBuff(myHero, "stun") > 0 or GotBuff(myHero, "zedultexecute") > 0 or GotBuff(myHero, "summonerexhaust") > 0 and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < VayneMenu.Combo.QSSHP:Value() then
        CastTargetSpell(myHero, GetItemSlot(myHero,3139))
        end
		
	if VayneMenu.Combo.E.stuntarget:Value() and VayneMenu.Combo.E.Enabled:Value() then
	  if GoS:ValidTarget(target, 550) then
            local TargetPos = Vector(GetOrigin(target))
            local HeroPos = Vector(GetOrigin(myHero))
            local maxERange = TargetPos - (TargetPos - HeroPos) * ( - VayneMenu.Combo.E.pushdistance:Value() / GoS:GetDistance(target))
            local shootLine = Line(Point(TargetPos.x, TargetPos.y, TargetPos.z), Point(maxERange.x, maxERange.y, maxERange.z))
            for i, Pos in pairs(shootLine:__getPoints()) do
              if MapPosition:inWall(Pos) then
              CastTargetSpell(target, _E) 
              end
            end
          end
        end

        if CanUseSpell(myHero, _R) == READY and IOW:Mode() == "Combo" and GoS:ValidTarget(target, VayneMenu.Combo.R.Renemyrange:Value()) and 100*GetCurrentHP(target)/GetMaxHP(target) <= VayneMenu.Combo.R.Rifthp:Value() and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) <= VayneMenu.Combo.R.Rifhp:Value() and GoS:EnemiesAround(GoS:myHeroPos(), VayneMenu.Combo.R.Renemyrange:Value()) >= VayneMenu.Combo.R.Rminenemy:Value() and GoS:AlliesAround(GoS:myHeroPos(), VayneMenu.Combo.R.Rallyrange:Value()) >= VayneMenu.Combo.R.Rminally:Value() then
        CastSpell(_R)
	end
		
        if GotBuff(myHero, "vaynetumblefade") > 0 and GoS:ValidTarget(target, 550) and GoS:GetDistance(target) > VayneMenu.Combo.Q.KeepInvisdis:Value() then
	IOW:EnableAutoAttacks()
	elseif GotBuff(myHero, "vaynetumblefade") < 1 then
	IOW:EnableAutoAttacks()
	elseif GotBuff(myHero, "vaynetumblefade") > 0 and VayneMenu.Combo.Q.KeepInvis:Value() and GoS:ValidTarget(target, VayneMenu.Combo.Q.KeepInvisdis:Value()) and GoS:GetDistance(myHero, target) < VayneMenu.Combo.Q.KeepInvisdis:Value() then 
	IOW:DisableAutoAttacks()
	end
	
   end

   for i,enemy in pairs(GoS:GetEnemyHeroes()) do
        
        if IOW:Mode() == "Combo" then  
          if GetItemSlot(myHero,3153) > 0 and VayneMenu.Combo.Items:Value() and GoS:ValidTarget(enemy, 550) and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < VayneMenu.Combo.myHP:Value() and 100*GetCurrentHP(enemy)/GetMaxHP(enemy) > VayneMenu.Combo.targetHP:Value() then
          CastTargetSpell(enemy, GetItemSlot(myHero,3153))
          end

          if GetItemSlot(myHero,3144) > 0 and VayneMenu.Combo.Items:Value() and GoS:ValidTarget(enemy, 550) and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < VayneMenu.Combo.myHP:Value() and 100*GetCurrentHP(enemy)/GetMaxHP(enemy) > VayneMenu.Combo.targetHP:Value() then
          CastTargetSpell(enemy, GetItemSlot(myHero,3144))
          end

          if GetItemSlot(myHero,3142) > 0 and VayneMenu.Combo.Items:Value() and GoS:ValidTarget(enemy, 600) then
          CastTargetSpell(myHero, GetItemSlot(myHero,3142))
          end
        end
        
          if Ignite and VayneMenu.Misc.AutoIgnite:Value() then
            if CanUseSpell(myHero, Ignite) == READY and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and GoS:ValidTarget(enemy, 900) then
            CastTargetSpell(enemy, Ignite)
            end
	  end
        
	if VayneMenu.Combo.E.AutoE:Value() then
	  if GoS:ValidTarget(enemy, 550) then
            local TargetPos = Vector(GetOrigin(enemy))
            local HeroPos = Vector(GetOrigin(myHero))
            local maxERange = TargetPos - (TargetPos - HeroPos) * ( - VayneMenu.Combo.E.pushdistance:Value() / GoS:GetDistance(enemy))
            local shootLine = Line(Point(TargetPos.x, TargetPos.y, TargetPos.z), Point(maxERange.x, maxERange.y, maxERange.z))
            for i, Pos in pairs(shootLine:__getPoints()) do
              if MapPosition:inWall(Pos) then
              CastTargetSpell(enemy, _E) 
              end
            end
	  end
        end

        if VayneMenu.Combo.E.lowhp:Value() and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) <= 15 and GoS:EnemiesAround(GoS:myHeroPos(), 375) >= 1 then
        CastTargetSpell(enemy, _E)
        end

        if VayneMenu.Combo.E.Enabled:Value() and IOW:Mode() == "Combo" and VayneMenu.Combo.E.stuntarget:Value() == false then
          if GoS:ValidTarget(enemy, 550) then
            local TargetPos = Vector(GetOrigin(enemy))
            local HeroPos = Vector(GetOrigin(myHero))
            local maxERange = TargetPos - (TargetPos - HeroPos) * ( - VayneMenu.Combo.E.pushdistance:Value() / GoS:GetDistance(enemy))
            local shootLine = Line(Point(TargetPos.x, TargetPos.y, TargetPos.z), Point(maxERange.x, maxERange.y, maxERange.z))
            for i, Pos in pairs(shootLine:__getPoints()) do
              if MapPosition:inWall(Pos) then
              CastTargetSpell(enemy, _E) 
              end
            end
          end
        end
   end

        if VayneMenu.Combo.WallTumble1:Value() and GoS:myHeroPos().x == 6962 and GoS:myHeroPos().z == 8952 then
        CastSkillShot(_Q,6667.3271484375, 51, 8794.64453125)
        elseif VayneMenu.Combo.WallTumble1:Value() then
        MoveToXYZ(6962, 51, 8952)
        end
    
        if VayneMenu.Combo.WallTumble2:Value() and GoS:myHeroPos().x == 12060 and GoS:myHeroPos().z == 4806 then
        CastSkillShot(_Q,11745.198242188, 51, 4625.4379882813)
        elseif VayneMenu.Combo.WallTumble2:Value() then
        MoveToXYZ(12060, 51, 4806)
        end

if VayneMenu.Misc.Autolvl:Value() then  
   if VayneMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
   elseif VayneMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
   end
LevelSpell(leveltable[GetLevel(myHero)])
end
		
if VayneMenu.Drawings.Q:Value() then DrawCircle(GoS:myHeroPos().x,GoS:myHeroPos().y,GoS:myHeroPos().z,GetCastRange(myHero,_Q),1,128,0xff00ff00) end
if VayneMenu.Drawings.E:Value() then DrawCircle(GoS:myHeroPos().x,GoS:myHeroPos().y,GoS:myHeroPos().z,GetCastRange(myHero,_E),1,128,0xff00ff00) end
if VayneMenu.Drawings.WT:Value() then
DrawCircle(6962, 51, 8952,80,1,128,0xffffffff)
DrawCircle(12060, 51, 4806,80,1,128,0xffffffff)
end
end)

OnProcessSpell(function(unit, spell)
    if unit and spell and spell.name then
      if unit == myHero then
        if spell.name:lower():find("attack") then 
	        GoS:DelayAction(function() 
	        	for i,enemy in pairs(GoS:GetEnemyHeroes()) do
                           if enemy ~= nil and IOW:Mode() == "Combo" and VayneMenu.Combo.Q.Mode:Value() == 1 and VayneMenu.Combo.Q.Enabled:Value() then
				local HeroPos = GetOrigin(myHero)
				local mousePos = GetMousePos()
                                local AfterTumblePos = HeroPos + (Vector(mousePos) - HeroPos):normalized() * 300
                                local DistanceAfterTumble = GoS:GetDistance(AfterTumblePos, enemy)
							  
                                if DistanceAfterTumble < 800 and DistanceAfterTumble > 200 then
                                CastSkillShot(_Q, mousePos.x, mousePos.y, mousePos.z)
                                end
  
                                if GoS:GetDistance(myHero, enemy) > 630 and DistanceAfterTumble < 630 then
                                CastSkillShot(_Q, mousePos.x, mousePos.y, mousePos.z)
                                end
                           end
                           
                           if enemy ~= nil and IOW:Mode() == "Combo" and VayneMenu.Combo.Q.Mode:Value() == 2 and VayneMenu.Combo.Q.Enabled:Value() then
	                        local HeroPos = GetOrigin(myHero)
		                local mousePos = GetMousePos()
                                local AfterTumblePos = HeroPos + (Vector(mousePos) - HeroPos):normalized() * 300
                                local DistanceAfterTumble = GoS:GetDistance(AfterTumblePos, enemy)
  
                                if DistanceAfterTumble < 800 and DistanceAfterTumble > 200 then
                                CastSkillShot(_Q, mousePos.x, mousePos.y, mousePos.z)
                                end
                           end
                        end
                end, GetWindUp(myHero)*1000)
	end		
      end
  end
end)

OnCreateObj(function(Object) 
  for i,enemy in pairs(GoS:GetEnemyHeroes()) do	
    if GetObjectName(enemy) == "Rengar" and GetObjectBaseName(Object) == "Rengar_LeapSound.troy" and GoS:GetDistance(myHero, enemy) <= 550 and VayneMenu.Combo.E.AntiRengar:Value() then
    CastTargetSpell(enemy, _E)
    end
  end
end)

addInterrupterCallback(function(target, spellType)
  if GoS:IsInDistance(target, 550) and CanUseSpell(myHero,_E) == READY and spellType == CHANELLING_SPELLS and VayneMenu.Combo.E.Interrupt:Value() then
  CastTargetSpell(target, _E)
  end
end)

GoS:AddGapcloseEvent(_E, 550, true) -- hi Copy-Pasters ^^
