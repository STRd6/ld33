module.exports = ->
  tileWidth = 32
  tileHeight = 32
  
  tvURL = "http://1.pixiecdn.com/sprites/131781/original."

  tiles = [
    "http://0.pixiecdn.com/sprites/131780/original."
    "http://3.pixiecdn.com/sprites/131775/original."
    "http://0.pixiecdn.com/sprites/131788/original."
  ].map (name) ->
    img = new Image
    img.src = name

    return img

  Player = require "./player"

  enemy = Player
    name: "Knight Jr"
    url: "http://0.pixiecdn.com/sprites/131792/original."
    x: 9
    y: 7
  
  characters = [
    Player
      name: "BROGRE"
      url: "http://2.pixiecdn.com/sprites/131794/original."
      x: 9
      y: 7
      conversation: [{
        text: """
          BROGRE: Heyy duder... We were having a party with 
          some BudLight Lime® Lime-A-Ritas and were 
          wondering if we could borrow some rock salt...
        """
      }, {
        text: """
          BROGRE: So what do you say, can we borrow...
          BROGRE: OH SHIT! Are you guys watching DIE HARD!?
          BROGRE: Dude, I was asking
          BROGRE: DUDE shut up, can we watch it with you?!
        """
      }, {
        text: """
          Can the Ogre(s) join you?
        """
      }]
  ]

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
    00000000000000000000
    00000000000000000000
    00000000000000000000
  """.split("\n")
  .map (row) ->
    row.split("")
  
  Item = (I) ->
    img = new Image
    img.src = I.url

    I: I
    draw: (canvas) ->
      canvas.drawImage(img, I.x * tileWidth, I.y * tileHeight)
    interact: ->
      if message = I.messages?.rand()
        showDialog
          text: message
          font: I.font

  items = [
    Item
      name: "TV"
      x: 8
      y: 3
      url: tvURL
      font: "italic bold 20px monospace"
      messages: [
        """
          TV: Yippee-ki-yay, motherfucker.
        """
      ]

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

  passable: ({x, y}) ->
    map[y][x] is "2"
  
  enemyAt: ({x, y, name}) ->
    if enemy.I.x is x and enemy.I.y is y
      showDialog 
        text: "#{name} missed #{enemy.I.name}" 
      return true
    else
      return false

  draw: (canvas) ->
    canvas.fill "rgb(32, 16, 16)"

    # Draw Tiles
    map.forEach (row, y) ->
      row.forEach (i, x) ->
        canvas.drawImage tiles[i], x * tileWidth, y * tileHeight

    # Draw Stuff
    items.forEach (item) ->
      item.draw(canvas)

    enemy.draw(canvas)

    characters.forEach (character) ->
      character.draw(canvas)

  update: ->

  interact: ({x, y}) ->
    interacted = false

    items.forEach (item) ->
      if item.I.x is x and item.I.y is y
        item.interact()
        interacted = true
    
    return if interacted

    characters.forEach (character) ->
      if (character.I.x - x).abs() + (character.I.y - y).abs() <= 1
        character.interact()
        interacted = true
