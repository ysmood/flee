
class FL.App
	constructor: ->
		FL.app = @

		@init_stage()
		@init_renderer()
		@init_shuttle()
		@init_controller()
		@launch()

	init_stage: ->
		@stage = new FL.Stage

	init_renderer: ->
		@renderer = new FL.Renderer @stage

	init_shuttle: ->
		@shuttle = new FL.Shuttle
		@stage.add_child @shuttle

	init_controller: ->
		@controller = new FL.Controller

	update: =>
		@shuttle.update()

		@renderer.render()

		requestAnimationFrame @update

	launch: ->
		requestAnimationFrame @update