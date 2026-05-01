#import "@preview/manifesto:0.2.0": template

#show: it => template(it, toml: toml("/typst.toml"))

#figure(image("../examples/logo.svg", width: 8cm))

= Introduction

`astro` is a Typst package for drawing diagrams of celestial bodies.
It ships pre-defined surfaces for the Sun, all eight planets, the Moon, and Pluto, and exposes a flexible `planet` function for building custom bodies.
All drawing is done on a CeTZ canvas.

= Getting Started

Import `astro` and `cetz`, open a canvas, and call any of the pre-defined body functions:

```typst
#import "@preview/cetz:0.5.0"
#import "@preview/astro:0.1.0": *

#set page(width: auto, height: auto, fill: rgb("#050510"), margin: 20pt)

#cetz.canvas({
  import cetz.draw: *
  earth(center: (0, 0))
  mars(center: (3, 0))
})
```

All body functions accept the same keyword arguments as `planet` (see below).

= Pre-defined Bodies

The following convenience functions are available after `import "@preview/astro:0.1.0": *`.
Each wraps `planet` with a realistic surface texture and a default radius scaled to real relative sizes.

#table(
  columns: (auto, auto, auto),
  [*Function*], [*Default radius*], [*Notes*],
  [`sun(..args)`], [`4.0`], [Yellow gradient with sunspot groups],
  [`mercury(..args)`], [`0.35`], [Grey with Caloris Basin and craters],
  [`venus(..args)`], [`0.87`], [Cloud-banded golden atmosphere],
  [`earth(..args)`], [`1.0`], [Blue ocean, continents, polar ice caps],
  [`moon(..args)`], [`0.27`], [Maria, craters; supports all phase values],
  [`mars(..args)`], [`0.53`], [Rust surface, Valles Marineris, polar caps],
  [`jupiter(..args)`], [`2.5`], [Belt/zone banding, Great Red Spot],
  [`saturn(..args)`], [`2.0`], [Full ring system enabled by default],
  [`uranus(..args)`], [`1.5`], [Thin ring enabled by default],
  [`neptune(..args)`], [`1.45`], [Thin ring enabled by default, Great Dark Spot],
  [`pluto(..args)`], [`0.5`], [Tombaugh Regio heart feature],
)

The example below draws all bodies side by side at their default radii:

```typst
#import "@preview/cetz:0.5.0"
#import "@preview/astro:0.1.0": *

#set page(width: auto, height: auto, fill: rgb("#050510"))

#cetz.canvas({
  import cetz.draw: *
  let gap = 3
  let x = 0
  for (body, fn) in (
    ("sun", sun), ("mercury", mercury), ("venus", venus),
    ("earth", earth), ("mars", mars), ("jupiter", jupiter),
    ("saturn", saturn), ("uranus", uranus), ("neptune", neptune),
    ("pluto", pluto),
  ) {
    fn(center: (x, 0))
    x = x + dr.at(body) + gap
  }
})
```

#image("../examples/planets.svg")

Default radii and display names are also exported as dictionaries for layout arithmetic:

```typst
#import "@preview/astro:0.1.0": dr, dn

// dr.at("earth") == 1.0   (radius in canvas units)
// dn.at("earth") == "Earth"
```

= The `planet` Function

All pre-defined bodies delegate to `planet`. You can call it directly for full control or to draw a custom body.

```typst
planet(
  center: (0, 0),   // (x, y) position on the canvas
  radius: 1,        // radius in canvas units
  surface: none,    // surface key (string) or none for generic_surface
  tilt:   0,        // axial tilt in degrees
  phase:  "full",   // illumination phase (see Moon Phases)
  rings:  false,    // full Saturn-style ring system
  ring:   none,     // thin ring at given semi-major axis (number or none)
  color:  blue,     // fallback colour when surface is none
  name:   "",       // label drawn below the body (empty → no label)
)
```

