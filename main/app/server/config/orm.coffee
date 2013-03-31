Sequelize = require 'sequelize'

# 'voxtracker' is my development DB & 'production' is production on dotcloud

if GLOBAL.env? && GLOBAL.env.DOTCLOUD_DB_MYSQL_LOGIN?
  sequelize = new Sequelize(
    'production',
    GLOBAL.env.DOTCLOUD_DB_MYSQL_LOGIN,
    GLOBAL.env.DOTCLOUD_DB_MYSQL_PASSWORD,
    host: GLOBAL.env.DOTCLOUD_DB_MYSQL_HOST
    port: GLOBAL.env.DOTCLOUD_DB_MYSQL_PORT
    pool:
      maxConnections: 5
      maxIdleTime: 30
    define:
      underscored: true
    syncOnAssociation: false
  )
else
  sequelize = new Sequelize(
    'lyssa',
    'root',
    'root',
    host: 'localhost'
    port: '8889'
    pool:
      maxConnections: 5
      maxIdleTime: 30
    define:
      underscored: true
    syncOnAssociation: false
  )


  module.exports = sequelize


















return
#Set up models
User = sequelize.define 'user',
  id:         Sequelize.INTEGER
  first_name: Sequelize.STRING
  last_name:  Sequelize.STRING
  email:
    type:   Sequelize.STRING
    unique: true
  password:     Sequelize.STRING
  type:         Sequelize.STRING
  super_admin:  Sequelize.BOOLEAN,
    paranoid: true

Client = sequelize.define 'client',
  id:   Sequelize.INTEGER
  name: Sequelize.STRING
  primary_email: Sequelize.STRING

Order = sequelize.define 'order', {
  id:           Sequelize.INTEGER
  po_num:       Sequelize.STRING
  description:  Sequelize.STRING
  requested_by: Sequelize.STRING
  received:     Sequelize.BOOLEAN
  status:
    type:       Sequelize.STRING
    validate:
      #Fudging ENUM?
      valid_status: (value) ->
        types = [
          'shipped'
          'arrived'
        ]
        if types.indexOf(value) is -1
          throw new Error('Invalid value for order.status')
},{
  instanceMethods:
    getOrdersWithClients: () ->
      Client.findAll
        where: [
          'client_id_recieving = ? OR client_id_shipping = ?',
          this.id,
          this.id
        ]
}

Comment = sequelize.define 'comment',
  id:     Sequelize.INTEGER
  text:   Sequelize.STRING
  hidden:
    type: Sequelize.BOOLEAN
    defaultValue: true

#Add associations
Client.hasMany User
User.belongsTo Client



Client.hasMany Order, as: 'shipping_client', foreignKey: 'client_id_shipping'
Client.hasMany Order, as: 'recieving_client', foreignKey: 'client_id_recieving'
Order.belongsTo Client, as: 'shipping_client', foreignKey: 'client_id_shipping'
Order.belongsTo Client, as: 'recieving_client', foreignKey: 'client_id_recieving'



Order.hasMany Comment
Comment.belongsTo Order
Client.hasMany Comment
Comment.belongsTo Client



#Return all models as 'api'
module.exports =
  Client:   Client
  User:     User
  Order:    Order
  Comment:  Comment


#sequelize.sync()

#UserInstance = User.build
#  clients_id: 10
#  first_name: 'Casey'
#  last_name:  'Flynn'
#  email:      'casey_flynn@cobarsystems.com'
#  password:   'abcdefghijklmp'
#  type: 'baller'

#UserInstance.save()
#console.log UserInstance

