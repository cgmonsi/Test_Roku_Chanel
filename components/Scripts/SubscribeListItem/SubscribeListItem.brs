sub init()
    m.top.id = "markuplistitem"
    m.itemPriceDisplay = m.top.findNode("itemPriceDisplay")
    m.itemcursor = m.top.findNode("itemcursor")
    m.itemposter = m.top.findNode("subscribePoster")
end sub

sub showcontent()
    itemcontent = m.top.itemContent
    m.itemPriceDisplay.text = itemcontent.title
end sub

sub showfocus()
    m.itemcursor.opacity = m.top.focusPercent
end sub