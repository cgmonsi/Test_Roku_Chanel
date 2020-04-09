sub onKeyEvent(key as string, press as boolean) as boolean
    if press = true
        if key = "left"
            params = { key: key, seekInterval: 10 }
            setTrickPlayThumbnail(params)
            handled = true
            return true
        else if key = "right"
            params = { key: key, seekInterval: 10 }
            setTrickPlayThumbnail(params)
            handled = true
            return true
        else if key = "OK"
            m.playerUi.callFunc("showUIGroup")
            handled = true
        end if
    end if

    if key = "back"
        if m.top.action <> ""
            return true
        else if m.free_watch = false and m.visibleSubscribeButton
            HideSubscribeButton()
            return true
        end if
        if m.visibleUI = false
            ifShowVideo(false)
            m.playerUi.callFunc("hideUIGroup")
            return true
        end if
    end if
    if key = "OK"
        if m.free_watch = false
            if m.visibleSubscribeButton = false
                ShowSubscribeButton()
                return true
            else
                if press = true and m.top.action = ""
                    Subscribe()
                    return true
                end if
            end if
        else
            if m.visibleUI = true or press = true
                ifShowVideo(true)
            end if
        end if
    end if
    return false
end sub


sub setTrickPlayThumbnail(params as object)
    key = params.key
    seekInterval = params.seekInterval
    if m.bitmovinPlayer.playerState <> "none" or m.bitmovinPlayer.playerState <> "stalling"
        if key = "right"
            seekTime = m.durationAndCurrentTime.currentVideoTime + seekInterval
            if seekTime > m.durationAndCurrentTime.videoDuration
                seekTime = m.durationAndCurrentTime.videoDuration
            end if
        else key = "left"
            seekTime = m.durationAndCurrentTime.currentVideoTime - seekInterval
            if seekTime < 0
                seekTime = 0
            end if
        end if
        m.durationAndCurrentTime.currentVideoTime = seekTime
        m.playerUi.callFunc("setProgressBarWidth", m.durationAndCurrentTime)
        m.bitmovinPlayer.callFunc(m.BitmovinFunctions.SEEK, m.durationAndCurrentTime.currentVideoTime)
    end if
end sub


sub Subscribe()
    itemSubscribe = m.subscribeMarkupList.content.getChild(m.subscribeMarkupList.currFocusRow)
    m.top.selectedContent = {
        product_id : m.top.selectedContent.product_id,
        title : m.top.selectedContent.title,
        price : str(itemSubscribe.price)
        priceDisplay: itemSubscribe.title
    }

    m.fgRectangle.visible = true
    m.loadingLabel.visible = true
    m.top.action = "tvodpurchase"
end sub


sub ShowSubscribeButton()
    m.visibleSubscribeButton = true
    translation_from = m.purchaseRectangle.translation
    translation_to = [m.uiRes.width - m.purchaseRectangle.width - m.padding, m.infoRectangle.translation[1] + m.padding]
    m.purchaseButtonAnimation.getChild(0).keyValue = [translation_from, translation_to]
    m.purchaseButtonAnimation.control = "start"
    m.subscribeMarkupList.setFocus(true)
end sub


sub HideSubscribeButton()
    m.visibleSubscribeButton = false
    translation_from = m.purchaseRectangle.translation
    translation_to = [m.uiRes.width, m.infoRectangle.translation[1] + m.padding]
    m.purchaseButtonAnimation.getChild(0).keyValue = [translation_from, translation_to]
    m.purchaseButtonAnimation.control = "start"
    m.rowlist.setFocus(true)
end sub


sub ifShowVideo(isShow as boolean)
    if isShow = true
        m.playerUi.setFocus(true)
        if m.visibleUI = true
            m.visibleUI = false
            VisibleUI()
        else
            if m.bitmovinPlayer.playerState = "playing"
                m.bitmovinplayer.callFunc(m.BitmovinFunctions.PAUSE, invalid)
            else
                m.bitmovinplayer.callFunc(m.BitmovinFunctions.PLAY, invalid)
            end if
        end if
        onPlayerState()
    else
        m.rowlist.setFocus(true)
        m.playerUi.callFunc("controlPlayerStateInfo", "")
        m.visibleUI = true
        VisibleUI()
    end if
end sub