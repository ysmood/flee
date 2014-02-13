class FL.Controller
	constructor: ->
		@$dom = $('#controller')
		@ctx = @$dom[0].getContext('2d')

		$main = $('#main')

		@height = $main.height() - FL.app.stage.height
		@width = @height

		@$dom[0].width = @width
		@$dom[0].height = @height

		@max_velocity = FL.app.stage.width

		@reset()

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
		@ctx.fillStyle = '#66ccff'
		@ctx.beginPath()
		@ctx.arc(@mouse_pos.x, @mouse_pos.y, @width * 0.05, 0, 2 * Math.PI)
		@ctx.fill()
		@ctx.closePath()

	update: ->
		@ctx.clearRect(0, 0, @width, @height)

		@draw_anchor()
		@draw_indicator()

	init_mouse_interaction: ->
		move = (e) =>
			if e.originalEvent.touches
				x = e.originalEvent.touches[0].pageX
				y = e.originalEvent.touches[0].pageY
				offset = @$dom.offset()
				@mouse_pos.x = x - offset.left
				@mouse_pos.y = y - offset.top
			else
				@mouse_pos.x = e.offsetX or e.clientX - $(e.target).offset().left
				@mouse_pos.y = e.offsetY or e.clientY - $(e.target).offset().top

			@velocity = {
				x: (@mouse_pos.x / @width * 2 - 1) * @max_velocity
				y: (@mouse_pos.y / @height * 2 - 1) * @max_velocity
			}

			e.preventDefault()

			@$dom.trigger 'move'

		# Check devices.
		if /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
			@$dom.on 'touchmove', move

			# Prevent the document to scroll.
			document.ontouchmove = (e) ->
				e.preventDefault()
		else
			@$dom.mousemove move

