sub GetContent()
    'feed = ReadAsciiFile("pkg:/feed/feed.json")
    url = CreateObject("roUrlTransfer")
    url.SetUrl("http://gameoff.xyz/vimeo/API.php?mode=playlists&video_width=All&videos=download&new=1&picture_width=295&big_picture_width=960&language=EN&platform=roku")
    url.SetCertificatesFile("common:/certs/ca-bundle.crt")
    url.AddHeader("X-Roku-Reserved-Dev-Id", "")
    url.InitClientCertificates()
    feed = url.GetToString()
    json = ParseJson(feed)
    rootNodeArray = ParseJsonToNodeArray(json)
    m.top.content.Update(rootNodeArray)
end sub

function ParseJsonToNodeArray(jsonAA as Object) as Object
    if jsonAA = invalid then return []
    resultNodeArray = {
        children: []
    }

    for each fieldInJsonAA in jsonAA.data
        itemsNodeArray = []
        for each mediaItem in fieldInJsonAA.VIDEOS
            itemNode = ParseMediaItemToNode(mediaItem)
            itemsNodeArray.Push(itemNode)
        end for
        rowAA = {
            title: fieldInJsonAA.NAME
            hdPosterUrl: mediaItem.PICTURE
            description: mediaItem.DESCRIPTION
            children: itemsNodeArray
        }
        resultNodeArray.children.Push(rowAA)
    end for

    return resultNodeArray
end function

function ParseMediaItemToNode(mediaItem as Object) as Object
    datetime = CreateObject( "roDateTime" )
	datetime.FromISO8601String( mediaItem.RELEASE_TIME )
    hours = datetime.GetHours().ToStr()
	minutes = datetime.GetMinutes().ToStr()
	date = datetime.AsDateString("short-month-no-weekday") + " " + hours + ":" + minutes

    itemNode = Utils_AAToContentNode({
            "id": mediaItem.ID
            "title": mediaItem.NAME
            "description": mediaItem.DESCRIPTION
            "hdPosterUrl": mediaItem.PICTURE
            "RELEASEDATE": date
            "PLAYLIST_ID": mediaItem.PLAYLIST_ID
            "DURATION": mediaItem.DURATION
            "VA": mediaItem.VA
            "HDR": mediaItem.HDR
            "url": ""
        })

    if mediaItem = invalid then
        return itemNode
    end if

    list_content = mediaItem.VIDEO
    seasonArray = []
    for each content in list_content
        itemNode["url"] = list_content[content]
    end for
    
    return itemNode
end function
