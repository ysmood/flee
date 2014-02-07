class FL.Renderer
	constructor: (@stage = null) ->
		@ctx = @stage.dom.getContext('2d')

	render: ->
		@clear_stage()

		for el in @stage.children
			@ctx.fillStyle = el.color()
			@ctx.fillRect.apply @ctx, el.rect()

		return

	clear_stage: ->
		@stage.dom.width = @stage.dom.width
