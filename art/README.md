# Prawn Review Board art

These are the game's code-drawn graphics, exported as PNGs at their real pixel size (one file pixel = one art pixel) so they can be edited. The game still draws them from code; edited files get wired back in when they're ready.

The three scientists are not here. They're Nic's own art, in `../../pixel-editor/art/lab shrimp final/`, and the game reads those files directly.

## Things to keep in mind when editing

- **Transparent backgrounds.** Everything sits on the dark lab wall (`#12222a`) or on bubbles and coats, so the backgrounds must stay transparent.
- **Size can change a little.** Items are shown at a fixed screen size, so a slightly different canvas just changes the pixel scale. Keep them roughly square.
- **The game shows them chunky.** They're scaled up to 4 to 8 times with no smoothing.

## The files

| File | Size | Where it appears |
|---|---|---|
| `lab-crab.png` | 12×12 | Lab Crab: Lab Inspection evidence, the title screen, Fizz's rescue bubble, Shrimp Stacking |
| `grouper.png` | 16×11 | Inspector Grouper, Lab Inspection. Faces right; the game mirrors it when he turns round |
| `evidence-*.png` | 12×10 to 12×11 | Banned things to hide in Lab Inspection. The purple jar is also Fizz's flask in Fizz Containment |
| `decoy-microscope.png`, `decoy-extinguisher.png` | 12×12 | Things you mustn't tap in Lab Inspection |
| `bubble-small.png` | 14×14 | Fizz Containment, one tap |
| `bubble-big.png`, `bubble-cracked.png` | 18×18 | Fizz Containment, two taps; cracked is after the first tap |
| `bubble-crab.png` | 20×20 | The clear bubble Lab Crab rides in (he's drawn on top, so leave the middle empty) |
| `bubble-pop-small.png`, `bubble-pop-big.png` | 14×14, 18×18 | Shown for a split second when a bubble pops |

## Coat examples (Shrimp Stacking)

`coat-examples/` holds one example of each coat section, at the game's phone size (30×24). They're for reference only: the game builds the coat in code, because each section is randomly lumpy and its height changes with the screen size. The coat body is 22 pixels wide in the middle of a 30-pixel tile, which leaves room for the lumps.

- `coat-top.png`: the top section, with rounded shoulders and the V-neck collar
- `coat-middle.png`: any section in between
- `coat-bottom.png`: the bottom, with the flared hem, back vent and Lab Crab's pocket
- `coat-one-shrimp.png`: a tower of one (top and bottom at once)

An edited coat can't just be dropped in. Bring the drawings back and decide then how to cut them into pieces.
