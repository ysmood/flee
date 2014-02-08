class FL.Controller
	constructor: ->
		@$dom = $('#controller')
		@ctx = @$dom[0].getContext('2d')

		@width = 300
		@height = 300

		@$dom[0].width = @width
		@$dom[0].height = @height

		@mouse_pos = { left: 0, top: 0 }
		@max_velocity = 500
		@velocity = { x: 0, y: 0 }

		@init_mouse_interaction()

	draw_anchor: ->
		@ctx.fillStyle = '#fff'
		@ctx.beginPath()
		@ctx.arc(@width / 2, @height / 2, @width * 0.05, 0, 2 * Math.PI)
		@ctx.fill()
		@ctx.closePath()

	draw_indicator: ->
		@ctx.fillStyle = '#9ebbff'
		@ctx.beginPath()
		@ctx.arc(@mouse_pos.left, @mouse_pos.top, @width * 0.05, 0, 2 * Math.PI)
		@ctx.fill()
		@ctx.closePath()

	update: ->
		@$dom[0].width = @$dom[0].width

		@draw_anchor()
		@draw_indicator()

	init_mouse_interaction: ->
		move = (e) =>
			if e.originalEvent.touches
				x = e.originalEvent.touches[0].pageX
				y = e.originalEvent.touches[0].pageY
				offset = @$dom.offset()
				@mouse_pos.left = x - offset.left
				@mouse_pos.top = y - offset.top
			else
				@mouse_pos.left = e.offsetX
				@mouse_pos.top = e.offsetY

			@velocity = {
				x: (@mouse_pos.left / @width * 2 - 1) * @max_velocity
				y: (@mouse_pos.top / @height * 2 - 1) * @max_velocity
			}

			e.preventDefault()

			@$dom.trigger 'move'

		# Check devices.
		if /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
			@$dom.on 'touchmove', move
		else
			@$dom.mousemove move

