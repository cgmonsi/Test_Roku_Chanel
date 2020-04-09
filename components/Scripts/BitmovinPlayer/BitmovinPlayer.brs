sub onLoadStatusChanged()
  print "LOAD STATUS FOR LIBRARY: "; m.bitmovinPlayerSDK.loadStatus
  if (m.bitmovinPlayerSDK.loadStatus = "ready")
    m.bitmovinPlayer = CreateObject("roSGNode", "BitmovinPlayerSDK:BitmovinPlayer")
    m.BitmovinFunctions = m.bitmovinPlayer.BitmovinFunctions
    m.BitmovinFields = m.bitmovinPlayer.BitmovinFields

    m.bitmovinPlayer.ObserveField(m.BitmovinFields.CURRENT_TIME, "onCurrentTimeChanged")
    m.bitmovinPlayer.ObserveField(m.BitmovinFields.PLAYER_STATE, "onPlayerState")

    m.bitmovinVideo.appendChild(m.bitmovinplayer)
    m.bitmovinplayer.visible = false

    m.playerUi = CreateObject("roSGNode", "playerUI")
    m.playerUi.id = "playerUi"
    m.top.appendChild(m.playerUi)
    m.playerUi.callFunc("initialize")
  end if
end sub


sub onCurrentTimeChanged()
  m.durationAndCurrentTime = getDurationAndCurentTime()
  m.playerUi.callFunc("setProgressBarWidth", m.durationAndCurrentTime)
end sub


sub onPlayerState()
  if m.playerUi <> invalid

    if m.bitmovinPlayer.playerState = "playing"
      m.bitmovinplayer.visible = true
      if m.visibleUI = false
        m.fgPoster.visible = false
      end if
    else if m.bitmovinPlayer.playerState = "paused"
      m.fgPoster.visible = true
    else if m.bitmovinPlayer.playerState = "stalling" or m.bitmovinPlayer.playerState = "ready"
      m.fgPoster.visible = true
    else
      m.bitmovinplayer.visible = false
    end if

    if m.visibleUI = false
      m.playerUi.callFunc("controlPlayerStateInfo", m.bitmovinPlayer.playerState)
    end if
    
  end if
end sub


function getDurationAndCurentTime()
  duration = m.bitmovinPlayer.callFunc(m.BitmovinFunctions.GET_DURATION, invalid)
  currentTime = m.bitmovinPlayer.currentTime

  return { videoDuration: duration, currentVideoTime: currentTime }
end function
