class FL.Controller
	constructor: ->
		@$dom = $('#controller')

		size = FL.app.stage.size()
		@$dom.width size.width
		@$dom.height size.height

		@max_velocity = 0.2
		@velocity = { x: 0, y: 0 }

		@init_anchor()
		@init_mouse_interaction()

	init_anchor: ->
		@$anchor = @$dom.find('.anchor')

		size = FL.app.stage.size()

		@$anchor.css {
			marginLeft: (size.width - @$anchor.width()) / 2
			marginTop: (size.height - @$anchor.height()) / 2
		}

	init_mouse_interaction: ->
		@$dom.hover(
			=>
				@$dom.toggleClass 'hover'
			=>
				@$dom.toggleClass 'hover'
		)

		@$dom.mousemove (e) =>
			if @$dom.hasClass 'hover'
				pos = @$anchor.offset()
				w = @$anchor.width() / 2
				h = @$anchor.height() / 2
				@offset = {
					x: e.pageX - pos.left - w
					y: e.pageY - pos.top - h
				}
				@velocity = {
					x: @offset.x / w * @max_velocity
					y: @offset.y / h * @max_velocity
				}
