
class FL.App
	constructor: ->
		FL.app = @

		@init_size()
		@init_stage()
		@init_renderer()
		@init_controller()
		@init_shuttle()
		@init_ammo_system()
		@init_display()

	init_size: ->
		$win = $(window)
		$main = $('#main')
		w = $win.width()
		h = $win.height()

		if w / h > 1
			$main.height h
			$main.width Math.floor(h * 2 / 3)
		else
			$main.width w
			$main.height h

	init_stage: ->
		@stage = new FL.Stage
		$('#stage-info').css({ height: @stage.height })

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
		$('#controller-info').css({
			height: @controller.height
			'line-height': @controller.height + 'px'
		}).click @start

	init_display: ->
		$('#display').css({ top: - @controller.height })
		@$time = $('#display .time')

		w = $(window).width()
		if w < 500
			$('#display').addClass('small')
		else
			$('#display').addClass('large')

	update_timestamp: ->
		@last_timestamp ?= Date.now()

		now = Date.now()
		@time_delta = (now - @last_timestamp) / 1000
		@last_timestamp = now

	update_timer: =>
		if @is_stop
			clearInterval @timer
			return

		@$time.text _.numberFormat(
			(Date.now() - @start_time) / 1000, 2
		) + 's'

	collision_test: ->
		for el in @stage.children
			continue if el instanceof FL.Shuttle

			d = _.distance(el, @shuttle)
			if d < el.radius + @shuttle.radius
				@stop()
				$('#stage-info, #controller-info').removeClass('hide')

	stop: ->
		@is_stop = true
		@controller.$dom.one 'click', @start

	start: =>
		$('#stage-info, #controller-info').addClass('hide')
		@is_stop = false

		@start_time = Date.now()
		@timer = setInterval(@update_timer, 100)

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

		@renderer.render()

		@collision_test()

		requestAnimationFrame @update
