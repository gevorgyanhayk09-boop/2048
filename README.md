# 2048 — Armenian Edition 🎮

A web-based 2048 puzzle game with an animated tutorial and Armenian voice narration.

## Features

- 🎯 **Classic 2048 gameplay** — combine tiles, reach 2048
- 🎮 **Two difficulty modes** — Easy (4×4 → 2048) / Hard (5×5 → 4096)
- 🎬 **Animated tutorial** — narrated walkthrough showing how to play
- 🇦🇲 **Armenian audio narration** — 38-second walkthrough by a native speaker
- 🌍 **Three UI languages** — English, Russian, Armenian
- 🎨 **Six color themes** — Purple, Ocean, Forest, Sunset, Dark, Gold
- 🔊 **Sound effects** for moves, merges, win, and lose
- 📱 **Touch + keyboard controls** — swipe on phone, arrow keys on desktop

## Files

| File | Purpose |
|---|---|
| `2048_full.html` | **Main game** — single self-contained file with embedded tutorial |
| `audio/narration.m4a` | Armenian voice narration for the animated tutorial |
| `serve.ps1` | Optional: PowerShell static file server for local development |

## Play

### Online
Once published to GitHub Pages, play at:
`https://YOUR-USERNAME.github.io/REPO-NAME/2048_full.html`

### Locally
Just open `2048_full.html` in a browser. For the tutorial audio to load (the modal uses a Blob URL), you may need to serve the file via HTTP:

```powershell
powershell -ExecutionPolicy Bypass -File serve.ps1 -Port 3000
```

Then open http://localhost:3000/2048_full.html

## How to Play

- **Goal:** combine matching tiles until you reach 2048
- **Move tiles:** swipe (touch) or arrow keys (desktop)
- **Merge:** when two tiles with the same number collide, they fuse into one with double the value
- **Win:** reach the 2048 tile
- **Lose:** the board is full and no moves are possible

## Animated Tutorial

Click the **🎬 Watch Animated Tutorial** button on the Tutorial tab to see a narrated walkthrough showing:
1. Game board introduction
2. 2 + 2 = 4 merge
3. 4 + 4 = 8 merge
4. Swipe left / right / up / down
5. Final stage build-up
6. 1024 + 1024 = 2048 victory

## Credits

Made with vanilla HTML/CSS/JavaScript. No frameworks, no build step.
