module.exports = ->
  tileWidth = 32
  tileHeight = 32
  
  tvURL = "http://1.pixiecdn.com/sprites/131781/original."

  t = 0

  tiles = [
    "http://0.pixiecdn.com/sprites/131780/original."
    "http://3.pixiecdn.com/sprites/131775/original."
    "http://0.pixiecdn.com/sprites/131788/original."
  ].map (name) ->
    img = new Image
    img.src = name

    return img

  Player = require "./player"
  
  characters = [
    Player
      name: "STEVE"
      url: "http://2.pixiecdn.com/sprites/131822/original."
      x: 10
      y: 5
      conversation: [{
        text: """
          STEVE: Remember that project that I was really
          excited to be working on?
        """
      }, {
        text: "YOU:"
        options: [
          "Yeah (um) totally!"
          "Uhhh... not really..."
        ]
      }, {
        text: """
          STEVE: Yeah... well BOSS called up and told me to 
          cancel it...
          ...
          Sucks.
        """
      }]
    Player
      name: "MARCO"
      url: "http://1.pixiecdn.com/sprites/131825/original."
      x: 9
      y: 3
      conversation: [{
        text: """
          MARCO: So... is this like the break room or are we
          supposed to be working here... The CRAIGSLIST ad
          wasn't really specific.
        """
      }, {
        text: """
          STEVE: About that... have you been having any 
          trouble with your paychecks? Because I haven't 
          been able to cash mine the past few weeks...
        """
      }, {
        text: """
          MARCO: I don't know man, but it's totally not a
          scam. My mom is really good at identifying
          scams and she said this looks legit.
        """
      }]
    Player
      name: "BROGRE"
      url: "http://2.pixiecdn.com/sprites/131794/original."
      x: -1
      y: -1
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
        options: [
          "Sure, grab a chair"
          "Sorry, it's kind of a goblins only thing..."
        ]
      }]
    Player
      name: "Knight Jr"
      url: "http://0.pixiecdn.com/sprites/131792/original."
      x: -1
      y: -1
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
    if typeof I.url is "string"
      img = new Image
      img.src = I.url
    else
      imgs = I.url.map (url) ->
        i = new Image
        i.src = url
        i

    I: I
    draw: (canvas) ->
      if img
        canvas.drawImage(img, I.x * tileWidth, I.y * tileHeight)
      else
        canvas.drawImage(imgs.wrap(Math.floor(t/0.25)), I.x * tileWidth, I.y * tileHeight)
    conversation: ->
      if I.conversation
        I.conversation.map (c) ->
          extend {font: I.font}, c
    interact: ->
      if conversation = this.conversation()
        showConversation conversation
      else if message = I.messages?.rand()
        showDialog
          text: message
          font: I.font

  items = [
    Item
      name: "TV"
      x: 8
      y: 3
      url: tvURL
      conversation: [{
        text: """
          There's a bunch of old DVDs here...
          What do you want to watch?
        """
        options: [
          "Die Hard"
          "Nothing"
        ]
        event: "tv1"
      }]

    Item
      name: "Table"
      x: 7
      y: 4
      url: "http://2.pixiecdn.com/sprites/131826/original."
    
    Item
      name: "Crate"
      x: 9
      y: 2
      url: "http://0.pixiecdn.com/sprites/131836/original."
      conversation: [{
        text: """
          STEVE: BOSS says we shouldn't mess into that...
        """
        options: [
          "Whatever"
          "Actually, you're probably right..."
        ]
        event: "crate"
      }]
    Item
      name: "Door"
      x: 9
      y: 8
      url: "http://1.pixiecdn.com/sprites/131837/original."
  ]

  passable: ({x, y}) ->
    (map[y][x] is "2") and !this.characterAt({x, y})

  characterAt: ({x, y}) ->
    characters.filter (character) ->
      character.I.x is x and character.I.y is y
    .first()

  draw: (canvas) ->
    canvas.fill "rgb(32, 16, 16)"

    # Draw Tiles
    map.forEach (row, y) ->
      row.forEach (i, x) ->
        canvas.drawImage tiles[i], x * tileWidth, y * tileHeight

    # Draw Stuff
    items.forEach (item) ->
      item.draw(canvas)

    characters.forEach (character) ->
      character.draw(canvas)

  updateItem: (name, changes) ->
    items.forEach (item) ->
      if item.I.name is name
        extend item.I, changes

  replaceItem: (index, item) ->
    oldItem = items[index]
    
    item.x ?= oldItem.I.x
    item.y ?= oldItem.I.y

    items[index] = Item item

  update: (dt) ->
    t += dt

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
