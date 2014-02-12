class FL.Renderer
	constructor: (@stage = null) ->
		@ctx = @stage.dom.getContext('2d')

	render: ->
		@clear_stage()

		for el in @stage.children
			switch el.constructor
				when FL.Ammo, FL.Shuttle
					@ctx.drawImage(
						el.image
						el.x - el.radius
						el.y - el.radius
					)

				when FL.Bg
					@ctx.drawImage(
						el.image
						el.x
						el.y
					)
		return

	clear_stage: ->
		@ctx.clearRect(0, 0, FL.app.stage.width, FL.app.stage.height)