#table(
  columns: (auto, 1fr),
  [*Parameter*], [*Description*],
  [`center`], [Canvas coordinate `(x, y)` for the centre of the body.],
  [`radius`], [Radius in canvas units. All surface detail and ring geometry scales with this value.],
  [`surface`],
  [Key into the built-in surface map (`"sun"`, `"earth"`, `"moon"`, etc.) or `none` to use `generic_surface(color: color)`.],

  [`tilt`], [Axial tilt applied to the surface and rings, in degrees.],
  [`phase`], [Illumination phase. Applies a shadow overlay. See Moon Phases for valid values.],
  [`rings`], [When `true`, draws a full Saturn-style elliptical ring system behind and in front of the body.],
  [`ring`],
  [When set to a number, draws a single thin ring whose semi-major axis equals the value (in the body's local coordinate space after `radius` scaling).],

  [`color`], [Fill colour used by `generic_surface` when no named `surface` is given.],
  [`name`], [Text label rendered below the body. Pass `""` to suppress the label.],
)

The example below places the Earth and Moon on a dashed orbit line:

```typst
#import "@preview/cetz:0.5.0"
#import "@preview/astro:0.1.0": *

#set page(width: auto, height: auto, fill: rgb("#050510"), margin: 20pt)

#cetz.canvas({
  import cetz.draw: *
  let center-e = (0, 0)
  let center-m = (3.5, 3)
  let r = cetz.vector.dist(center-e, center-m)
  circle(center-e, radius: r, stroke: (dash: "dashed", paint: rgb("#fff")))
  earth(center: center-e)
  moon(center: center-m)
})
```

#image("../examples/orbit.svg")

= Moon Phases

The `phase` parameter accepts the following string values. The same shadow overlay works on any body, not just the Moon.

#table(
  columns: (auto, 1fr),
  [*Value*], [*Description*],
  [`"full"`], [No shadow — fully illuminated.],
  [`"new"`], [Fully shadowed.],
  [`"first crescent"`], [Thin crescent, right side lit.],
  [`"last crescent"`], [Thin crescent, left side lit.],
  [`"first half"`], [Right half lit (first quarter).],
  [`"last half"`], [Left half lit (third quarter).],
  [`"waxing gibbous"`], [More than half lit, right side.],
  [`"waning gibbous"`], [More than half lit, left side.],
  [`"top half"`], [Top half lit.],
  [`"bottom half"`], [Bottom half lit.],
)

```typst
#import "@preview/cetz:0.5.0"
#import "@preview/astro:0.1.0": *

#set page(width: auto, height: auto, fill: rgb("#050510"), margin: 20pt)

#cetz.canvas({
  import cetz.draw: *
  let x = 0
  let r = dr.at("moon")
  for phase in (
    "new", "first crescent", "first half", "waxing gibbous",
    "full", "waning gibbous", "last half", "last crescent",
  ) {
    moon(center: (x, 0), phase: phase, name: phase)
    x = x + 2 * r + 1
  }
})
```

#image("../examples/moon.svg")

= Custom Bodies

Pass `surface: none` and a `color` to draw a plain coloured sphere, or supply a custom surface key that maps to a function you register via the `surfaces` dictionary.

```typst
#cetz.canvas({
  import cetz.draw: *
  // Generic teal body, no label
  planet(center: (0, 0), radius: 1.2, color: teal)

  // Custom axial tilt on a named body
  earth(center: (4, 0), tilt: 23, name: "Earth (tilted)")
})
```

= Solar System Layout

For a more complete scene, the `solar_system` example arranges all bodies on randomised orbits:

```typst
#import "@preview/cetz:0.5.0"
#import "@preview/suiji:0.5.1": *
#import "@preview/astro:0.1.0": *

#set page(width: auto, height: auto, fill: rgb("#050510"), margin: 20pt)

#cetz.canvas({
  import cetz.draw: *
  let center = (0, 0)
  let gap = 3
  let x = 0
  let rng = gen-rng-f(4)
  for (body, fn) in (
    ("sun", sun), ("mercury", mercury), ("venus", venus),
    ("earth", earth), ("mars", mars), ("jupiter", jupiter),
    ("saturn", saturn), ("uranus", uranus), ("neptune", neptune),
    ("pluto", pluto),
  ) {
    let (rng2, theta) = uniform-f(rng, low: 0.0, high: 2 * calc.pi)
    rng = rng2
    let a = center.at(0) + x * calc.cos(theta)
    let b = center.at(1) + x * calc.sin(theta)
    circle((0, 0), radius: x, stroke: (paint: rgb("#fff")))
    fn(center: (a, b), name: "")
    x = x + dr.at(body) + gap
  }
})
```

#image("../examples/solar_system.svg")
