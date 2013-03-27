define [
    'jquery'
    'cs!components/conn'
    'cs!models/user'
    'hbs!views/widgets/widgetOrderDetail/viewWidgetOrderDetail'
], (
    $
    Conn
    User
    ViewWidgetOrderDetail
) ->

    Backbone.View.extend
        order_id: null
        order_data: null
        initialize: ->

            console.log 'initialize order detail'

            this.update()


        close: ->
            this.unbind()
            this.remove()
        update: ->

            _this = this

            update_render = () ->
                progress = 0
                switch _this.options.status
                    when 'Purchase Order Received'
                        progress = 20
                    when 'Order Confirmed'
                        progress = 30
                    when 'Freight Pickup Requested'
                        progress = 50
                    when 'Freight Picked Up'
                        progress = 70
                    when 'Goods Delivered'
                        progress = 100

                data = []
                for c in _this.order_data
                    if c.client.id == User.get('client_id')
                        c.update_able = true
                    else
                        c.update_able = false
                    data.push c

                _this.el.innerHTML = ViewWidgetOrderDetail
                    comments: data
                    progress: progress


            _this = this
            Conn.io.emit 'orders:getOrderDetails', {order_id: _this.options.order_id}, (response) ->
                _this.order_data = response.comments
                console.log response
                update_render()

        render: ->
            return this
        events:
            'click *[data-action]': 'click_data_action'
        click_data_action: (e) ->
            _this = this
            e.preventDefault()
            $el = this.$(e.currentTarget)
            action = $el.attr 'data-action'
            switch action
                when 'add-private-comment'
                    comment = prompt('private comment:')
                    if comment.length
                        Conn.io.emit 'orders:createComment', {comment: comment, hidden: true, order_id: this.options.order_id}, (response) ->
                            _this.update()

                when 'add-public-comment'
                    comment = prompt('public comment:')
                    if comment.length
                        Conn.io.emit 'orders:createComment', {comment: comment, hidden: false, order_id: this.options.order_id}, (response) ->
                            _this.update()

                when 'update-comment'
                    Conn.io.emit 'orders:updateComment', {comment_id: $el.attr('data-comment_id')}, (response) ->
                        _this.update()
