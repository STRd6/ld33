module.exports = (I={}) ->
  defaults I,
    name: "DUDER"
    x: 8
    y: 5

  img = new Image
  img.src = I.url

  I: I
  draw: (canvas) ->
    canvas.drawImage img, I.x * 32, I.y * 32
  update: (dt) ->
  move: ({x, y}, map) ->
    I.x += x
    I.y += y

    revert = true unless map.passable(I)

    if revert
      I.x -= x
      I.y -= y

    map.triggerItems(I)

  interact: ->
    if I.conversation
      showConversation I.conversation.map (data) ->
        extend {}, data
