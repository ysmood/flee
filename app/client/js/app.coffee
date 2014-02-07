
class FL.App
	constructor: ->
		@init_stage()
		@init_renderer()
		@init_shuttle()
		@launch()

	init_stage: ->
		@stage = new FL.Stage

	init_renderer: ->
		@renderer = new FL.Renderer @stage

	init_shuttle: ->
		@shuttle = new FL.Shuttle
		@stage.add_child @shuttle

	frame_tick: =>
		@renderer.render()
		requestAnimationFrame @frame_tick

	launch: ->
		requestAnimationFrame @frame_tick