function ShowDetailsView(content as Object, index as Integer, isContentList = true as Boolean) as Object
    details = CreateObject("roSGNode", "DetailsView")
    details.ObserveField("currentItem", "OnDetailsContentSet")
    details.ObserveField("buttonSelected", "OnButtonSelected")
    details.SetFields({
        content: content
        jumpToItem: index
        isContentList: isContentList
    })
    m.top.ComponentController.CallFunc("show", {
        view: details
    })
    return details
end function


sub OnDetailsContentSet(event as Object)
    details = event.GetRoSGNode()
    currentItem = event.GetData()
    if currentItem <> invalid
        buttonsToCreate = []

        if currentItem.url <> invalid and currentItem.url <> ""
            buttonsToCreate.Push({ title: "Play", id: "play" })
        end if

        if buttonsToCreate.Count() = 0
            buttonsToCreate.Push({ title: "No Content to play", id: "no_content" })
        end if
        btnsContent = CreateObject("roSGNode", "ContentNode")
        btnsContent.Update({ children: buttonsToCreate })
    end if
    details.buttons = btnsContent
end sub


sub OnButtonSelected(event as Object)
    seasons = m.top.seasons
    rootChildren = {
       children: []
    }

    details = event.GetRoSGNode()
    selectedButton = details.buttons.GetChild(event.GetData())
    if selectedButton.id = "play"
        focusedItem = details.itemFocused
        item = details.content.GetChild(focusedItem)
        OpenVideoPlayer(item, focusedItem, details.isContentList)
    end if
end sub
