sub Main()
  showChannelSGScreen()
end sub

sub showChannelSGScreen()
  screen = CreateObject("roSGScreen")
  m.port = CreateObject("roMessagePort")
  screen.setMessagePort(m.port)
  scene = screen.CreateScene("MainScene")
  screen.show()

  m.channelStore = CreateObject("roChannelStore")
  
  scene.observeField("action", m.port)
  while(true)
    msg = wait(0, m.port)
    msgType = type(msg)
    if msgType = "roSGScreenEvent"
        if msg.isScreenClosed() then return 'exit channel
    else if msgType = "roSGNodeEvent"
        if (scene.action = "tvodpurchase")
            makePurchase(scene) 'proceed with purchase
        end if
    end if
  end while

end sub
