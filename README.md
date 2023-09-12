# HAnimDecoratorAssembly

Under development.

Combine glTF and X3D exports from Blender, along with other sources.

# Required inputs (Provided by you), documentation pending.

lily_73/lily_73.gltf (as exported by Blender)
lily_73/lily_73.x3d (as exported by Blender)

./InputDir73/7_3 joint location.txt
./InputDir73/7_3_WEIGHTS.txt

Note that the first model I worked with there were "patchups" required to the .x3dv file at the last step.  One is introduced, Shape, I think, the others are because the X3D and glTF have different DEF values for Coordinate and Normal.  See patchup.pl
