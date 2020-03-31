sub init()
    m.padding = 20

    m.bgPoster = m.top.findNode("bgPoster")
    m.fgPoster = m.top.findNode("fgPoster")

    m.video = m.top.findNode("video")
    m.rowlist = m.top.findNode("RowList")
    m.infoRectangle = m.top.findNode("infoRectangle")
    m.titleLabel = m.top.findNode("titleLabel")
    m.infoLabel = m.top.findNode("infoLabel")
    m.logoPoster = m.top.findNode("logoPoster")
    m.hdrPoster = m.top.findNode("hdrPoster")
    m.dateLabel = m.top.findNode("dateLabel")
    m.loadingLabel = m.top.findNode("loadingLabel")
    m.durationLabel = m.top.findNode("durationLabel")
    m.divRectangle = m.top.findNode("divRectangle")
    m.arrowPoster = m.top.findNode("arrowPoster")
    m.timer = m.top.findNode("timerToPlayVideo")

    m.arrowPoster.visible = false
    m.rowlist.visible = false
    m.infoRectangle.visible = false
    m.hdrPoster.visible = true
    m.visibleUI = true

    m.di = CreateObject("roDeviceInfo")

    SetSizeUI()
    LoadJSONFile()
    m.rowlist.observeField("rowItemFocused", "ChannelChange")

    m.top.setFocus(true)
end sub


sub LoadJSONFile() as void
    m.readPosterGridTask = createObject("roSGNode", "ContentReader")
    m.readPosterGridTask.contenturi = "http://gameoff.xyz/vimeo/API.php?mode=playlists&video_width=All&videos=download&new=1&picture_width=295&big_picture_width=960&language=EN&platform=roku"
    m.readPosterGridTask.observeField("content", "ShowRowList")
    m.readPosterGridTask.control = "RUN"
end sub


sub VisibleUI() as void
    m.fgPoster.visible = m.visibleUI
    m.bgPoster.visible = m.visibleUI
    m.rowlist.visible = m.visibleUI
    m.arrowPoster.visible = m.visibleUI
    m.infoRectangle.visible = m.visibleUI
end sub


sub ShowRowList()
    m.bgPoster.visible = true
    m.video.visible = false
    m.rowlist.visible = true
    m.arrowPoster.visible = true
    m.infoRectangle.visible = true
    m.loadingLabel.visible = false
    m.rowlist.content = m.readPosterGridTask.content

    m.timer.ObserveField("fire", "PlayVideo")
    m.timer.control = "start"

    SetSizeUI()
end sub


sub ChannelChange()
    item = m.rowlist.content.getChild(m.rowlist.rowItemFocused[0]).getChild(m.rowlist.rowItemFocused[1])

    videocontent = createObject("RoSGNode", "ContentNode")
    videocontent.title = item.Title
    videocontent.streamformat = "mp4"
    videocontent.url = item.url

    if item.HDR = 1
        m.hdrPoster.visible = true
    else
        m.hdrPoster.visible = false
    end if
    m.bgPoster.uri = item.FHDPOSTERURL
    m.durationLabel.text = str(item.DURATION) + " min"
    m.titleLabel.text = item.Title
    m.infoLabel.text = item.Description
    m.dateLabel.text = item.ReleaseDate
    m.video.content = videocontent
    m.video.visible = false
    m.video.control = "stop"
    m.timer.control = "start"
    SetSizeDateLabel()
end sub


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


sub SetSizeUI()
    rowlist_boundingRect = m.rowlist.boundingRect()
    uiRes = m.di.GetUIResolution()

    m.titleLabel.font.size = 30
    m.infoLabel.font.size = 16

    loadingBoundingRect = m.loadingLabel.boundingRect()

    m.bgPoster.width = uiRes.width
    m.bgPoster.height = uiRes.height
    m.fgPoster.width = uiRes.width
    m.fgPoster.height = uiRes.height
    m.loadingLabel.width = uiRes.width
    m.loadingLabel.height = uiRes.height
    m.video.width = uiRes.width
    m.video.height = uiRes.height

    m.infoRectangle.width = uiRes.width / 1.5
    m.infoRectangle.height = uiRes.height / 3
    m.titleLabel.width = m.infoRectangle.width - 30
    m.titleLabel.height = 40
    m.infoLabel.width = m.infoRectangle.width - 30
    m.infoLabel.height = 150

    m.logoPoster.translation = [uiRes.width - m.logoPoster.width - m.padding, m.padding]
    m.rowlist.translation = [m.padding, (uiRes.height - rowlist_boundingRect.height) + 300]
    m.infoRectangle.translation = [m.padding, m.rowlist.translation[1] - m.infoRectangle.height - 30]
    m.arrowPoster.translation = [uiRes.width - m.arrowPoster.width - m.padding, uiRes.height - m.arrowPoster.height - m.padding]

    SetSizeDateLabel ()
    m.top.setFocus(true)
end sub


sub SetSizeDateLabel()
    if m.hdrPoster.visible
        m.hdr_padding = m.hdrPoster.width + m.hdrPoster.translation[0] + m.padding
    else
        m.hdr_padding = m.padding - 5
    end if
    m.dateLabel.width = Len(m.dateLabel.text) * 15
    m.dateLabel.translation = [m.hdr_padding, 60]
    m.durationLabel.translation = [m.dateLabel.width + m.dateLabel.translation[0], 60]
    m.divRectangle.translation = [m.durationLabel.translation[0] - m.padding, 60]
end sub


sub onKeyEvent(key as string, press as boolean) as boolean
    if key = "OK"
        if m.visibleUI
            if m.video.state <> "playing"
                m.loadingLabel.visible = true
            end if
            m.top.setFocus(true)
            m.video.visible = true
            m.visibleUI = false
            VisibleUI()
            return true
        else
            if m.video.state <> "playing"
                m.video.visible = false
            end if
            m.loadingLabel.visible = false
            m.rowlist.setFocus(true)
            m.visibleUI = true
            VisibleUI()
            ShowVideo()
            return true
        end if
    end if
    return false
end sub