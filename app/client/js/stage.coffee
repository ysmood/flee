class FL.Stage
	constructor: ->
		@width = 600
		@height = 600

		@$dom = $('#stage')
		@dom = @$dom[0]

		@dom.width = @width
		@dom.height = @height

		@children = []

	size: ->
		{
			width: @width
			height: @height
		}

	add_child: (el) ->
		@children.push el