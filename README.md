# My Little Farm

Little project to explore Godot 4.

## Current State

![Screenshot of the current state of the project.](progress_documentation/2022-10-01/01.png?raw=true)



## With the help of

- [Age of Asparagus](https://www.youtube.com/c/AgeOfAsparagus)
  - [Make a 3D Top Down Shooter with Godot - Part 1. Character Controller](https://www.youtube.com/watch?v=HX6qpYjwN3M)
  - [Make a 3D Top Down Shooter with Godot - Part 1.2 Gun System](https://www.youtube.com/watch?v=mDYaJa6txwc)
  - [Make a 3D Top Down Shooter with Godot - Part 1.3 Enemy Pathfinding](https://www.youtube.com/watch?v=jcO9E7ZS4Eg)
    - I had some trouble setting up path finding as it works quite different in Godot 4. Once you've figured it out, it's actually much more straigt forward. Here is an article outlining what needs to be done: [Navigation Server for Godot 4.0](https://godotengine.org/article/navigation-server-godot-4-0). Also, big shoutout to [warriormaster](https://www.reddit.com/user/warriormaster/) on Reddit who patiently helped me debug this.
  - [Make a 3D Top Down Shooter with Godot - Part 1.4 Killing Enemies](https://www.youtube.com/watch?v=kewj-_5URnI)
    - Pretty straight forward, the `signal` didn't show up in the UI at first but eventually the parser caught up. When editing the material, the Flags section is gone. To get to the "World Triplanar", it's right in the UV1 section.
  - [Make a 3D Top Down Shooter with Godot - Part 1.5 Spawning Waves](https://www.youtube.com/watch?v=e7XyaROA4cM)
    - Only issue was the syntax change for connecting signals, which is less stringly now and could even take a closure: `stats.connect("you_died_signal", self._on_enemy_stats_you_died_signal)`
  - [Make a 3D Top Down Shooter with Godot - Part 1.6 Enemy Attacks](https://www.youtube.com/watch?v=JZs9PZNfGqs)
    - Minor hickups due to renamed methods in Godot (e.g. `set_surface_material` -> `set_surface_override_material`)
  - [Make a 3D Top Down Shooter with Godot - Part 1.7 Player Death](https://www.youtube.com/watch?v=a2J_9fco7xE)
  - [Make a 3D Top Down Shooter with Godot - Part 1.8 Loose Ends](https://www.youtube.com/watch?v=XUu9o8ddCZw)
  - [Make a 3D Top Down Shooter with Godot - Part 2.1 A Basic Level Generation Tool](https://www.youtube.com/watch?v=WjThx-Bdn5g)
    - I had to make a few tweaks to my materials and basic ground and obstacle shapes to get the same results as AoA.
  - [Make a 3D Top Down Shooter with Godot - Part 2.2 Randomization](https://www.youtube.com/watch?v=TIWUUgmc3nQ)
  - [Make a 3D Top Down Shooter with Godot - Part 2.3 Color Variations](https://www.youtube.com/watch?v=6uWM7tywBVU) + [Godot Spatial Shaders - A Gentle Introduction](https://www.youtube.com/watch?v=edITKOiqpHE)
    - Bumped in to a few renames:
      - `SpatialMaterial` is now `StandardMaterial3D`
      - `linear_interpolate` is `lerp`
      - In the shader the `world` is now called `model_matrix`
      - Also `set_shader_param` is now `set_shader_parameter`
  - [Make a 3D Top Down Shooter with Godot - Part 2.7 Loose Ends](https://www.youtube.com/watch?v=ht_G3e-NgmM)
    - I could not follow this refactor ?????? Godot could not resolve types anymore, would not understand the type hints, etc.

- When looking up changes from Godot 3.* to 4, I found [this script](https://gist.github.com/aaronfranke/79b424226475d277d0035b7835b09c5f) by [aaronfranke](https://github.com/aaronfranke) extremely helpful.
