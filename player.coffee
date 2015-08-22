module.exports = (I={}) ->
  img = new Image
  img.src = "http://1.pixiecdn.com/sprites/131785/original."

  defaults I,
    x: 8
    y: 5

  I: I
  draw: (canvas) ->
    canvas.drawImage img, I.x * 32, I.y * 32
  update: (dt) ->
  move: ({x, y}, map) ->
    I.x += x
    I.y += y

    unless map.passable(I)
      I.x -= x
      I.y -= y
