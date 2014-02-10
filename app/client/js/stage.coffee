class FL.Stage
	constructor: ->
		$main = $('#main')
		@width = $main.width()
		@height = @width

		@$dom = $('#stage')
		@dom = @$dom[0]

		@dom.width = @width
		@dom.height = @height

		@children = []

	update: ->
		# All dead children will be removed from the stage.
		list = []
		for el in @children
			if not el.is_die
				list.push el
				el.update()

		@children = list

	size: ->
		{
			width: @width
			height: @height
		}

	add_child: (el) ->
		@children.push el