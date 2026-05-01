#import "@preview/cetz:0.5.0"
#import cetz.draw: *

#set page(width: auto, height: auto, margin: 10pt, fill: none)

#cetz.canvas({
  let pivot = (0, 0)
  let l = 2.8
  let ang = 22deg
  let sin-t = calc.sin(ang)
  let cos-t = calc.cos(ang)
  let bob = (l * sin-t, -l * cos-t)

  let dim-color = black.transparentize(55%)

  // Ceiling support
  line((-1.7, 0), (1.7, 0), stroke: (thickness: 2pt))
  for i in range(8) {
    let x = -1.5 + i * 0.44
    line((x, 0), (x - 0.2, 0.3), stroke: (thickness: 0.7pt))
  }

  // Dashed vertical equilibrium reference
  line(pivot, (0, -(l + 0.35)), stroke: (dash: "dashed", paint: dim-color, thickness: 0.6pt))

  // Dashed arc showing swing path
  let arc-start = 270deg - ang
  let arc-stop = 270deg + ang
  arc(
    (l * calc.cos(arc-start), l * calc.sin(arc-start)),
    start: arc-start,
    stop: arc-stop,
    radius: l,
    stroke: (dash: "dashed", paint: dim-color, thickness: 0.6pt),
  )

  // Pendulum string
  line(pivot, bob, stroke: (thickness: 1pt))

  // Small angle arc near pivot
  let ang-r = 0.65
  arc(
    (ang-r * calc.cos(270deg), ang-r * calc.sin(270deg)),
    start: 270deg,
    stop: 270deg + ang,
    radius: ang-r,
    stroke: (paint: black, thickness: 0.7pt),
  )

  // θ label between vertical and string
  let mid-ang = 270deg + ang / 2
  content(
    ((ang-r + 0.3) * calc.cos(mid-ang), (ang-r + 0.3) * calc.sin(mid-ang)),
    [$theta$],
  )

  // ℓ label to the right of the string midpoint
  content((bob.at(0) / 2 + cos-t * 0.35, bob.at(1) / 2 + sin-t * 0.35), [$ell$])

  // Gravity arrow beside the bob
  let gx = bob.at(0)
  line((gx, bob.at(1)), (gx, bob.at(1) - 0.75), stroke: (thickness: 1.2pt), mark: (end: ">>", scale: 0.6))
  content((gx + 0.22, bob.at(1) - 0.35), [$g$])

  // Bob
  circle(bob, radius: 0.22, fill: luma(60%), stroke: none)

  // Pivot dot
  circle(pivot, radius: 0.07, fill: black, stroke: none)
})
