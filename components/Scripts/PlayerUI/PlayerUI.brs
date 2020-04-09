sub init()
  m.playerStateInfoGroup = m.top.findNode("playerStateInfoGroup")
  m.playerStateInfoBackground = m.top.findNode("playerStateInfoBackground")
  m.playerStateLabel = m.top.findNode("playerStateLabel")
  m.uiGroup = m.top.findNode("uiGroup")
  m.progressBar = m.top.findNode("progressBar")
  m.progressBarBackground = m.top.findNode("progressBarBackground")
  m.playerBackground = m.top.findNode("playerBackground")
  m.buttonPlay = m.top.findNode("buttonPlay")
  m.timer = m.top.findNode("timerToHideUIVideo")
  m.timer.ObserveField("fire", "hideUIGroup")
end sub


sub initialize()
  deviceInfo = CreateObject("roDeviceInfo")
  uiRes = deviceInfo.GetUIResolution()

  m.playerStateInfoBackground.width = uiRes.width
  m.playerStateInfoBackground.height = uiRes.height

  offset = 100
  m.playerBackground.width = uiRes.width
  m.playerBackground.translation = [0, (uiRes.height) - m.playerBackground.height]
  m.progressBarBackground.translation = [50, (m.playerBackground.height / 2) - (m.progressBarBackground.height / 2)]
  m.progressBarBackground.width = m.playerBackground.width - 100
  m.buttonPlay.translation = [(uiRes.width / 2) - (m.buttonPlay.width / 2), (uiRes.height / 2) - (m.buttonPlay.height / 2)]
  m.playerStateLabel.translation = [(uiRes.width / 2) - (m.playerStateLabel.width / 2), (uiRes.height / 2) - (m.playerStateLabel.height / 2) - offset]
end sub


sub showUIGroup()
  m.uiGroup.visible = true
end sub


sub hideUIGroup()
  m.uiGroup.visible = false
end sub


sub changeIconToPlay()
  m.buttonPlay.uri = "pkg:/images/Play.png"
end sub


sub changeIconToPause()
  m.buttonPlay.uri = "pkg:/images/Pause.png"
end sub


sub setProgressBarWidth(videoTimeInfo)
  elapsedVideoPercent = calculateElapsedVideoPercent(videoTimeInfo.videoDuration, videoTimeInfo.currentVideoTime)
  progressBarWidth = percentToNumber(elapsedVideoPercent, m.progressBarBackground.width)

  m.progressBar.width = progressBarWidth
end sub


function calculateElapsedVideoPercent(duration, elapsedTime)
  percent = (elapsedTime / duration) * 100
  return percent
end function


sub controlPlayerStateInfo(state)
  if state = "playing"
    changeIconToPlay()
    m.timer.control = "start"
    m.playerStateInfoGroup.visible = false
    m.playerStateLabel.text = ""
  else
    m.timer.control = "stop"
    showUIGroup()
    changeIconToPause()
    m.playerStateInfoGroup.visible = true
    if state = "paused"
      m.playerStateLabel.text = "Paused"
    else if state = "stalling" or state = "ready"
      m.playerStateLabel.text = "Loading..."
    else
      m.playerStateLabel.text = state
    end if
  end if
end sub