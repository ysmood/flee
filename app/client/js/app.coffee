require ['/jquery.transit/jquery.transit.js']

class FL.App
	constructor: ->
		FL.app = @

		@init_size()
		@init_stage()
		@init_controller()
		@init_renderer()
		@init_bg()
		@init_shuttle()
		@init_display()
		@init_game_control()

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

		if $main.width() > 920
			$('body').addClass('large')
		else if $main.width() < 500
			$('body').addClass('small')

	init_stage: ->
		@stage = new FL.Stage
		$('#stage-info').css {
			height: @stage.height
		}

	init_renderer: ->
		window.requestAnimationFrame = window.webkitRequestAnimationFrame or
			window.mozRequestAnimationFrame or
			window.oRequestAnimationFrame or
			window.msRequestAnimationFrame or
			(callback, element) ->
				window.setTimeout( callback, 1000 / 60 )

		@renderer = new FL.Renderer @stage

	init_bg: ->
		@bg = new FL.Bg
		@stage.add_child @bg

	init_shuttle: ->
		@shuttle = new FL.Shuttle
		@stage.add_child @shuttle

		@nice_flee = _.debounce(->
			return if @is_stop
			@nice_count++
			_.play_audio('/app/audio/fuu.mp3')
			_.notify { info: 'nice! ( っ*\'ω\'*c)', delay: 1500 }
		, 300)

		# Preload ammo assets.
		new FL.Ammo

	init_ammo_system: ->
		num = 2

		@$ammo_count.text @stage.count_ammos()

		last = 0

		@ammo_timer = setInterval(=>
			if @is_pause
				return
			# As time passed, the number of the ammos will increase
			# y = 7 * log(e, x)
			n = 7 * Math.log(num) - @stage.count_ammos()
			for i in [0...n]
				@stage.add_child new FL.Ammo
			num++

			count = @stage.count_ammos()

			# When ammo number changed, play a sound to notice the player.
			if last != count
				_.play_audio('/app/audio/tsin.mp3')

			@$ammo_count.text count
			last = count
		, 1000)

	clear_ammos: ->
		@stage.children = _.filter @stage.children, (el) ->
			not (el instanceof FL.Ammo)

	init_controller: ->
		@controller = new FL.Controller
		$('#controller-info').css({
			height: @controller.height
		})

	init_display: ->
		@ranking_titles = [
			'you sure?'
			'dull man'
			'( °Д °;)'
			'(=ﾟωﾟ)ノ'
			'beat the developer!'
			'who\'s your daddy?'
			'your dad know this?'
			'time traveler!'
			'eternal!'
			'forever alone!'
			'you cheater!'
		]

		@$time = $('#display .time')
		@$ammo_count = $('#display .ammo')
		@$best = $('#display .best')
		@best = +localStorage.getItem('best') or 0

		@$best.text  _.numberFormat(@best, 2) + 's'

	init_game_control: ->
		@is_stop = true
		$('#main').on 'click', '#stage, #stage-info, #controller, #controller-info', =>
			if @is_stop
				@start()
			else if @is_pause
				@resume()
			else
				@pause()
		$(window).blur =>
			if not @is_stop
				@pause()

	update_timestamp: ->
		@last_timestamp ?= Date.now()

		now = Date.now()
		@time_delta = (now - @last_timestamp) / 1000
		@last_timestamp = now

	update_timer: =>
		if @is_pause
			return

		now = Date.now()
		@play_time += (now - @last_play_time) / 1000

		if @report_time_count++ % 50 == 0
			$('#time-reporter')
				.transit_fade_in()
				.delay(1500)
				.transit_fade_out()
				.text _.numberFormat(@play_time, 0)

		@$time.text _.numberFormat(@play_time, 2) + 's'

		@last_play_time = now

	collision_test: ->
		for el in @stage.children
			continue if el instanceof FL.Shuttle

			d = _.distance(el, @shuttle)

			if d <= el.radius + @shuttle.radius
				@game_over()
			else if d < el.radius + @shuttle.radius * 1.2
				@nice_flee()

	start: =>
		@is_stop = false

		@resume()

		_.play_audio('/app/audio/da.mp3')

		$('#stage-info, #controller-info').hide()
		$('#stage-info .result').hide()

		@report_time_count = 1
		@play_time = 0
		@nice_count = 0

		@timer = setInterval(@update_timer, 100)

		@controller.reset()
		@shuttle.reset()
		@clear_ammos()
		@init_ammo_system()

		requestAnimationFrame @update

	pause: ->
		@is_pause = true
		$('#stage-info, #controller-info').transit_fade_in()
		@stage.$dom.addClass('blur')
		$('#stage-info .tap').text 'Tap to Resume'

	resume: ->
		@is_pause = false
		@last_timestamp = Date.now()
		@last_play_time = Date.now()
		$('#stage-info, #controller-info').hide()
		@stage.$dom.removeClass('blur')

	game_over: ->
		@is_stop = true

		_.play_audio('/app/audio/bo.mp3')

		clearInterval @timer
		clearInterval @ammo_timer

		$('#stage-info, #controller-info').transit_fade_in()
		$('#stage-info .result').show()

		@pause()

		if @play_time > @best
			@best = @play_time
			@$best.text _.numberFormat(@best, 2) + 's'
			localStorage.setItem('best', @best)
			$('#stage-info .result').addClass('new_record')
		else
			$('#stage-info .result').removeClass('new_record')

		rank = Math.floor(Math.sqrt(@play_time)) - 1
		if rank > @ranking_titles.length - 1
			rank = @ranking_titles.length - 1
		rank = 0 if rank < 0
		$('#stage-info .smiley').text @ranking_titles[rank]

		$('#stage-info .time').text _.numberFormat(@play_time, 2)
		$('#stage-info .nice').text @nice_count
		$('#stage-info .tap').text 'Tap to Restart'

	update: =>
		if @is_stop
			return

		if @is_pause
			requestAnimationFrame @update
			return

		@update_timestamp()

		@controller.update()

		@stage.update()

		@renderer.render()

		@collision_test()

		requestAnimationFrame @update
