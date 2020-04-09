sub init()
    m.padding = 20

    FindAllNodes()

    m.arrowPoster.visible = false
    m.rowlist.visible = false
    m.infoRectangle.visible = false
    m.hdrPoster.visible = true

    m.visibleUI = true
    m.free_watch = true
    m.visibleSubscribeButton = false
    m.product_id = ""

    m.di = CreateObject("roDeviceInfo")
    m.uiRes = m.di.GetUIResolution()

    SetSubscribeList()
    SetSizeUI()
    LoadJSONFile()
    m.rowlist.observeField("rowItemFocused", "ChannelChange")

    m.top.setFocus(true)
end sub


sub FindAllNodes()
    m.bitmovinPlayerSDK = CreateObject("roSGNode", "ComponentLibrary")
    m.bitmovinPlayerSDK.id = "BitmovinPlayerSDK"
    m.bitmovinPlayerSDK.uri = "https://cdn.bitmovin.com/player/roku/1/bitmovinplayer.zip"
    m.top.appendChild(m.bitmovinPlayerSDK)
    m.bitmovinPlayerSDK.observeField("loadStatus", "onLoadStatusChanged")

    m.purchaseRectangle = m.top.findNode("purchaseRectangle")
    m.subscribePoster = m.top.findNode("subscribePoster")
    m.itemPriceDisplay = m.top.findNode("itemPriceDisplay")
    m.subscribeBoundariesPoster = m.top.findNode("subscribeBoundariesPoster")
    m.purchaseButtonAnimation = m.top.findNode("purchaseButtonAnimation")
    m.subscribeMarkupList = m.top.findNode("subscribeMarkupList")

    m.bgPoster = m.top.findNode("bgPoster")
    m.fgPoster = m.top.findNode("fgPoster")
    m.fgRectangle = m.top.findNode("fgRectangle")

    m.bitmovinVideo = m.top.findNode("bitmovinVideo")
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
    m.timer = m.top.findNode("timerToHideUIVideo")
end sub


sub SetSubscribeList()
    contentNode = createObject("RoSGNode", "ContentNode")
    itemContent1 = ContentNode.createChild("ContentNode")
    itemContent1.title = "0.99$"
    newItems = {}
    newItems["price"] = 0.99
    itemContent1.addFields(newItems)
    itemContent2 = ContentNode.createChild("ContentNode")
    itemContent2.title = "99.99$"
    newItems = {}
    newItems["price"] = 99.99
    itemContent2.addFields(newItems)
    m.subscribeMarkupList.content = contentNode
end sub


sub LoadJSONFile() as void
    m.readPosterGridTask = createObject("roSGNode", "ContentReader")
    m.readPosterGridTask.contenturi = "http://gameoff.xyz/vimeo/API.php?mode=playlists&video_width=All&videos=download&new=1&picture_width=295&big_picture_width=960&language=EN&platform=roku"
    m.readPosterGridTask.observeField("content", "ShowRowList")
    m.readPosterGridTask.control = "RUN"
end sub


sub VisibleUI() as void
    m.fgPoster.visible = m.visibleUI
    m.rowlist.visible = m.visibleUI
    m.arrowPoster.visible = m.visibleUI
    m.infoRectangle.visible = m.visibleUI
end sub


sub ShowRowList()
    m.video.visible = false
    m.rowlist.visible = true
    m.arrowPoster.visible = true
    m.infoRectangle.visible = true
    m.loadingLabel.visible = false
    m.rowlist.content = m.readPosterGridTask.content
    SetSizeUI()
end sub


sub ChannelChange()
    item = m.rowlist.content.getChild(m.rowlist.rowItemFocused[0]).getChild(m.rowlist.rowItemFocused[1])
    m.free_watch = item.Free

    m.top.selectedContent = {
        product_id : item.ID,
        title : "'" + item.Title + "'",
    }

    videocontent = createObject("RoSGNode", "ContentNode")
    videocontent.title = item.Title
    videocontent.streamformat = "mp4"
    videocontent.url = item.url

    data = {
        playback: {
            autoplay: true
        },
        adaptation:{
            preload: true
        },
        source: {
            progressive: item.url,
            title: item.Title
        }
    }

    if m.product_id <> item.ID
        m.product_id = item.ID
        m.bitmovinplayer.callFunc(m.BitmovinFunctions.SETUP, data)
    end if


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
    SetSizeDateLabel()
end sub


sub SetSizeUI()
    rowlist_boundingRect = m.rowlist.boundingRect()

    m.titleLabel.font.size = 30
    m.infoLabel.font.size = 16

    loadingBoundingRect = m.loadingLabel.boundingRect()

    m.bgPoster.width = m.uiRes.width
    m.bgPoster.height = m.uiRes.height
    m.fgPoster.width = m.uiRes.width
    m.fgPoster.height = m.uiRes.height
    m.fgRectangle.width = m.uiRes.width
    m.fgRectangle.height = m.uiRes.height
    m.loadingLabel.width = m.uiRes.width
    m.loadingLabel.height = m.uiRes.height
    m.video.width = m.uiRes.width
    m.video.height = m.uiRes.height

    m.infoRectangle.width = m.uiRes.width / 1.5
    m.infoRectangle.height = m.uiRes.height / 3
    m.titleLabel.width = m.infoRectangle.width - 30
    m.titleLabel.height = 40
    m.infoLabel.width = m.infoRectangle.width - 30
    m.infoLabel.height = 150

    m.logoPoster.translation = [m.uiRes.width - m.logoPoster.width - m.padding, m.padding]
    m.rowlist.translation = [m.padding, (m.uiRes.height - rowlist_boundingRect.height) + 300]
    m.infoRectangle.translation = [m.padding, m.rowlist.translation[1] - m.infoRectangle.height - 30]
    m.arrowPoster.translation = [m.uiRes.width - m.arrowPoster.width - m.padding, m.uiRes.height - m.arrowPoster.height - m.padding]
    m.purchaseRectangle.translation = [m.uiRes.width, m.infoRectangle.translation[1] + m.padding]

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