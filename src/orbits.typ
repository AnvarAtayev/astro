#import "@preview/cetz:0.5.0"
#import cetz.draw: arc

/// Draw a partial orbit arc centered at `center`.
///
/// - center (array): (x, y) center of the orbit circle
/// - radius (float): orbital radius
/// - start (angle): start angle, e.g. 30deg
/// - stop (angle): stop angle, e.g. 150deg
/// - stroke (stroke): CeTZ stroke dict
#let partial-orbit(
  center: (0, 0),
  radius: 1,
  start: 0deg,
  stop: 90deg,
  stroke: (dash: "dashed", paint: white, thickness: 0.4pt),
) = {
  let sx = center.at(0) + radius * calc.cos(start)
  let sy = center.at(1) + radius * calc.sin(start)
  arc((sx, sy), start: start, stop: stop, radius: radius, stroke: stroke)
}
