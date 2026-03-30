local Bridge = exports['community_bridge']:Bridge()


function Notify (src, title, message, type)
    Bridge.Notify.SendNotification(src, title, message, type)
end

