module.exports = (I={}) ->
  img = new Image
  img.src = "http://3.pixiecdn.com/sprites/131003/original.png"

  defaults I,
    x: 8
    y: 5

  draw: (canvas) ->
    canvas.drawImage img, I.x * 32, I.y * 32
  update: (dt) ->
  move: ({x, y}) ->
    I.x += x
    I.y += y
