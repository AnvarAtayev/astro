#import "surfaces.typ": *

// ── Full ring system (Saturn-style) ───────────────────────────────────────────
//
// Each half is drawn as a true elliptical annulus via merge-path.
// The inner arc uses a negative delta (stop < start) to sweep CW, which
// creates the "hole" without relying on background-color overdraw.

#let add_rings_back() = {
  // Upper half — drawn before the planet so it sits behind it.
  merge-path(close: true, fill: yellowish, stroke: none, {
    arc((1.7, 0), start: 0deg,   stop: 180deg, radius: (1.7, 0.17)) // outer upper CCW
    line((-1.7, 0), (-1.3, 0))
    arc((-1.3, 0), start: 180deg, stop: 0deg,  radius: (1.3, 0.13)) // inner upper CW (delta = -180°)
    line((1.3, 0), (1.7, 0))
  })
}

#let add_rings_front() = {
  // Lower half — drawn after the planet so it sits in front of it.
  merge-path(close: true, fill: yellowish, stroke: none, {
    arc((-1.7, 0), start: 180deg, stop: 360deg,  radius: (1.7, 0.17)) // outer lower CCW
    line((1.7, 0), (1.3, 0))
    arc((1.3, 0),  start: 0deg,   stop: -180deg, radius: (1.3, 0.13)) // inner lower CW (delta = -180°)
    line((-1.3, 0), (-1.7, 0))
  })
}

// ── Single thin ring ──────────────────────────────────────────────────────────

#let add_thin_ring_back(a) = {
  let b = a / 10
  arc((a, 0), start: 0deg, stop: 180deg, radius: (a, b), fill: none, stroke: yellowish + 1pt)
}

#let add_thin_ring_front(a) = {
  let b = a / 10
  arc((-a, 0), start: 180deg, stop: 360deg, radius: (a, b), fill: none, stroke: yellowish + 1pt)
}
