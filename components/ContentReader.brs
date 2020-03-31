sub init()
    m.top.functionName = "getcontent"
end sub

sub getcontent()
    content = createObject("roSGNode", "ContentNode")
    readInternet = createObject("roUrlTransfer")
    readInternet.setUrl(m.top.contenturi)
    json = ParseJSON(readInternet.GetToString())
    categorys = json.data
    db_top = {}
    for each category in categorys
        db_category = {}
        for each video in category.VIDEOS
            db = {}
            db["NAME"] = video.NAME
            db["DURATION"] = video.DURATION
            db["DESCRIPTION"] = video.DESCRIPTION
            db["PICTURE"] = video.PICTURE
            db["BIG_PICTURE"] = video.BIG_PICTURE
            db["HDR"] = video.HDR
            db["RELEASE_TIME"] = video.RELEASE_TIME
            for each key in video.VIDEO
                db["URL"] = video.VIDEO[key]
            end for
            db_category[video.NAME] = db
        end for
        db_top[category.NAME] = db_category
    end for

    m.top.content = ConvertToContentNode(db_top)
end sub


sub ConvertToContentNode(Content as object) as object
    resultNodeArray = {
        children: []
    }

    ContentNode = createObject("RoSGNode", "ContentNode")
    count = 0
    for each key in Content.Keys()
        itemContent = ContentNode.createChild("ContentNode")
        itemContent.title = key
        subItems = Content[key]
        for each key in subItems
            datetime = CreateObject("roDateTime")
            datetime.FromISO8601String(subItems[key].RELEASE_TIME)
            hours = datetime.GetHours().ToStr()
            minutes = datetime.GetMinutes().ToStr()
            date = datetime.AsDateString("short-month-no-weekday") + " " + hours + ":" + minutes

            subItemContent = itemContent.createChild("ContentNode")
            subItemContent.title = subItems[key].NAME
            subItemContent.HDPosterUrl = subItems[key].PICTURE
            subItemContent.FHDPosterUrl = subItems[key].BIG_PICTURE
            subItemContent.url = subItems[key].URL
            subItemContent.Description = subItems[key].DESCRIPTION
            subItemContent.ReleaseDate = date
            newItems = {}
            newItems["HDR"] = subItems[key].HDR
            newItems["DURATION"] = subItems[key].DURATION
            subItemContent.addFields(newItems)
        end for
    end for
    return ContentNode
end sub