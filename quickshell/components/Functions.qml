// Functions.qml
pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
  // Whole-pixel width that drops by a fixed `step` per unit of distance,
  // never going below `min`. Returns 0 from `cutoff` onwards.
  function linearWidth(distance: int, min: int, max: int, cutoff: int, step: real): int {
    if (distance >= cutoff)
      return 0
    return Math.round(Math.max(min, max - step * distance))
  }

  // Whole-pixel width where the extra width above `min` shrinks by the factor
  // `falloff` (0..1, smaller = faster) per unit of distance.
  // Returns 0 from `cutoff` onwards.
  function decayWidth(distance: int, min: int, max: int, cutoff: int, falloff: real): int {
    if (distance >= cutoff)
      return 0
    return Math.round(min + (max - min) * Math.pow(falloff, distance))
  }

  // Whole-pixel width that falls off like a bell curve with the distance
  // from the focused item. Returns 0 from `cutoff` onwards.
  // `spread` is 2*sigma^2: larger keeps more neighbours wide.
  function gaussianWidth(distance: int, min: int, max: int, cutoff: int, spread: real): int {
    if (distance >= cutoff)
      return 0
    return Math.round(min + (max - min) * Math.exp(-(distance * distance) / spread))
  }

  // Pick a glyph for a value from 0 to 1.
  // `levels` is a list of { min, glyph } entries sorted by `min` ascending.
  // The result is the glyph of the last entry whose `min` the value has reached.
  function levelGlyph(value: real, levels: var): string {
    let result = levels[0].glyph
    for (const level of levels) {
      if (value >= level.min)
        result = level.glyph
    }
    return result
  }
}
