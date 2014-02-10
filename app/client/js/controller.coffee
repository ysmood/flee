class FL.Controller
	constructor: ->
		@$dom = $('#controller')
		@ctx = @$dom[0].getContext('2d')

		@width = 300
		@height = 300

		@$dom[0].width = @width
		@$dom[0].height = @height

		@max_velocity = 500

		@init_mouse_interaction()

	reset: ->
		@mouse_pos = { x: @width / 2, y: @height / 2 }
		@velocity = { x: 0, y: 0 }

	draw_anchor: ->
		@ctx.fillStyle = '#fff'
		@ctx.beginPath()
		@ctx.arc(@width / 2, @height / 2, @width * 0.05, 0, 2 * Math.PI)
		@ctx.fill()
		@ctx.closePath()

	draw_indicator: ->
		@ctx.fillStyle = '#9ebbff'
		@ctx.beginPath()
		@ctx.arc(@mouse_pos.x, @mouse_pos.y, @width * 0.05, 0, 2 * Math.PI)
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
				@mouse_pos.x = x - offset.x
				@mouse_pos.y = y - offset.y
			else
				@mouse_pos.x = e.offsetX
				@mouse_pos.y = e.offsetY

			@velocity = {
				x: (@mouse_pos.x / @width * 2 - 1) * @max_velocity
				y: (@mouse_pos.y / @height * 2 - 1) * @max_velocity
			}

			e.preventDefault()

			@$dom.trigger 'move'

		# Check devices.
		if /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
			@$dom.on 'touchmove', move
		else
			@$dom.mousemove move

