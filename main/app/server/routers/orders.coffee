_      = require 'underscore'
DB     = require '../config/database'
bcrypt = require 'bcrypt'


retrieveOrdersToShip = (req) ->
  if !req.session.user?
    req.io.respond
      success: false
    return

  DB.Order.findAll(
    where:
      client_id_shipping: req.session.user.client_id
    include: [
      'recieving_client'
    ]
  ).success (MyOrders) ->

    res = []
    for o in MyOrders
      otemp = o.values
      otemp.recievingClient = o.recievingClient
      res.push otemp

    req.io.respond
      success:  true
      OrdersToShip: res



retrieveMyOrders = (req) ->
  if !req.session.user?
    req.io.respond
      success: false
    return

  DB.Order.findAll(
    where:
      client_id_recieving: req.session.user.client_id
    include: [
      'shipping_client'
    ]
  ).success (MyOrders) ->

    res = []
    for o in MyOrders
      otemp = o.values
      otemp.shippingClient = o.shippingClient
      res.push otemp

    req.io.respond
      success:  true
      MyOrders: res




retrieveClientsEmails = (req) ->
  if !req.session.user?
    req.io.respond
      success: false
    return

  DB.Client.findAll({
    attributes: [
      'primary_email'
    ]
  }).success (results) ->

    res = []
    for r in results
      res.push r.values.primary_email

    req.io.respond
      success: true
      clients: res






addManual = (req) ->
  if !req.session.user?
    req.io.respond
      success: false
    return

  DB.Client.find(
    where:
      primary_email: req.data.email
  ).success (result) ->

    if result
      DB.Order.create(
        po_num:       req.data.po_num
        description:  req.data.description
        status:       'Purchase Order Received'
        requested_by: req.data.requested_by
        client_id_shipping:   result.values.id
        client_id_recieving:  req.session.user.client_id
      ).success () ->
        console.log 'order created'
        req.io.respond
          success: true
    else

      DB.Client.create(
        name: req.data.email
        primary_email: req.data.email
      ).success (client) ->

        #TODO: Also create a user for this account

         DB.Order.create(
           po_num:       req.data.po_num
           description:  req.data.description
           requested_by: req.data.requested_by
           status:       'Purchase Order Received'
           client_id_shipping:   client.values.id
           client_id_recieving:  req.session.user.client_id
         ).success () ->
           console.log 'order created'
           req.io.respond
             success: true


updateOrderToShip = (req) ->
  if !req.session.user?
    req.io.respond
      success: false
    return

  DB.Order.find(
    where:
      id: req.data.order_id
      client_id_shipping: req.session.user.client_id
  ).success (order) ->
    order.status = req.data.status
    order.save().success () ->
      req.io.respond
        success: true


updateMyOrderStaus = (req) ->
  if !req.session.user?
    req.io.respond
      success: false
    return

  DB.Order.find(
    where:
      id: req.data.order_id
      client_id_recieving: req.session.user.client_id
  ).success (order) ->
    order.received = !order.received
    order.save().success () ->
      req.io.respond
        success: true




getOrderDetails = (req) ->
  if !req.session.user?
    req.io.respond
      success: false
    return

  console.log 'getOrderDetails'
  console.log req.data

  DB.Comment.findAll(
    where: ["order_id = ? AND ((client_id = ? AND (hidden=1 OR hidden=0)) OR (hidden=0))", req.data.order_id, req.session.user.client_id]
    include: [
      'client'
    ]
  ).success (result) ->

    res = []
    for r in result
      temp = r.values
      temp.client = r.client
      res.push temp

    req.io.respond
      success: true
      comments: res



createComment = (req) ->
  if !req.session.user?
    req.io.respond
      success: false
    return

  DB.Comment.create(
    text:       req.data.comment
    order_id:   req.data.order_id
    client_id:  req.session.user.client_id
    hidden:     req.data.hidden
  ).success () ->
    req.io.respond
      success: true



updateComment = (req) ->
  if !req.session.user?
    req.io.respond
      success: false
    return

  DB.Comment.find(
    where:
      id: req.data.comment_id
  ).success (comment) ->
    comment.hidden = !comment.hidden
    comment.save().success () ->
      req.io.respond
        success: true




module.exports = (app) ->
  app.io.route 'orders',
    retrieveMyOrders:      retrieveMyOrders
    retrieveOrdersToShip:  retrieveOrdersToShip
    addManual:             addManual
    retrieveClientsEmails: retrieveClientsEmails
    updateOrderToShip:     updateOrderToShip
    updateMyOrderStaus:    updateMyOrderStaus
    getOrderDetails:       getOrderDetails
    updateComment:         updateComment
    createComment:         createComment




