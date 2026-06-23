# CPLAN — Top-Locked Custom UCS Tool for AutoCAD

**Version 1.0 | Author: drzkid96**

A lean AutoLISP tool for setting a custom UCS from two picks while staying locked to top. Align the UCS to a centerline or skewed feature, apply a plan view, and keep your prior zoom — without ever tilting off the XY plane.

## Installation

1. Copy `CPLAN.lsp` anywhere on your machine.
2. In AutoCAD, type `APPLOAD` and load the file.
3. To auto-load on every startup, add it to your Startup Suite inside the `APPLOAD` dialog.

## Commands

**CPLAN**

Prompts for a UCS origin and a point on the positive X axis, then sets a top-locked UCS, applies a plan view, and restores the prior zoom. No 3D/isometric UCS possible — Z always stays vertical.

```
Command: CPLAN
New UCS origin: <pick>
Point on positive X axis: <pick>
```

## What It Does

1. Captures the current view center and height.
2. Forces object snap to **Nearest only** for the two picks, then restores prior snaps.
3. Projects both picks to the WCS XY plane (drops Z) so the UCS can never tilt.
4. Resets to World, moves the origin, and rotates the X axis in-plane to match your picks.
5. Applies a plan view to the new UCS, restores the prior zoom scale and center, and regenerates.

The result is always a true top view — only the in-plane rotation comes from your two picks.

## Behavior

| Setting | Action |
| --- | --- |
| OSMODE | Set to `512` (Nearest) during picks, restored after |
| CMDECHO | Saved and restored |
| Cancel | Aborts cleanly with all settings restored |

## Notes

- Requires AutoCAD 2020+ (vanilla; no Civil 3D dependencies)
- Built for 2D transportation PS&E work — signage and striping plan production
- OSMODE and CMDECHO are suppressed/forced during execution and restored on exit, including on error
- Requires both an origin and an X-axis point; otherwise cancels

## About

AutoLISP top-locked custom UCS tool for AutoCAD — pick origin and X-axis direction, snap to nearest, apply plan view, restore prior zoom.

**Topics:** lisp cad autocad ucs autolisp

## License

MIT license
