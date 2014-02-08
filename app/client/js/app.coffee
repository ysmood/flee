
class FL.App
	constructor: ->
		FL.app = @

		@init_stage()
		@init_renderer()
		@init_controller()
		@init_shuttle()
		@init_ammo_system()
		@init_display()
		@launch()

	init_stage: ->
		@stage = new FL.Stage

	init_renderer: ->
		@renderer = new FL.Renderer @stage

	init_shuttle: ->
		@shuttle = new FL.Shuttle
		@stage.add_child @shuttle

	init_ammo_system: ->
		for i in [0..50]
			@stage.add_child new FL.Ammo

		setInterval(
			=>
				n = 50 - @stage.children.length
				return if n <= 0
				for i in [0..n]
					@stage.add_child new FL.Ammo
		1000)

	init_controller: ->
		@controller = new FL.Controller

	init_display: ->
		@$fps = $('#display .fps')
		@$time = $('#display .time')
		@update_fps = _.throttle @update_fps, 500

		@start_time = Date.now()
		setInterval(@update_time, 100)

	update_timestamp: ->
		@last_timestamp ?= Date.now()

		now = Date.now()
		@time_delta = (now - @last_timestamp) / 1000
		@last_timestamp = now

	update_fps: ->
		@$fps.text _.numberFormat(1 / @time_delta, 2)

	update_time: =>
		@$time.text _.numberFormat(
			(Date.now() - @start_time) / 1000, 2
		)

	update: =>
		@update_timestamp()

		@controller.update()

		@stage.update()

		@update_fps()

		@renderer.render()

		requestAnimationFrame @update

	launch: ->
		requestAnimationFrame @update