local viewState = false
local cDir
local cRot
local cLen
local sprintMaxSpeedDft = 0
local sprintMaxSpeedCstm = 0
local switchTick = 0
local switchDelay = 100

addCommandHandler("view", 
    function()
        if viewState then
            viewState = false
            setCameraTarget(localPlayer)
        else
            cDir = vec3.getDirFromTo(vec3.getPos(localPlayer), vec3.getPos(getCamera()))
            cRot = vec3.getRot(getCamera())
            cLen = vec3.getDistance(vec3.getPos(localPlayer), vec3.getPos(getCamera()))
            switchTick = getTickCount()
            viewState = true
        end
    end
)

addEventHandler("onClientRender", root,
    function()
        local velocity = math.floor(vec3.length(vec3.toVec(getElementVelocity(localPlayer))) * 10000)/10000

        if getTickCount() > switchTick + switchDelay then
            if viewState then
                if velocity > sprintMaxSpeedCstm then
                    sprintMaxSpeedCstm = velocity
                end
            else
                if velocity > sprintMaxSpeedDft then
                    sprintMaxSpeedDft = velocity
                end
            end
        end

        dxDrawText(
            "velocity: " .. velocity .. "\n" .. 
            "sprintMaxSpeedDft: " .. sprintMaxSpeedDft .. "\n" ..
            "sprintMaxSpeedCstm: " .. sprintMaxSpeedCstm,
            50, 250, 50, 250, tocolor(255,255,255), 3
        )

        if viewState then
            local pos = vec3.getPos(localPlayer)
            pos = vec3.addVec(pos, vec3.scaleVec(cDir, cLen))
            setElementPosition(getCamera(), pos.x, pos.y, pos.z)
            setElementRotation(getCamera(), cRot.x, cRot.y, cRot.z)
        end
    end
);