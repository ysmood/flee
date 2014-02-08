class FL.Ammo
	constructor: ->
		@radius = 5
		@base_velocity = 100
		@random_props()
		@_color = 'red'

	random_props: ->
		x = _.random(1) * FL.app.stage.width
		y = Math.random() * FL.app.stage.height

		# position
		[@x, @y] = [x, y]

		# velocity
		@velocity = {
			x: (if @x > 0 then -1 else 1) * Math.random() * @base_velocity
			y: (2 * Math.random() - 1) * @base_velocity
		}

		if _.random(1)
			[@x, @y] = [@y, @x]
			[@velocity.x, @velocity.y] = [@velocity.y, @velocity.x]

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
		if @x < -@radius or
		@x > FL.app.stage.width + @radius or
		@y < -@radius or
		@y > FL.app.stage.height + @radius
			@is_die = true
