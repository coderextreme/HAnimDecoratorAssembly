# HAnimDecoratorAssembly

Under development.  Has been tested on 1 .FBX.  People wanting to convert FBX to X3DV are welcome to contact me, leave anote in issues, etc.

Combine glTF and X3D exports from Blender, along with other sources.

# Required inputs (Provided by you), documentation pending.

lily_73/lily_73.gltf (as exported by Blender)
lily_73/lily_73.x3d (as exported by Blender)

./InputDir73/7_3 joint location.txt
./InputDir73/7_3_WEIGHTS.txt

Note that the first model I worked with there were "patchups" required to the .x3dv file at the last step.  One is introduced, Shape, I think, the others are because the X3D and glTF have different DEF values for Coordinate and Normal.  See patchup.pl


The main program is convertBlenderOutput.sh

Here's the basic workflow now, very simple.  I'm open to name changes now.  You may comment out validation, which will improve performance.

< means reading from file after.
> means writing to file after
${PREFIX} is a folder plus file prefix.

I'll be looking at bringing over animations pretty soon.

# prepare for renaming and changing node types
perl moveupchildren.pl < "${PREFIX}".gltfsource.x3dv > "${PREFIX}"notranschild.x3dv

# add names and change node types
perl haveTransformDEFaddName.pl < "${PREFIX}"notranschild.x3dv > "${PREFIX}"named.x3dv

# add joints field
perl replacejoints.pl < "${PREFIX}"named.x3dv > "${PREFIX}"jointed.x3dv

# replace scale
perl replacescale.pl < "${PREFIX}"jointed.x3dv > "${PREFIX}"scaled.x3dv

# add/replace joint centers
perl Newcenters.pl "${INPUTDIR}/7_3 joint location.txt" < "${PREFIX}"scaled.x3dv > "${PREFIX}"centered.x3dv
# add skin coord info
perl haveSkeletonAddSkinCoord.pl "${INPUTDIR}/7_3_WEIGHTS.txt" <  "${PREFIX}"centered.x3dv > "${PREFIX}"revised.x3dv

# move IndexedSet shape to skin
perl haveIFSmoveToSkin.pl < "${PREFIX}"revised.x3dv > "${PREFIX}"skinplaced.x3dv

# replace skin in glTF export with one from X3D export
perl replaceSkin.pl  "${PREFIX}".x3dsource.x3dv "${PREFIX}"skinplaced.x3dv > "${PREFIX}"skinned.x3dv

# add image texture
perl haveAppearanceAddImage.pl < ${PREFIX}skinned.x3dv > "${PREFIX}"final.x3dv

