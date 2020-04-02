sub init()
    itemcontent = m.top.itemContent
    m.itemposter = m.top.findNode("itemPoster")
    m.itemmask = m.top.findNode("itemMask")
end sub

sub showcontent()
    itemcontent = m.top.itemContent
    m.itemposter.uri = itemcontent.HDPosterUrl
    m.contenturi = m.top.itemContent.HDPosterUrl
end sub

sub showfocus()
    scale = 1 + (m.top.focusPercent * 0.15)
    m.itemposter.scale = [scale, scale]
end sub

sub showrowfocus()
    m.contenturi = m.top.itemContent.HDPosterUrl
    m.itemmask.opacity = 0.75 - (m.top.rowFocusPercent * 0.75)
end sub