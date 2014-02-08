class FL.Ammo
	constructor: ->
		@radius = 5
		@base_velocity = 100
		@random_props()
		@_color = 'red'

	random_props: ->
		if _.random(1)
			# position
			[@x, @y] = [
				_.random(1) * FL.app.stage.width
				Math.random() * FL.app.stage.height
			]

			# velocity
			@velocity = {
				x: (if @x > 0 then -1 else 1) * Math.random() * @base_velocity
				y: (2 * Math.random() - 1) * @base_velocity
			}
		else
			[@x, @y] = [
				Math.random() * FL.app.stage.height
				_.random(1) * FL.app.stage.width
			]

			@velocity = {
				x: (2 * Math.random() - 1) * @base_velocity
				y: (if @y > 0 then -1 else 1) * Math.random() * @base_velocity
			}

	type: ->
		'circle'

	update: ->
		@x += @velocity.x * FL.app.time_delta
		@y += @velocity.y * FL.app.time_delta

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
		if @x < 0 or
		@x > FL.app.stage.width or
		@y < 0 or
		@y > FL.app.stage.height
			@is_die = true
