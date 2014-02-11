
class FL.App
	constructor: ->
		FL.app = @

		@init_size()
		@init_stage()
		@init_controller()
		@init_renderer()
		@init_shuttle()
		@init_display()

	init_size: ->
		$win = $(window)
		$main = $('#main')
		w = $win.width()
		h = $win.height()

		if w / h > 2 / 3
			$main.height h
			$main.width Math.floor(h * 2 / 3)
		else
			$main.width w
			$main.height h

	init_stage: ->
		@stage = new FL.Stage
		$('#stage-info').css {
			height: @stage.height
			lineHeight: @stage.height + 'px'
		}

	init_renderer: ->
		window.requestAnimationFrame = window.webkitRequestAnimationFrame or
			window.mozRequestAnimationFrame or
			window.oRequestAnimationFrame or
			window.msRequestAnimationFrame or
			(callback, element) ->
				window.setTimeout( callback, 1000 / 60 )

		@renderer = new FL.Renderer @stage

	init_shuttle: ->
		@shuttle = new FL.Shuttle
		@stage.add_child @shuttle

	init_ammo_system: ->
		num = 2

		@$ammo_count.text @stage.count_ammos()

		@ammo_timer = setInterval(=>
			# As time passed, the number of the ammos will increase
			# y = 5 * log(e, x)
			n = 5 * Math.log(num) - @stage.count_ammos()
			return if n <= 0
			for i in [0..n]
				@stage.add_child new FL.Ammo
			num++

			@$ammo_count.text @stage.count_ammos() - 1
		, 1000)

	clear_ammos: ->
		@stage.children = _.filter @stage.children, (el) ->
			not (el instanceof FL.Ammo)

	init_controller: ->
		@controller = new FL.Controller
		$('#controller-info').css({
			height: @controller.height
			'line-height': @controller.height + 'px'
		})
		$('#main').one 'click', @start

	init_display: ->
		@$time = $('#display .time')
		@$ammo_count = $('#display .ammo')
		@$best = $('#display .best')
		@best = +localStorage.getItem('best') or 0

		@$best.text  _.numberFormat(@best, 2) + 's'

		$('#display').css({ top: - @controller.height })

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
		@play_time = (Date.now() - @start_time) / 1000

		@$time.text _.numberFormat(@play_time, 2) + 's'

	collision_test: ->
		for el in @stage.children
			continue if el instanceof FL.Shuttle

			d = _.distance(el, @shuttle)
			if d < el.radius + @shuttle.radius
				@game_over()

	game_over: ->
		@is_stop = true

		clearInterval @timer
		clearInterval @ammo_timer

		$('#stage-info, #controller-info').removeClass('hide')
		$('#stage-info .smilley').hide()

		if @play_time > @best
			@best = @play_time
			@$best.text _.numberFormat(@best, 2) + 's'
			localStorage.setItem('best', @best)
			$('#stage-info .oh').show()
		else
			$('#stage-info .no').show()

		$('#stage-info .time').text _.numberFormat(@best, 2)

		$('#main').one 'click', @start

	start: =>
		$('#stage-info, #controller-info').addClass('hide')
		@is_stop = false

		@start_time = Date.now()
		@timer = setInterval(@update_timer, 100)

		@controller.reset()
		@shuttle.reset()
		@clear_ammos()
		@init_ammo_system()

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
