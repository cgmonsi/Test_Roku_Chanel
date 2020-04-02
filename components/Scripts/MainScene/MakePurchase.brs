sub makePurchase(scene as Object) as void
    metadata = scene.selectedContent

    order = CreateObject("roAssociativeArray")
    order.priceDisplay = metadata.price
    order.price = metadata.price

    orderRequest = m.channelStore.requestPartnerOrder(order, metadata.product_id)

    confirmOrder = CreateObject("roAssociativeArray")
    confirmOrder.title = metadata.title
    confirmOrder.price = Mid(orderRequest.total, 2)
    confirmOrder.priceDisplay = metadata.price
    confirmOrder.orderID = orderRequest.id

    response = m.channelStore.confirmPartnerOrder(confirmOrder, metadata.product_id)
    response.title = metadata.title
    response.priceDisplay = "$" + confirmOrder.price

    scene.callFunc("ShowPurchaseStatus", response)
end sub