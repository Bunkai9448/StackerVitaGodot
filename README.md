# StackerVitaGodot
A stacker arcade game made with godot 3.5, so I can play it in my vita.\
Sounds created with https://boscaceoil.net/

## Game Controls:
 (There are 2 slightly different versions PS Vita & PC/Mobile)

- Menus are all tactile
- PS Vita users: 'NEW GAME' is tactile, to stop the blocks press SQUARE.
- PC users: It is coded so you can have both SPACE and a tactile 'STOP' button.
- Smartphone users: Play in browser with the PC display, just use the tactile button.

## How to build:
Grab the files in the repository or make a fork and open the project with your godot engine, and you're set.

If you're going to make homebrew for the vita, you can grab the engine and templates here: https://github.com/SonicMastr/godot-vita

## How to use:
The main folder `Stacker for Vita` is the full project with assets.\
The liveArea folder is only required for PS Vita projects, to those who want to see a nice bubble and background.

## Disclaimer:
Everything in this repository has been tested, some features work and some don't but nothing should break your machine. However, the files are provided "as is" use them under your own responsibility.

## Dev info for those who want to implement other features

Due to godot's:
```
Note: Due to keyboard ghosting, is_action_pressed may return false even if one of the action's keys is pressed. See Input examples in the documentation for more information.
``` 
https://docs.godotengine.org/en/3.5/classes/class_inputevent.html#class-inputevent-method-is-action-type.
https://docs.godotengine.org/en/3.5/classes/class_%40globalscope.html#enum-globalscope-joysticklist \
Sometimes the input is not read (With syncrhonous buttons this doesn't happen, however due to the nature of the stacker 
I needed the asyncrhonous buttons to work with the slowed down refreshed times).

There's a glitch when you are in the screen's top stack, where the last line looks randomly shifted one block. However if you follow the display, your blocks won't fall. Since I don't find why this happens, and it doesn't make you lose or anything, I decided to stop losing my mind and let it there. Feel free to fix it and make a push, if you find the reason. 
[Mind you, don't give me "it could be..." issues, test it yourself or be quiet, I've done my debugging too].

The shiftrow uses a one line loop that eats lots of resources, I know, but it was the only Idea I came up with so the delta doesn't make the blocks shifting go too fast for human eyes. If you know a better way, feel free to make a push to solve it.

## Known Bugs

There's a glitch when you are in the screen's top stack, where the last line looks randomly shifted one block. However if you follow the display, your blocks won't fall. Since I don't find why this happens, and it doesn't make you lose or anything, I decided to stop losing my mind and let it there. Feel free to fix it and make a push, if you find the reason. 
[Mind you, don't give me "it could be..." issues, test it yourself or be quiet, I've done my debugging too].

## About credits and License

