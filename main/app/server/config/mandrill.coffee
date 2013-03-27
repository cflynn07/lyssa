mandrill = require('node-mandrill')('0n4PjhB09Eboo0BxH7Hdbw')

exports.module = mandrill

return
mandrill '/messages/send',
  message:
    to: [
      name: 'Casey Flynn'
      email: 'casey_flynn@cobarsystems.com'
    ]
    from_email: 'no-reply@voxtracker.com'
    subject: 'testing'
    text: 'Testing123'
, (error, response) ->
