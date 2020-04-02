sub ShowVideo()
    if m.video.state = "playing"
        m.loadingLabel.visible = false
        m.video.visible = true
    end if
end sub


sub PlayVideo()
    m.bgPoster.visible = true
    m.video.control = "play"
    m.video.ObserveField("state", "ShowVideo")
end sub