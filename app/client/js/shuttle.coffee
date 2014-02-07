class FL.Shuttle
	constructor: ->
		[@x, @y] = [0, 0]
		[@width, @height] = [10, 10]
		color = '#333'

	color: ->
		@color

	rect: ->
		[@x++, @y, @width, @height]