#import "@preview/cetz:0.5.0"
#import "../src/bodies.typ": *
#import cetz.draw: *

#set page(width: auto, height: auto, margin: 10pt, fill: none)

#cetz.canvas({
  let earth-pos = (0, 0)
  let body-r = 0.18
  let body-pos = (0, dr.at("earth") + body-r)

  let f-color = rgb("#f97316")

  // Earth drawn first so arrow and body render on top of it
  earth(center: earth-pos, name: (text: [Earth], color: black))

  // Force arrow: tail just below body, head at Earth's surface — drawn on top of Earth
  let arrow-s = (body-pos.at(0), body-pos.at(1) - body-r - 0.05)
  let arrow-e = (body-pos.at(0), dr.at("earth") - 0.55)
  let mid-y = (arrow-s.at(1) + arrow-e.at(1)) / 2
  line(arrow-s, arrow-e, stroke: (paint: f-color, thickness: 1.2pt), mark: (end: ">", fill: f-color, scale: 0.6))
  content((0.3, mid-y), text(fill: f-color, size: 7pt)[$F$])

  // Small mass on surface — drawn last so it sits cleanly on top
  circle(body-pos, radius: body-r, fill: luma(60%), stroke: none)
  content((body-r + 0.25, body-pos.at(1)), text(fill: black, size: 7pt)[$m$])
})
