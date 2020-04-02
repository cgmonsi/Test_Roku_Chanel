sub onKeyEvent(key as string, press as boolean) as boolean
    if key = "back"
        if m.top.action <> ""
            return true
        else if m.free_watch = false and m.visibleSubscribeButton
            HideSubscribeButton()
            return true
        end if
        if m.visibleUI = false
            ifShowVideo(false)
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
            ifShowVideo(press)
        end if
    end if
    return false
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


sub ifShowVideo(press as boolean)
    if m.visibleUI
        if m.video.state <> "playing"
            m.loadingLabel.visible = true
        end if
        m.top.setFocus(true)
        m.video.visible = true
        m.visibleUI = false
        VisibleUI()
    else if press = false
        if m.video.state <> "playing"
            m.video.visible = false
        end if
        m.loadingLabel.visible = false
        m.rowlist.setFocus(true)
        m.visibleUI = true
        VisibleUI()
        ShowVideo()
    end if
end sub