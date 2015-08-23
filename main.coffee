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
    background-color: black;
    margin: 0;
    padding: 0;
    overflow: hidden;
  }
  canvas {
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    margin: auto;
  }
"""
document.head.appendChild style

canvas = TouchCanvas
  width: width
  height: height

document.body.appendChild canvas.element()

Dialog = require("./dialog")
dialog = null
dialogs = []

move = (p) ->
  if dialog
    dialog.move p
  else
    player.move p, map

dieHardPlaying = false
hasElixir = false

emptyCrate = ->
  hasElixir = true

  map.updateItem "Crate",
    conversation: [
      text: """
        It's empty.
      """
    ]

activateCrate = ->
  map.updateItem "Crate",
    conversation: [{
      text: """
        You found a bottle of fizzy liquid and a
        handful of rusted old bottle caps.
      """
      event: emptyCrate
    }, {
      text: """
        STEVE: Sorry to dissapoint, but they don't keep
        any HARD-A around here.
      """
    }]

setSteveConversation = (conversation) ->
  map.characters[0].I.conversation = conversation

setMarcoConversation = (conversation) ->
  map.characters[1].I.conversation = conversation

openDoor = ->
  map.characters[4].I.x = -1
  map.map[8][9] = "2"
  map.map[9][9] = "2"
  map.map[10][9] = "2"
  map.map[11][9] = "2"
  map.map[12][9] = "2"
  map.map[13][9] = "2"
  map.map[14][9] = "2"

reviveKnightJr = ->
  map.characters[3].I.x = 7
  map.characters[3].I.y = 7

  map.characters[3].I.conversation = [
    text: """
      KNIGHT JR: I think I'll just sit here a for
      a bit.
    """
  ]

  map.updateItem "Knight Jr Carcass",
    x: -1
    y: -1

events =
  restart: ->
    location.reload()
  crate: (dialog) ->
    if dialog.I.selectedOption is 0
      activateCrate()
    else
      map.updateItem "Crate",
        conversation: [
          text: """
            MARCO: Jeez man, what's your fascination
            with that crate?
          """
          event: activateCrate
        ]

  door: openDoor

  brogre0: ->
    setTimeout ->
      if dieHardPlaying
        convo = [{
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
          event: "brogre"
        }]
      else
        convo = [{
          text: """
            BROGRE: So what do you say, can we borrow some
            salt?
          """
        }, {
          text: """
            MARCO: Sorry, I don't think we have any salt...
          """
          selectedOption: 1
          event: "brogre"
        }]

      showConversation convo
    , 0

  brogre: (dialog) ->
    setSteveConversation [{
      text: """
        STEVE: Man I really want this job to work
        out... After I lost all that money in the
        stock market this is pretty much all I have
        left...
      """
    }, {
      text: """
        STEVE: And Helen said she's going to leave
        me if I don't start pulling off the bacon...
      """
    }, {
      text: """
        MARCO: I think the expression you're looking
        for is "jerkin' off the pig"
      """
    }, {
      text: """
        STEVE: Yeah, like I was saying Helen's going
        to leave me if I don't start jerkin' off the 
        pig... I'm not so sure that's right either...
      """
      event: "wiz"
    }, {
      text: """
        A fire wizard wanders in.
      """
    }, {
      text: """
        THE WIZ: Don't all get up at once now.
      """
    }]
      
    if dialog.I.selectedOption is 0
      map.characters[2].I.x = 7
      map.characters[2].I.y = 4
      
      map.characters[2].I.conversation = [
        text: """
          BROGRE: Quiet I'm wa...
          BROGRE: SHUT UP BOTH OF YOU I'm wat...
          BROGRE: That's what I was saying!
          BROGRE: You made me miss my favorite part!
        """
      ]

      setMarcoConversation [{
        text: """
          MARCO: Why is that ogre sitting on
          our lunch table?
        """
      }]
    else
      setMarcoConversation [{
        text: """
          MARCO: Did you catch the game last night?
        """
        options: [
          "You know it buddy!"
          "Sorry, not really a fan..."
        ]
      }]

      setTimeout ->
        showConversation [{
          text: """
            BROGRE: Oh, I get it... looks like
            you guys have something planned
            (glances at KNIGHT JR)
          """
        }, {
          text: """
            BROGRE: We'll leave you to it...
            BROGRE: PEACE!
          """
          event: ->
            map.characters[2].I.x = -1
        }]
      , 0
  round2: ->
    map.characters[2].I.x = 9
    map.characters[2].I.y = 7
    
    setMarcoConversation [{
      text: """
        MARCO: Go ask them what they wants.
      """
    }]

  berserker: ->
    # Fight
    # Marco dies
    # Knight Jr and Berserker kill each other
    # G_G
    map.characters[6].I.x = 9
    map.characters[6].I.y = 8
    
    setTimeout ->
      showConversation [{
        text: """
          A wild AXE MANIAC appears!
          
          He looks like he's starving.
        """
      }]
    , 0
    
  butcher: ->
    map.characters[1].I.y = -1

  satiated: ->
    map.addItem
      name: "Splat"
      url: "http://2.pixiecdn.com/sprites/131854/original."
      x: 9
      y: 3
      conversation: [{
        text: """
          That's a lot of blood.
        """
      }]
    
    map.characters[6].I.conversation = [{
      text: """
        AXE MANIAC: Ahh, that reall hits the spot!
      """
    }, {
      text: """
        AXE MANIAC: Get in my greased bag of holding?
      """
    }, {
      text: """
        YOU: Are you coming on to me?
      """
      event: ->
        if map.characters[3].I.x = 7 and map.characters[3].I.y = 7
          setTimeout ->
            showConversation [{
              text: """
                KNIGHT JR is no longer confused.
              """
              event: ->
                map.characters[3].I.x = 8
            }, {
              text: """
                KNIGHT JR flees in terror!
              """
              event: ->
                map.characters[3].I.x = 9
            }, {
              text: """
                KNIGHT JR runs for the door.
                KNIGHT JRs CURSED -1 SPIKED HELMET punctures
                AXE MANIAC's greased scrotum!
              """
              event: ->
                map.characters[3].I.y = 9
            }, {
              text: """
                KNIGHT JR flees down the hallway!
              """
              event: ->
                map.characters[3].I.y = 10
            }, {
              text: """
                A trapdoor in the ceiling opens and a rock 
                falls on your KNIGHT JR's head!
              """
              event: ->
                map.characters[3].I.y = -1
                map.updateItem "Trap",
                  x: -1
                  y: -1
                map.updateItem "Knight Jr Carcass",
                  x: 9 
                  y: 11
            }]
          , 0

          map.characters[6].I.conversation = [{
            text: "AXE MANIAC: Oww, my delicate scrotum!"
          }, {
            text: """
              AXE MANIAC bleeds to death.
            """
          }, {
            text: """
              A tombstone appears out of nowhere!
              
              it reads...
            """
          }, {
            text: """
              Here lies AXE MANIAC... He died as he lived
              greased up and covered in blood.
            """
            event: ->
              map.characters[6].I.x = -1

              map.addItem
                name: "Splat"
                url: "http://2.pixiecdn.com/sprites/131854/original."
                x: 9
                y: 8
                conversation: [{
                  text: """
                    That's a lot of blood.
                  """
                }]
          }]
        else
          map.characters[6].I.conversation = [{
            text: """
              AXE MANIAC butchers YOU
              AXE MANIAC picks up 17kg of GOBLIN MEAT
            """
          }, {
            text: """
              At least you'll make a delicious sandwich...
            """
          }, {
            text: """
              Better luck next time!
            """
            event: "restart"
          }]
    }]

  carco: ->
    if hasElixir
      setTimeout ->
        showConversation [{
          text: """
            Maybe that fizzy liquid could help this kid...
          """
          options: [
            "Give the kid some water"
            "Leave him be"
          ]
          event: ->
            reviveKnightJr() if dialog.I.selectedOption is 0
        }]
      , 0

  knightJr: ->
    openDoor()

    map.characters[3].I.x = 9
    map.characters[3].I.y = 8
    
    if dieHardPlaying
      stevesText = """
        STEVE: Holy shit man, we're kind of in the middle
        of this movie.
      """
    else
      stevesText = """
        STEVE: Who let you in here?
      """

    setTimeout ->
      showConversation [{
        text: """
          **CRASH** 

          A wild kid wearing a knight costume appears!
        """
      }, {
        text: "KNIGHT JR: Prepare to die SCUM!"
      }, {
        text: stevesText
      }, {
        text: """
          KNIGHT JR hits STEVE with his +1 SHORT SWORD
        """
      }, {
        text: """
          STEVE: You son of a bitch! That stings like a
          motherfucker!
        """
      }, {
        text: """
          MARCO throws his -1 BEER CAN OF DEPRESSION
          at KNIGHT JR
                
          The BEER CAN misses
        """
      }, {
        text: "What do you do?"
        options: [
          "ATTACK!"
          "Defend"
        ]
        event: (dialog) ->
          if dialog.I.selectedOption is 0
            action =
              text: """
                You hit KNIGHT JR with your FIST
              """
          else
            action =
              text: """
                You cower behind MARCO
              """
          dialogs.unshift Dialog action
      }, {
        text: """
          STEVE hits KNIGHT JR with his TARNISHED
          EMPLOYEE OF THE MONTH TROPHY
               
          It's super effective!
        """
      }, {
        text: """
          KNIGHT JR was knocked unconscious.
        """
        event: ->
          map.updateItem "Knight Jr Carcass",
            x: 9

          map.characters[3].I.x = -1
          
          # Update dialogs for STEVE, MARCO, KNIGHT JR
          convo = [{
            text: """
              STEVE: I can't believe that just happened.
              I think I need an ice pack.
            """
          }, {
            text: """
              MARCO: And that's why they made you
              employee of the month!
            """
          }, {
            text: """
              STEVE: Do me a solid and drag that CARCASS
              out of the doorway
            """
          }, {
            text: """
              MARCO drags KNIGHT JR into the corner.
            """
            event: ->
              map.updateItem "Knight Jr Carcass",
                x: 7

              setSteveConversation [{
                text: """
                  STEVE: Any news on that ice pack DUDER?
                """
              }]
              
              setMarcoConversation [{
                text: """
                  MARCO: Never a dull moment, eh DUDER?
                """
                event: "round2"
              }, {
                text: """
                  A two headed ogre walks through the open door.
                """
              }]
          }]
          setSteveConversation convo
          setMarcoConversation convo
      }]
    , 0

  wiz: ->
    map.characters[5].I.x = 9
    
    setSteveConversation [
      text: """
        STEVE: Gawd, another asshole...
      """
    ]
    
    setMarcoConversation [
      text: """
        MARCO: I'm getting too old for this shit.
      """
    ]
  
  fire: ->
    map.characters[0].I.x = -1
    map.updateItem "TV",
      x: -1
    map.updateItem "Table",
      x: -1
    map.updateItem "Crate",
      x: -1

    ashURLs =[
      "http://1.pixiecdn.com/sprites/131845/original."
      "http://2.pixiecdn.com/sprites/131846/original."
      "http://1.pixiecdn.com/sprites/131849/original."
      "http://2.pixiecdn.com/sprites/131846/original."
    ]

    [[9, 2], [8, 3], [7, 4], [10, 5]].forEach ([x, y]) ->
      map.addItem
        name: "Ash"
        x: x
        y: y
        url: ashURLs
        conversation: [
          text: """
            It's a pile of smoldering ash.
          """
        ]

    if map.characters[2].I.x is 7
      setTimeout ->
        showConversation [{
          text: """
            The death of TV has enraged BROGRE!
          """
        }, {
          text: """
            BROGRE hits(x2) THE WIZ for 418 DMG
          """
        }, {
          text: """
            THE WIZ dies!
          """
          event: ->
            map.characters[5].I.x = -1

            map.addItem
              name: "Ash"
              x: 9
              y: 8
              url: ashURLs
              conversation: [{
                text: """
                  It's the smoldering remains of THE WIZ.
                """
              }]
        }, {
          text: """
            BROGRE runs down the hall in a furious rage!
          """
          event: ->
            map.characters[3].I.conversation = [
              text: """
                KNIGHT JR: Huh... did I miss something?
              """
              event: "berserker"
            ]

            setMarcoConversation [
              text: """
                MARCO: STEVE's dead man...
              """
              event: "berserker"
            ]
            map.characters[2].I.x = -1
        }]
      , 0
    else
      map.characters[5].I.conversation = [{
        text: """
          THE WIZ: Are you here to beg for the sweet
          release of death?
        """
        options: ["Yes", "No"]
      }, {
        text: """
          THE WIZ: BURN!
        """
      }, {
        text: """
          You burn.
        """
      }, {
        text: """
          Better luck next time!
        """
        event: "restart"
      }]
      setTimeout ->
        showConversation [{
          text: """
            THE WIZ: I got more where that come from holms!
          """
        }]
      , 0

  tv1: (dialog) ->
    return unless dialog.I.selectedOption is 0

    dieHardPlaying = true
    map.replaceItem 0,
      name: "TV"
      url: [
        "http://2.pixiecdn.com/sprites/131830/original."
        "http://3.pixiecdn.com/sprites/131831/original."
        "http://2.pixiecdn.com/sprites/131830/original."
        "http://3.pixiecdn.com/sprites/131831/original."
        "http://1.pixiecdn.com/sprites/131829/original."
      ]
      font: "italic bold 20px monospace"
      conversation: [{
        text: """
          HANS GRUBER: You know my name but who are you?
          Just another American who saw too many movies as
          a child? Another orphan of a bankrupt culture who
          thinks he's John Wayne? Rambo? Marshal Dillon?
        """
      }, {
        text: """
          JOHN MCCLANE: Was always kinda partial to Roy
          Rogers actually. I really like those sequined
          shirts.
        """
      }, {
        text: """
          HANS GRUBER: Do you really think you have a chance
          against us, Mr. Cowboy?
        """
      }, {
        text: """
          JOHN MCCLANE: Yippee-ki-yay, motherfucker.
        """
      }]

keyHandler = (e) ->
  switch e.keyCode
    when 13, 32
      if dialog
        if dialog.finished()
          dialog.event?(dialog)
          events[dialog.event]?(dialog)
          dialog = dialogs.shift()
        else
          dialog.I.age += 100
      else
        map.interact player.I
    when 48, 49, 50, 51, 52, 53, 54, 55, 56, 57
      ;# console.log e.keyCode - 48
    when 37 # Left
      move x: -1, y: 0
    when 38 # Up
      move x: 0, y: -1
    when 39 # Right
      move x: 1, y: 0
    when 40 # Down
      move x: 0, y: 1

document.addEventListener('keydown', keyHandler, false)

global.showDialog = (newDialog) ->
  dialog = Dialog newDialog

global.showConversation = (conversation) ->
  dialogs = conversation.map (convo) ->
    Dialog convo

  dialog = dialogs.shift()

map = require("./map")()
player = require("./player")
  url: "http://1.pixiecdn.com/sprites/131785/original."

showConversation [{
  text: """
    Walk around and interact with stuff by pressing 
    the ARROW KEYS and SPACE BAR
    
    Or not, it's up to you!
  """
}, {
  text: """
    Got it?
  """
  options: [
    "YEAH!"
    "Whatever"
  ]
}]

update = (dt) ->
  map.update(dt)
  player.update(dt)
  dialog?.update(dt)

draw = (canvas) ->
  map.draw(canvas)
  player.draw(canvas)
  dialog?.draw(canvas)

dt = 1/60
t = 0
step = (timestamp) ->
  update(dt)
  draw(canvas)
  t += dt

  window.requestAnimationFrame step

window.requestAnimationFrame step
