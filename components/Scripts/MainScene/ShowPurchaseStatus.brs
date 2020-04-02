function showPurchaseStatus(response as Object) as void
    msg = "Your purchase of " + response.title
    if (response.status = "Success")
        m.responseSuccess = true
        msg = msg + " was successful."
    else
        m.responseSuccess = false
        if (response.errorMessage = invalid)
            response.errorMessage = response.errorCode
        end if
        msg = msg + " failed." + chr(10) + chr(10) + "Error: " + response.errorMessage
    end if
    m.dialog = createObject("roSGNode", "Dialog")
    m.dialog.title = "Purchase"
    m.dialog.message = msg
    m.buttons = ["OK"]
    m.dialog.buttons = m.buttons

    m.dialog.observeField("buttonSelected", "statusDialogButtonSelected")
    m.dialog.observeField("wasClosed", "statusDialogButtonSelected")

    m.top.dialog = m.dialog

    m.fgRectangle.visible = false
    m.loadingLabel.visible = false
end function


function setFreeVideo() as void
    item = m.rowlist.content.getChild(m.rowlist.rowItemFocused[0]).getChild(m.rowlist.rowItemFocused[1])
    item.Free = 1
    HideSubscribeButton()
end function


function statusDialogButtonSelected() as void
    if m.responseSuccess
        setFreeVideo()
    end if
    m.dialog.close = true
    m.top.action = ""
end function
