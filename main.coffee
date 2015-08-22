# Canvas where we draw our duders
# Text box where we display dialog
# Options to choose from
# Moving around
# Triggered events
# Die Hard Quotes http://www.imdb.com/title/tt0095016/quotes

# Wall Sprites
# Chair Sprites
# TV Sprites
# Goblin Sprites
# Ogre Sprites
# Hero Sprites

# 3 Goblins sitting in a room in a dungeon
# Chillin, watching Die Hard
# Adevnturers come in and try to wreck up the place
# Lvl 1 Cleric
# Goblins kill the poor bastard
# A two headed ogre want's to borrow some rock salt to add to Bud LightTM
# Lime-A-Ritas
# The ogre also wants to stay and watch die hard
# YOU DECIDE
# Lvl 4 Fighter

# Talking to Steve
# STEVE: "Remember that project I was really excited about... well BOSS says I
# Shouldn't work on it any more... so forget it."

# There is a chest in the room, if you try to open it steve says: Boss told us 
# not to mess into that.
# Chest contians healing elixir and broken cassette tape
# They don't keep the Hard-A in Lvl 1 loot tables

# Wait, so do we work here, or is this the break room, because I've always 
# thought it was the break room... That Craig's List add wasn't very specific
# - Steve

# There is a rock trap if you try to leave the room
# Steve will say: Boss says to stay in here
# The rock trap will kill you

# Achievements:
# Die Hard: With a Vengance - Watch all of Die Hard
# Hard Hat Warning - Died to a rock trap
# A Winner is You - Survived all Encounters

# OGRE: "This is our house!"
# OGRE: "You're going DOWN scrote sac!"
# YOU: "So is a scrote sac like a scrotum, or a sack of scrotums?"
# Ogre kills fighter

# Lvl 7 Gladiator
# Axe rends Steve in twain
# CARL: "Steve's dead man..."
# Carl doesn't speak for the rest of the game, sits in the corner '...'

# After the gladiator encounter the rock trap will be trigered and you can
# go out and find another room with some swank loot (wand of death).

# Lvl 10 Thief
# Use wand of death to kill thief

# Lvl 13 mage
# Burns the place to shit
# Hell Spawn then enters and kills Mage

# Grab orb of Zot
# Show orb to Ogre
# Ogre drops it and it shatters
# Messenger comes to tell Steve that his project is back on!
# Steve's dead man...
# G_G

require "cornerstone"

TouchCanvas = require "touch-canvas"
{width, height} = require "./pixie"

style = document.createElement "style"
style.innerText = """
  * {
    box-sizing: border-box;
  }
  html, body {
    margin: 0;
    padding: 0;
    overflow: hidden;
  }
"""
document.head.appendChild style

canvas = TouchCanvas
  width: width
  height: height

document.body.appendChild canvas.element()

keyHandler = (e) ->
  console.log e.keyCode

  switch e.keyCode
    when 13, 32
      console.log "next"
    when 48, 49, 50, 51, 52, 53, 54, 55, 56, 57
      console.log e.keyCode - 48
    when 37 # Left
      console.log "left"
    when 38 # Up
      console.log "up"
    when 39 # Right
      console.log "right"
    when 40 # Down
      console.log "down"

document.addEventListener('keydown', keyHandler, false)

Dialog = require("./dialog")
dialog = Dialog
  font: "italic bold 20px monospace"
  text: """
    TV: Yippee-ki-yay, motherfucker.
    DUDER: Radical   . . .
  """

background = require("./background")()

update = (dt) ->
  background.update(dt)
  dialog.update(dt)

draw = (canvas) ->
  background.draw(canvas)
  dialog.draw(canvas)

dt = 1/60
t = 0
step = (timestamp) ->
  update(dt)
  draw(canvas)
  t += dt

  window.requestAnimationFrame step

window.requestAnimationFrame step