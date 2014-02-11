# Underscore helpers


_.mixin(

	msg_box: (options) ->
		###
			options: {
				title: html or jQuery
				body: html or jQuery
				btn_list: [
					{
						name: string
						class: string
						clicked: ->
					}
				]
				shown: ->
				closed: ->
			}
		###

		defaults =
			title: _.l('Title')
			body: ''
			btn_list: [
				name: _.l('Close')
				class: ''
				clicked: ->
					$msg_box.modal('hide')
			]
			shown: null
			closed: null

		opts = _.defaults(options, defaults)

		$msg_box = $('#NB-msg_box').clone()
		$('body').append $msg_box
		tpl_btns = $('#NB-tpl-msg_box_btns').html()

		$msg_box.find('.modal-header').append opts.title
		$msg_box.find('.modal-body').append(opts.body)
		$msg_box.find('.modal-footer').append _.template(tpl_btns, { btn_list: opts.btn_list })

		$msg_box.find('.modal-footer .btn').each((i) ->
			$this = $(this)
			$this.click(opts.btn_list[i].clicked) if opts.btn_list[i].clicked
		)

		$msg_box.on('shown.bs.modal', opts.shown) if opts.shown
		$msg_box.on('hide.bs.modal', opts.closed) if opts.closed

		$msg_box.on('hidden.bs.modal', ->
			$msg_box.remove()
		)

		$msg_box.modal('show')

	info_box: (options) ->
		defaults =
			info: _.l('info box')
			class: ''
			delay: 700

		opts = _.defaults(options, defaults)
		$info_box = $('#NB-info_box')
		$info_box.find('.info').text(opts.info).addClass(opts.class)

		requirejs(['/jquery.transit/jquery.transit.js'], ->
			$info_box.stop(true, true).transit_fade_in(->
				$info_box.stop(true, true).delay(opts.delay).transit_fade_out(->
					$info_box.find('.info').removeClass(opts.class)
				)
			, opts.delay)
		)
		return $info_box

	pt_sum: (point_a, point_b, direction = 1) ->
		###
			Return the sum of two points.
		###

		return {
			x: point_a.x + point_b.x * direction
			y: point_a.y + point_b.y * direction
		}

	pt_scale: (point, scale) ->
		return {
			x: point.x * scale
			y: point.y * scale
		}

	distance: (point_a, point_b) ->
		offset = _.pt_sum(point_a, point_b, -1)
		Math.sqrt(offset.x * offset.x + offset.y * offset.y)

	normalize_vector: (v, unit = 1) ->
		a = _.distance(v, { x: 0, y: 0 })
		{ x: v.x / a * unit, y: v.y / a * unit }

	get_img_size: (url, done) ->
		###
			done = ({width, height}) ->
		###

		img = new Image
		img.src = url
		img.onload = ->
			done
				width: img.width
				height: img.height

	open_new_tab: (url) ->
		win = window.open(url, '_blank')
		win.focus()

	dragging: (options) ->
		###
			options:
				selector: string
				data: any
				mouse_down: (e) ->
				mouse_move: (e) ->
				mouse_up: (e) ->
				window: object
					Useful when using in an iframe.
		###

		if options.window
			win = options.window
		else
			win = window

		$doc = $(win.document)

		mouse_down = (e) ->
			e.data = options.data
			options.mouse_down?(e)

			$doc.mousemove(mouse_move)
			$doc.one('mouseup', mouse_up)

		mouse_move = (e) ->
			e.data = options.data
			options.mouse_move?(e)

		mouse_up = (e)->
			e.data = options.data
			options.mouse_up?(e)

			# Release event resource.
			$doc.off('mousemove', mouse_move)

		$doc.on('mousedown', options.selector, mouse_down)

	req_id: ->
		'req_id=' + Date.now()

	async_run_tasks: (tasks, all_done) ->
		count = 0

		check = ->
			if count < tasks.length
				count++
			else
				all_done?()

		check()

		for task, i in tasks
			task(check, i)

	sync_run_tasks: (tasks, all_done) ->
		###
			tasks: [
				(done, i) ->
			]
			Sync run tasks
		###

		i = 0

		check = ->
			if i < tasks.length
				run()
			else
				all_done?()

		run = ->
			tasks[i](check, i)
			i++

		check()

	class_name: (name) ->
		_.capitalize(name)

	l: (english) ->
		###
			Translate English to current language.
		###

		str = NB.lang[english]
		return str or english

	play_audio: (url) ->
		window.AudioContext = window.AudioContext or window.webkitAudioContext

		if not window.AudioContext
			return

		TDT.audio_ctx ?= new AudioContext()
		TDT.audio_cache ?= {}

		play = ->
			src = TDT.audio_ctx.createBufferSource()
			src.buffer = TDT.audio_cache[url]
			src.connect(TDT.audio_ctx.destination)
			src.start(0)

		if not TDT.audio_cache[url]
			req = new XMLHttpRequest()
			req.open('GET', url, true)
			req.responseType = 'arraybuffer'
			req.onload = ->
				TDT.audio_ctx.decodeAudioData(req.response, (buf) ->
					TDT.audio_cache[url] = buf
					play()
				)
			req.send()
		else
			play()

	scale_image: (img, width, height) ->
		cc = document.createElement("canvas")
		cc.width = width + 1
		cc.height = height + 1
		ctx = cc.getContext("2d")
		ctx.drawImage(img, 0, 0, width, height)
		return cc

	rotate_image: (img, angle) ->
		cc = document.createElement("canvas")
		cc.width = img.width + 1
		cc.height = img.height + 1
		ctx = cc.getContext("2d")
		ctx.translate(img.width / 2, img.height / 2)
		ctx.rotate(angle)
		ctx.drawImage(img, -img.width / 2, -img.height / 2)
		return cc

	tile_image: (img, num) ->
		cc = document.createElement("canvas")
		cc.width = img.width * num
		cc.height = img.height * num
		ctx = cc.getContext("2d")
		for i in [0...num]
			for j in [0...num]
				ctx.drawImage(img, i * img.width, j * img.height)
		return cc

)
