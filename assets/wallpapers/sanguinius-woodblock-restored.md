# Restored wallpaper provenance

Final: `sanguinius-woodblock-restored.png`, opaque RGB PNG, 3840×2160.
Source: `sanguinius-woodblock-clean-generated.png`, 1672×941; its built-in
imagegen prompt is preserved in `sanguinius-woodblock-clean.prompt.txt`.

Processed on 2026-10-02 using the user's existing authorization for local
upscaling. Tool: Real-ESRGAN ncnn Vulkan 0.2.0 from the repository's locked
nixpkgs input, model `realesrgan-x4plus-anime`. The AI output is 6688×3764.
The final PNG is downsampled to 3840×2160 with Pillow Lanczos. This is AI
super-resolution, not native 4K generation or recovery of original details.
Some print texture is simplified; emblem shape and placement are preserved.

Build the tool without installing it into the desktop environment:

```sh
nix build --impure --expr 'let f = builtins.getFlake "path:/home/sheke/.config/nix-config"; in f.inputs.nixpkgs.legacyPackages.x86_64-linux.realesrgan-ncnn-vulkan' --out-link /tmp/sanguinius-realesrgan
/tmp/sanguinius-realesrgan/bin/realesrgan-ncnn-vulkan \
  -i /home/sheke/.config/nix-config/assets/wallpapers/sanguinius-woodblock-clean-generated.png \
  -o /tmp/sanguinius-woodblock-ai-4x.png \
  -m /tmp/sanguinius-realesrgan/share/models \
  -n realesrgan-x4plus-anime -s 4 -t 256 -j 1:1:1
```

Using a Python interpreter with Pillow:

```python
from PIL import Image
im = Image.open('/tmp/sanguinius-woodblock-ai-4x.png').convert('RGB')
im.resize((3840, 2160), Image.Resampling.LANCZOS).save(
    '/home/sheke/.config/nix-config/assets/wallpapers/sanguinius-woodblock-restored.png'
)
```

Verified the full image, native desktop-size detail crops, and the 16:10 fill
crop. Both prior wallpaper versions and the original motif remain preserved.
Applied live through DMS's `wallpaper set` IPC and referenced by Stylix.

Upstream tool and model information:
https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan
