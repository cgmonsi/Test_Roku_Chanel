function getComponentXAxisParentCenter(parentWidth, componentWidth)
  if parentWidth = invalid or componentWidth = invalid
    return invalid
  end if
  axisCenter = (parentWidth / 2) - (componentWidth / 2)

  return axisCenter
end function


function percentToNumber(percent, value)
  if percent = invalid or value = invalid
    return invalid
  end if
  dec = percent / 100
  number = value * dec

  return number
end function
