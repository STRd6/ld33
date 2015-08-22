module.exports = ->
  tileWidth = 32
  tileHeight = 32
  
  tvURL = "http://1.pixiecdn.com/sprites/131781/original."

  tiles = [
    "http://0.pixiecdn.com/sprites/131780/original."
    "http://3.pixiecdn.com/sprites/131775/original."
    "http://2.pixiecdn.com/sprites/131782/original."
  ].map (name) ->
    img = new Image
    img.src = name

    return img

  map = """
    00000000000000000000
    00000011111100000000
    00000012222100000000
    00000012222100000000
    00000012222100000000
    00000012222100000000
    00000012222100000000
    00000012222100000000
    00000011111100000000
    00000000000000000000
    00000000000000000000
    00000000000000000000
  """.split("\n")
  .map (row) ->
    row.split("")
  
  Item = (I) ->
    img = new Image
    img.src = I.url

    draw: (canvas) ->
      canvas.drawImage(img, I.x * tileWidth, I.y * tileHeight)

  stuff = [
    Item
      name: "TV"
      x: 8
      y: 3
      url: tvURL
    
    Item
      name: "Table"
      x: 9
      y: 4
      url: "http://3.pixiecdn.com/sprites/131783/original."
    
    Item
      name: "Crate"
      x: 9
      y: 2
      url: "http://0.pixiecdn.com/sprites/131784/original."
  ]

  draw: (canvas) ->
    canvas.fill "rgb(32, 16, 16)"

    # Draw Tiles
    map.forEach (row, y) ->
      row.forEach (i, x) ->
        canvas.drawImage tiles[i], x * tileWidth, y * tileHeight

    # Draw Stuff
    stuff.forEach (item) ->
      item.draw(canvas)

  update: ->