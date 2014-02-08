class FL.Controller
	constructor: ->
		@$dom = $('#controller')

		@width = 200
		@height = 200

		@$dom.width @width
		@$dom.height @height

		# pixel per second.
		@max_velocity = 30

		@velocity = { x: 0, y: 0 }

		@init_anchor()
		@init_mouse_interaction()

	init_anchor: ->
		@$anchor = @$dom.find('.anchor')

		@$anchor.css {
			top: (@width - @$anchor.width()) / 2
			left: (@height - @$anchor.height()) / 2
		}

	init_mouse_interaction: ->
		move = (e) =>
			if e.originalEvent.touches
				pageX = e.originalEvent.touches[0].pageX
				pageY = e.originalEvent.touches[0].pageY
			else
				pageX = e.pageX
				pageY = e.pageY

			pos = @$anchor.offset()
			w = @$anchor.width() / 2
			h = @$anchor.height() / 2
			@offset = {
				x: pageX - pos.left - w
				y: pageY - pos.top - h
			}
			@velocity = {
				x: @offset.x / w * @max_velocity
				y: @offset.y / h * @max_velocity
			}
			e.preventDefault()

		# Check devices.
		if /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
			@$dom.on 'touchmove', move
		else
			@$dom.mousemove move
