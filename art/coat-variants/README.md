# Lab coat pieces (Shrimp Stacking)

These pieces replace the code-drawn coat sections. The coat is built from pre-drawn pieces that all meet at the same 24-pixel-wide edge, so they join without seams. Each join gets one of nine leaning pieces, picked from how far the next shrimp landed. Any leftover offset is sheared across the piece, row by row. Shrimp heads poke out through the coat's front opening (the button line).

All sizes below are in **art pixels** (one PNG pixel). A shrimp sprite is 34 art pixels wide.

## Files

| File | Size | Use |
|---|---|---|
| `coat-mid-straight.png` | 56×25 | Join with a lean of 0 (lumpy, double bulge) |
| `coat-mid-right1.png` … `right4.png` | 56×25 | Leans of +4, +8, +12, +16 (top is further right than bottom) |
| `coat-mid-left1.png` … `left4.png` | 56×25 | Leans of −4, −8, −12, −16 |
| `coat-top-scampi.png`, `coat-top-specsworth.png`, `coat-top-fizz.png` | 36×40 | Collar and shoulders above the top shrimp. Each has that shrimp's head and neck drawn in, and its own pen colour. Use the one for whoever is on top. |
| `coat-bottom.png` | 36×16 | Hem, back vent and Lab Crab's pocket, below the bottom shrimp |
| `head-scampi.png`, `head-specsworth.png`, `head-fizz.png` | 10×15, 10×17, 10×15 | Head crops for the shrimp lower down the tower, poking out of the front opening |
| `coat-pieces.json` | | Anchor points, sizes, front-line positions and which way each head faces |

Straight and ±4 are lumpy. ±8 to ±16 are smooth S-curves with fold creases inside the bend. Backgrounds are transparent.

## `coat-pieces.json`

For each file:

- `bottom`: `[x, y]` of the centre of the piece's bottom edge (middle pieces and the three top pieces).
- `headIncluded`: on the top pieces. The head is already drawn in, so don't draw another one.
- `faces`: on the head files, `left` or `right`.
- `top`: `[x, y]` of the centre of the top edge (middle pieces and `coat-bottom.png`).
- `lean`: top centre x minus bottom centre x (middle pieces only).
- `size`: `[width, height]`.
- `frontX`: for each row, the x of the front line (button line). Heads are placed on this.

## How the tower is laid out

Each shrimp sits **at a join**. Shrimp `k`'s join row is `Y(k) = baseY − 24·k`, where 24 art pixels is the shrimp spacing (70% of a 34-pixel shrimp).

- **Bottom piece:** its top-edge anchor sits on shrimp 0's join, at shrimp 0's x.
- **Middle piece `k`** (between shrimp `k` and shrimp `k+1`): its bottom anchor sits on shrimp `k`'s join, at shrimp `k`'s x. It is 25 rows tall, so its top row overlaps the bottom row of the piece above by one row. Both rows have the same width and shading, so the overlap is invisible.
- **Top piece:** pick `coat-top-{scampi|specsworth|fizz}.png` for whoever is on top. Its bottom anchor (`[18, 39]`) sits on the top shrimp's join, at that shrimp's x. When a new shrimp lands, the shrimp that was on top becomes a lower shrimp: its section turns into a middle piece, and its head becomes a peeking head (below).

A tower of one shrimp is just bottom plus top.

**Spacing must stay 24 art pixels.** The old coat changed its section height with the screen. With these pieces, keep the tower in art pixels and scale the whole thing up, as the rest of the game's art is.

## Picking the piece for a join

1. Work out `dx`, how far shrimp `k+1` landed from shrimp `k`, in art pixels: `dx = offsetAsFractionOfShrimpWidth × 34`. Positive means to the right.
2. Apply the game's snap first: near-perfect landings (under 7%, about 2.4 art pixels) count as 0.
3. Pick the nearest lean: `step = min(4, round(|dx| / 4))`. 0 is `straight`, otherwise it's `right{step}` or `left{step}` by the sign of `dx`. The piece's lean is `d = ±4·step`.
4. The leftover is `r = dx − d`. It's at most ±2 for landings up to 16 pixels, and a little more in the 16–19 pixel topple zone.

## Drawing a middle piece with the leftover sheared in

Draw the piece one row at a time, shifting each row sideways by part of the leftover. The bottom row doesn't move, and the top row moves by the full `r`, so the top lands exactly on shrimp `k+1`.

```js
const smooth = t => t * t * (3 - 2 * t);

function drawMiddle(ctx, img, meta, shrimpX, joinY, r, frontAt) {
  const [bx] = meta.bottom;
  const h = meta.size[1];
  const px = shrimpX - bx;          // left of the tile
  const py = joinY - (h - 1);       // top of the tile
  for (let row = 0; row < h; row++) {
    const t = (h - 1 - row) / (h - 1);   // 0 at the bottom row, 1 at the top
    const shift = Math.round(r * smooth(t));
    ctx.drawImage(img, 0, row, meta.size[0], 1, px + shift, py + row, meta.size[0], 1);
    frontAt[py + row] = px + shift + meta.frontX[row];   // remember where the front line is
  }
}
```

Draw the coat at art resolution into an offscreen canvas, then scale it up with image smoothing turned off. Order: bottom piece, middle pieces from the bottom up, then the top piece. Record `frontAt` for the top and bottom pieces too (`px + meta.frontX[row]`).

## Heads

**Every shrimp except the top one** pokes out through the front opening, above its own join:

- Centre the head vertically about 11 rows above the shrimp's join (`Y(k) − 11`), where the coat bulges.
- Let `fx = frontAt[that row]`.
- **Facing left** (Scampi, Fizz, and Specsworth when he's mirrored onto the left): put the head's right edge 3 pixels past the front line (`x = fx + 3 − headWidth`). Only draw the head's pixels left of the front line on each row, `x < frontAt[row]`. The coat flap hides the rest.
- **Facing right** (Specsworth): put the head's left edge at `fx − 2`, and only draw pixels right of the front line, `x > frontAt[row]`.
- Draw the heads **after** the coat, so they sit in front of it, with the clipping above standing in for the flap.
- Optional, and it looks good: colour the front-line pixel `#787f9e` for the rows from just above to just below each head, so the opening looks parted.

**The top shrimp** needs nothing extra: its head and neck are part of its `coat-top-*.png`. Draw the top piece after the middle pieces. Specsworth no longer turns side to side on top, since his head is drawn into the piece.

The head files are `head-scampi.png`, `head-specsworth.png` and `head-fizz.png`. They're the head-and-antennae crops of the sprites in `pixel-editor/art/lab shrimp final/`, with the bits of each shrimp's own lab coat removed. Scampi and Fizz face left, and Specsworth faces right (mirror him when he's on the left).

## Repainting the pieces

Any piece can be repainted, as long as these rules hold:

- The **top and bottom rows of every middle piece stay exactly as they are**: 24 pixels wide, same outline and shading, and the same centre (the `top` and `bottom` anchors). That's what makes every piece join every other piece.
- The same goes for the top row of `coat-bottom.png` and the bottom row of each `coat-top-*.png`.
- If the button line moves, update `frontX` in `coat-pieces.json` for that piece.
- The canvas size can grow if needed. Update `size` and the anchors to match.

Coat palette: outline `#787f9e`, mid shade `#acb2c0`, light shade `#c4cad4`, white `#fafaf5`. The shrimp use their own sprite reds.

Lab Crab's pocket stays on `coat-bottom.png`, since he climbs out of it. The breast pocket on the top pieces is decoration.
