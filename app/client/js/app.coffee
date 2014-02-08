
class FL.App
	constructor: ->
		FL.app = @

		@init_stage()
		@init_renderer()
		@init_shuttle()
		@init_controller()
		@init_display()
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

	init_display: ->
		@$fps = $('#display .fps')
		@update_fps = _.throttle @update_fps, 500

	update_timestamp: ->
		now = Date.now()
		@time_delta = (now - @last_timestamp) / 1000
		@last_timestamp = now

	update_fps: ->
		@$fps.text _.numberFormat(1 / @time_delta, 2)

	update: =>
		@update_timestamp()

		@update_fps()

		@shuttle.update()

		@renderer.render()

		requestAnimationFrame @update

	launch: ->
		@last_timestamp = Date.now()
		requestAnimationFrame @update