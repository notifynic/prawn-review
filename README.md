# Prawn Review Board

A silly phone game: you chair the grant committee at an underwater lab and swipe to fund or reject proposals from three shrimp scientists, while the committee's rules keep changing.

Live (private artifact): https://claude.ai/artifact/93p5k3QT1VDJf1xgZ6qxZ7

## Files

- `template.html` is the game. Edit this one.
- `index.html` is built from it and is the file that gets published. Don't edit it by hand.
- `build.sh` builds `index.html`. It swaps `__GLASSES__`, `__BEAKER__` and `__CLIPBOARD__` for the prawn art in `../pixel-editor/art/lab shrimp final/`.

```sh
sh build.sh
```

Then republish `index.html` to the same artifact so the link stays the same.

## Minigames

One every 15 points, taking turns: Lab Inspection, then Fizz Containment. Grant Pitch Karaoke and Shrimp Stacking are still to build. Tap Lab Crab on the title screen to open the minigame list for testing.
