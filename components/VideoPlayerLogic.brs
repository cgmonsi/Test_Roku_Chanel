function OpenVideoPlayer(content as Object, index as Integer, isContentList as Boolean) as Object
    video = CreateObject("roSGNode", "MediaView")
    video.content = content
    video.jumpToItem = index
    video.isContentList = isContentList
    video.control = "play"
    m.top.ComponentController.CallFunc("show", {
        view: video
    })
    return video
end function


function OpenVideoPlayerItem(contentItem as Object) as Object
    video = CreateObject("roSGNode", "MediaView")
    video.content = contentItem
    video.isContentList = false
    video.control = "play"
    m.top.ComponentController.CallFunc("show", {
        view: video
    })
    return video
end function