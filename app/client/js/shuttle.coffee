class FL.Shuttle
	constructor: ->
		@_color = '#333'
		@radius = FL.app.stage.width * 0.02
		@reset()

	reset: ->
		[@x, @y] = [
			FL.app.stage.width / 2
			FL.app.stage.height / 2
		]

	type: ->
		'circle'

	update: ->
		@x += FL.app.controller.velocity.x * FL.app.time_delta
		@y += FL.app.controller.velocity.y * FL.app.time_delta

		@check_bound()

	color: (color) ->
		if color
			@_color = color
		else
			@_color

	circle: (circle) ->
		if circle
			[@x, @y, @radius] = circle
		else
			[@x, @y, @radius, 0, 2 * Math.PI]

	check_bound: ->
		if @x < 2 * @radius
			@x = 2 * @radius
		if @x > FL.app.stage.width - 2 * @radius
			@x = FL.app.stage.width - 2 * @radius
		if @y < 2 * @radius
			@y = 2 * @radius
		if @y > FL.app.stage.height - 2 * @radius
			@y = FL.app.stage.height - 2 * @radius
