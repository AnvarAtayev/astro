#import "@preview/cetz:0.5.0"
#import cetz.draw: *
#import "../src/bodies.typ": *
#import "../src/orbits.typ": *
#import "@preview/ctz-euclide:0.1.5": *

#set page(width: auto, height: auto, margin: 10pt, fill: none)

#cetz.canvas({
  ctz-init()
  ctz-style(point: (shape: "cross", size: 0.1, stroke: black + 1.5pt))

  let R = 2.5
  let h = 0.6
  let d = R + h

  // Horizon tangent point H: OH ⊥ BH, so Hy = R²/d, Hx = R·√(d²−R²)/d
  let sin-phi = R / d
  let cos-phi = calc.sqrt(1 - sin-phi * sin-phi)
  let Hx = R * cos-phi
  let Hy = R * sin-phi

  // Dip angle θ at observer B: cos(θ) = R/(R+h)
  let ang = calc.acos(sin-phi)

  ctz-def-points(
    "O",
    (0, 0),
    "A",
    (0, R),
    "B",
    (0, d),
    "H",
    (Hx, Hy),
  )

  // Draw Earth
  earth(center: (0, 0), radius: R, name: (text: [Earth], color: black))

  // Right triangle O–B–H with right angle at H (tangent = perpendicular to radius)
  ctz-draw(line: ("O", "B", "H", "O", "B"), stroke: black + 1pt)

  // Side labels
  let off = 0.22
  // R: perpendicular offset above-left of OH midpoint
  content(
    (Hx / 2 + sin-phi * off, Hy / 2 - cos-phi * off),
    $R$,
  )
  // h: left of AB midpoint
  content((-off, R + h / 2), $h$, anchor: "east")
  // R+h: left of OB midpoint
  content((-off, d / 2), $R+h$, anchor: "east")

  // θ arc at O: between adjacent OH and hypotenuse OB
  let phi = calc.atan2(Hy, Hx)
  let arc-r = 0.45
  partial-orbit(center: (0, 0), radius: arc-r, start: 90deg - phi, stop: 90deg, stroke: black + 0.8pt)
  let mid-ang = (phi + 90deg) / 2
  content(
    (arc-r * 1.2 * calc.cos(mid-ang), arc-r * 1.7 * calc.sin(mid-ang)),
    $theta$,
  )

  // θ arc at B: between line of sight B→H and horizontal
  let dim = black.transparentize(50%)
  line((0, d), (0.9, d), stroke: (dash: "dashed", paint: dim, thickness: 0.7pt))
  let arc-r2 = 0.4
  arc(
    (arc-r2 * calc.cos(-ang), d + arc-r2 * calc.sin(-ang)),
    start: -ang,
    stop: 0deg,
    radius: arc-r2,
    stroke: black + 0.8pt,
  )
  let mid-ang2 = -ang / 2
  content(
    (arc-r2 * 1.7 * calc.cos(mid-ang2) + 0.05, d + arc-r2 * 1.7 * calc.sin(mid-ang2)),
    $theta$,
  )

  // Right angle mark at H — drawn manually so it paints on top of the Earth texture
  let s = 0.25
  let BH-len = calc.sqrt(d * d - R * R)
  // unit vectors from H toward B and toward O
  let hb-ux = -Hx / BH-len
  let hb-uy = (d - Hy) / BH-len
  let ho-ux = -cos-phi
  let ho-uy = -sin-phi
  let p1 = (Hx + s * hb-ux, Hy + s * hb-uy)
  let p2 = (Hx + s * ho-ux, Hy + s * ho-uy)
  let pc = (Hx + s * hb-ux + s * ho-ux, Hy + s * hb-uy + s * ho-uy)
  line(p1, pc, p2, stroke: black + 1pt)
})
