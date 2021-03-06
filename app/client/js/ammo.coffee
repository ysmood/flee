class FL.Ammo
	constructor: ->
		@radius = Math.round FL.app.stage.width * 0.03
		@width = @radius * 2
		@height = @width

		_.image('/app/img/star.png', (image) =>
			@image = image
		, @width, @height)

		@base_velocity = FL.app.stage.width * 0.2

		# If the ammo is too near to the shuttle, recalculate the position.
		for i in [0...30]
			@random_props()
			if _.distance(@, FL.app.shuttle) > @radius * 7
				break

	random: (max, min) ->
		Math.random() * (max - min) + min

	random_props: ->
		rand = _.random(1)
		x = rand * FL.app.stage.width + @radius * (2 * rand - 1)
		y = Math.random() * FL.app.stage.height

		# position
		[@x, @y] = [x, y]

		# velocity
		@velocity = {
			x: (if @x > 0 then -1 else 1) * @random(0.3, 1) * @base_velocity
			y: (2 * @random(0.3, 1) - 1) * @base_velocity
		}

		if _.random(1)
			[@x, @y] = [@y, @x]
			[@velocity.x, @velocity.y] = [@velocity.y, @velocity.x]

		# pursuit the shuttle.
		offset = _.pt_sum(
			_.pt_sum(FL.app.shuttle, @, -1)
			@velocity
		-1)
		offset = _.pt_scale(offset, @random(0.3, 0.6))
		@velocity = _.pt_sum(@velocity, offset)

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
			[
				@x
				@y
				@radius
				0
				2 * Math.PI
			]

	check_bound: ->
		if @x < -@radius or
		@x > FL.app.stage.width + @radius or
		@y < -@radius or
		@y > FL.app.stage.height + @radius
			@is_die = true
