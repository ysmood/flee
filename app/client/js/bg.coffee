class FL.Bg
	constructor: ->
		_.image('/app/img/bg_cloud.png', (tile) =>
			@tile = tile
			tile_num = Math.ceil(FL.app.stage.width / tile.width) + 2
			@image = _.tile_image(tile, tile_num)
		)

		@x = 0
		@y = 0

	update: ->
		@x -= FL.app.controller.velocity.x * FL.app.time_delta * 0.2
		@y -= FL.app.controller.velocity.y * FL.app.time_delta * 0.2
		@x = @x % @tile.width - @tile.width
		@y = @y % @tile.height - @tile.height
