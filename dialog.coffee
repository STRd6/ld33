
module.exports = (I={}) ->
  defaults I,
    age: 0
    font: " bold 20px monospace"
    speed: 10
    selectedOption: 0

  lineHeight = 20
  
  I: I
  move: ->
    I.selectedOption += 1
    I.selectedOption = I.selectedOption % I.options.length

  update: (t) ->
    I.age += t

  finished: ->
    I.age * I.speed >= I.text.length

  draw: (canvas, t) ->
    numberOfCharacters = Math.floor(I.age * I.speed)

    text = I.text[0...numberOfCharacters]
    
    if I.age % 0.5 < 0.25
      text += "█"

    canvas.font I.font

    x = 0
    y = 384
    width = 640
    height = 96
    
    textColor = "#D0DDD8"

    # Draw frame
    canvas.drawRect
      color: "#041008"
      x: x
      y: y
      width: width
      height: height
    
    [0, 2].forEach (i) ->
      canvas.drawRect
        color: textColor
        x: x
        y: y + i
        width: width
        height: 1
      
      canvas.drawRect
        color: textColor
        x: x
        y: y - i + height - 1
        width: width
        height: 1
      
      canvas.drawRect
        color: textColor
        x: x + i
        y: y
        width: 1
        height: height
      
      canvas.drawRect
        color: textColor
        x: x - i - 1 + width
        y: y
        width: 1
        height: height
      
    # Draw text
    lines = text.split "\n"
    lines.forEach (line, i) ->
      canvas.drawText
        color: textColor
        text: line
        x: 10
        y: 490 - (4 - i) * lineHeight

    # Draw options
    if this.finished()
      if options = I.options
        options.forEach (option, i) ->
          if i is I.selectedOption
            canvas.drawText
              color: textColor
              text: "▶"
              x: 10
              y: 490 - (2 - i) * lineHeight
          canvas.drawText
            color: textColor
            text: option
            x: 30
            y: 490 - (2 - i) * lineHeight
