class FL.Renderer
	constructor: (@stage = null) ->
		@ctx = @stage.dom.getContext('2d')

	render: ->
		@clear_stage()

		for el in @stage.children
			switch el.type()
				when 'rect'
					@ctx.fillStyle = el.color()
					@ctx.fillRect.apply @ctx, el.rect()

				when 'circle'
					@ctx.fillStyle = el.color()
					@ctx.beginPath()
					@ctx.arc.apply @ctx, el.circle()
					@ctx.fill()
					@ctx.closePath()
		return

	clear_stage: ->
		@stage.dom.width = @stage.dom.width
