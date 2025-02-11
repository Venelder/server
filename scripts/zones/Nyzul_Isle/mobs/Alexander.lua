-----------------------------------
-- Area: Nyzul Isle (Nashmeira's Plea)
--  Mob: Alexander
-----------------------------------
local ID = zones[xi.zone.NYZUL_ISLE]
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.NO_MOVE, 1)

    mob:addListener('WEAPONSKILL_STATE_ENTER', 'WS_START_MSG', function(mobArg, skillID)
        -- Radiant Sacrament
        if skillID == 2141 then
            mobArg:showText(mobArg, ID.text.OFFER_THY_WORSHIP)
        -- Mega Holy
        elseif skillID == 2142 then
            mobArg:showText(mobArg, ID.text.OPEN_THINE_EYES)
        -- Perfect Defense
        elseif skillID == 2143 then
            mobArg:showText(mobArg, ID.text.CEASE_THY_STRUGGLES)
        -- Divine Spear
        elseif skillID == 2144 then
            mobArg:showText(mobArg, ID.text.RELEASE_THY_SELF)
        -- Gospel of the Lost
        elseif skillID == 2145 then
            mobArg:showText(mobArg, ID.text.BASK_IN_MY_GLORY)
        -- Void of Repentance
        elseif skillID == 2146 then
            mobArg:showText(mobArg, ID.text.REPENT_THY_IRREVERENCE)
        -- Divine Judgement
        elseif skillID == 2147 then
            mobArg:showText(mobArg, ID.text.ACCEPT_THY_DESTRUCTION)
            mobArg:showText(mobArg, ID.text.OMEGA_SPAM)
        end
    end)
end

entity.onMobEngage = function(mob, target)
    mob:showText(mob, ID.text.SHALL_BE_JUDGED)
end

entity.onMobFight = function(mob, target)
    -- BG Wiki: 'He will use this ability at 50% of his HP and several times again as his health decreases.'
    -- ffxiclopedia: 'Alexander will use this ability as his next TP move once its HP falls below 50%.'
    if
        mob:getHPP() <= 50 and
        mob:getTP() >= 1000 and
        mob:getLocalVar('DivineJudgement') == 0
    then
        mob:setLocalVar('DivineJudgement', 1)
        mob:useMobAbility(2147)
    end

    -- ffxiclopedia: 'In addition to this, it's possible he'll use it several times again at low (5%?) HP.'
    -- Per same wiki, may use Perfect Defense as a regular skill at 10%..Assuming same % for both skills.
    local skillList = mob:getMobMod(xi.mobMod.SKILL_LIST)
    if mob:getHPP() <= 10 and skillList == 784 then
        mob:setMobMod(xi.mobMod.SKILL_LIST, 785)
    end

    local drawInTable =
    {
        conditions =
        {
            mob:checkDistance(target) > 20,
        },
        position = mob:getPos(),
    }
    utils.drawIn(target, drawInTable)
end

entity.onMobDeath = function(mob, player, optParams)
    if optParams.isKiller then
        mob:showText(mob, ID.text.SHALL_KNOW_OBLIVION)
    end
end

entity.onMobDespawn = function(mob)
    local instance = mob:getInstance()
    if not instance then
        return
    end

    instance:setProgress(instance:getProgress() + 1)
end

return entity
