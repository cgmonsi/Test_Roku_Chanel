sub Show(args as Object)
    ShowHomeView()
end sub


function ShowHomeView() as Object
    m.grid = CreateObject("roSGNode", "GridView")
    m.grid.SetFields({
        style: "standard"
        posterShape: "16x9"
    })
    content = CreateObject("roSGNode", "ContentNode")
    content.AddFields({
        HandlerConfigGrid: {
            name: "GridHandler"
        }
    })
    m.grid.content = content
    m.grid.ObserveField("rowItemSelected", "OnGridItemSelected")
    m.top.ComponentController.CallFunc("show", {
        view: m.grid
    })
    m.top.signalBeacon("AppLaunchComplete")
    return m.grid
end function


sub OnGridItemSelected(event as Object)
    grid = event.GetRoSGNode()
    selectedIndex = event.GetData()
    rowContent = grid.content.GetChild(selectedIndex[0])
    detailsView = ShowDetailsView(rowContent, selectedIndex[1])
    detailsView.ObserveField("wasClosed", "OnDetailsWasClosed")
end sub


sub OnDetailsWasClosed(event as Object)
    details = event.GetRoSGNode()
    m.grid.jumpToRowItem = [m.grid.rowItemFocused[0], details.itemFocused]
end sub