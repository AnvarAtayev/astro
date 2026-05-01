#import "@preview/cetz:0.5.0"
#import "../src/bodies.typ": *
#import "../src/orbits.typ": *
#import cetz.draw: *

#set page(width: auto, height: auto, margin: 10pt, fill: none)

#cetz.canvas({
  let earth-pos = (0, 0)
  let moon-pos = (3, 3.6)

  let unit(a, b) = {
    let d = cetz.vector.dist(a, b)
    ((b.at(0) - a.at(0)) / d, (b.at(1) - a.at(1)) / d)
  }

  // Arrow from a body's surface toward `dir`, with an $a$ label on `side` (+1 or -1)
  let centripetal-arrow(from, radius, dir, perp, side) = {
    let s = (from.at(0) + dir.at(0) * (radius + 0.1), from.at(1) + dir.at(1) * (radius + 0.1))
    let e = (s.at(0) + dir.at(0) * 1.6, s.at(1) + dir.at(1) * 1.6)
    let mid = ((s.at(0) + e.at(0)) / 2, (s.at(1) + e.at(1)) / 2)
    let f-color = rgb("#f97316")
    line(s, e, stroke: (paint: f-color, thickness: 1.2pt), mark: (end: ">", fill: f-color, scale: 0.6))
    content((mid.at(0) + perp.at(0) * 0.35 * side, mid.at(1) + perp.at(1) * 0.35 * side), text(
      fill: f-color,
      size: 7pt,
    )[$a$])
  }

  // Tangential velocity arrow on the moon
  let vel-arrow(from, radius, tangent) = {
    let v-color = rgb("#3b82f6")
    let s = (from.at(0) + tangent.at(0) * (radius + 0.1), from.at(1) + tangent.at(1) * (radius + 0.1))
    let e = (s.at(0) + tangent.at(0) * 1.4, s.at(1) + tangent.at(1) * 1.4)
    let mid = ((s.at(0) + e.at(0)) / 2, (s.at(1) + e.at(1)) / 2)
    line(s, e, stroke: (paint: v-color, thickness: 1.2pt), mark: (end: ">", fill: v-color, scale: 0.6))
    content((mid.at(0) - tangent.at(1) * 0.3, mid.at(1) + tangent.at(0) * 0.3), text(fill: v-color, size: 7pt)[$v$])
  }

  let u-em = unit(earth-pos, moon-pos)
  let u-me = (-u-em.at(0), -u-em.at(1))
  let perp = (-u-em.at(1), u-em.at(0))

  // Orbit arc
  let bary = (8.5 / 82.45, 0)
  let orbit-r = cetz.vector.dist(bary, moon-pos)
  partial-orbit(center: bary, radius: orbit-r, start: -10deg, stop: 90deg, stroke: (
    dash: "dashed",
    paint: black.transparentize(60%),
    thickness: 0.4pt,
  ))

  // Distance line
  line(earth-pos, moon-pos, stroke: (paint: black.transparentize(60%), thickness: 0.4pt))
  let r-mid = ((earth-pos.at(0) + moon-pos.at(0)) / 2, (earth-pos.at(1) + moon-pos.at(1)) / 2)
  content((r-mid.at(0) + perp.at(0) * 0.35, r-mid.at(1) + perp.at(1) * 0.35), text(
    fill: black.transparentize(40%),
    size: 7pt,
  )[$r$])

  // Centripetal force arrow on the Moon, directed toward Earth
  centripetal-arrow(moon-pos, dr.at("moon"), u-me, perp, -1)

  // Moon's tangential velocity
  vel-arrow(moon-pos, dr.at("moon"), perp)


  // Bodies
  earth(center: earth-pos, name: (text: [Earth], color: black))
  moon(center: moon-pos, name: (text: [Moon], color: black))
})
