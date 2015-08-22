
module.exports = (I={}) ->
  defaults I,
    age: 0
    font: " bold 20px monospace"
    speed: 10

  lineHeight = 20
  
  update: (t) ->
    I.age += t

  draw: (canvas, t) ->
    numberOfCharacters = Math.floor(I.age * I.speed)

    text = I.text[0...numberOfCharacters]

    canvas.font I.font

    x = 0
    y = 370
    width = 640
    height = 110

    # Draw frame
    canvas.drawRect
      color: "black"
      x: x
      y: y
      width: width
      height: height
    
    [0, 2].forEach (i) ->
      canvas.drawRect
        color: "#DDD"
        x: x
        y: y + i
        width: width
        height: 1
      
      canvas.drawRect
        color: "#DDD"
        x: x
        y: y - i + height - 1
        width: width
        height: 1
      
      canvas.drawRect
        color: "#DDD"
        x: x + i
        y: y
        width: 1
        height: height
      
      canvas.drawRect
        color: "#DDD"
        x: x - i - 1 + width
        y: y
        width: 1
        height: height
      
    # Draw text
    lines = text.split "\n"
    lines.forEach (line, i) ->
      canvas.drawText
        color: "#DDD"
        text: line
        x: 10
        y: 480 - (4 - i) * lineHeight
    # Draw cursor
    