# StackerVitaGodot
A stacker arcade game made with godot 3.5, so I can play in my vita.

## How to build:
Grab the files in the repository or make a fork and open the project with your godot engine, and you're set.

If you're going to make homebrew for the vita, you can grab the engine and templates here: https://github.com/SonicMastr/godot-vita

## How to use:
The main folder `Stacker for Vita` is the full project with assets.\
The liveArea folder is only required for PS Vita projects, to those who want to see a nice bubble and background.

## Known bugs

Sometimes the square key fails, this is due to godot's
```
Note: Due to keyboard ghosting, is_action_pressed may return false even if one of the action's keys is pressed. See Input examples in the documentation for more information.
``` 
Read here if you don't believe me: https://docs.godotengine.org/en/3.5/classes/class_inputevent.html#class-inputevent-method-is-action-type. I leave that because I prefer buttons, and it can be used as a "hard mode". 
(With syncrhonous buttons this doesn't happen, however due to the nature of the stacker I needed the asyncrhonous buttons
to work with the slowed down refreshed times).

Since the above problem doesn't happen with godot's own button nodes, I've also added one to do the same, which also lets 
users with mobile and touch screens play the game.

## Disclaimer
Everything in this repository has been tested, some features work and some don't but nothing should break your machine. However, the files are provided "as is" use them under your own responsibility.

## About credits and License
