
class FL.App
	constructor: ->
		FL.app = @

		@init_stage()
		@init_renderer()
		@init_controller()
		@init_shuttle()
		@init_ammo_system()
		@init_display()

		@start()

	init_stage: ->
		@stage = new FL.Stage

	init_renderer: ->
		@renderer = new FL.Renderer @stage

	init_shuttle: ->
		@shuttle = new FL.Shuttle
		@stage.add_child @shuttle

	init_ammo_system: ->
		num = 32

		setInterval(
			=>
				n = num - @stage.children.length
				return if n <= 0
				for i in [0..n]
					@stage.add_child new FL.Ammo
		1000)

	clear_ammos: ->
		@stage.children = [@shuttle]

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

	collision_test: ->
		for el in @stage.children
			continue if el instanceof FL.Shuttle

			d = _.distance(el, @shuttle)
			if d < el.radius + @shuttle.radius
				@stop()
				_.info_box({info: 'die'})

	stop: ->
		@is_stop = true

	start: ->
		@is_stop = false

		@controller.reset()
		@shuttle.reset()
		@clear_ammos()

		requestAnimationFrame @update

	update: =>
		if @is_stop
			return

		@update_timestamp()

		@controller.update()

		@stage.update()

		@update_fps()

		@renderer.render()

		@collision_test()

		requestAnimationFrame @update
