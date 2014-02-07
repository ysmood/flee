class FL.Stage
	constructor: ->
		@width = 800
		@height = 600

		@$dom = $('#stage')
		@dom = @$dom[0]

		@$dom.width 300
		@$dom.height 300

		@children = []

	add_child: (el) ->
		@children.push el