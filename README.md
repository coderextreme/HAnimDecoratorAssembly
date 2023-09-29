# HAnimDecoratorAssembly

The main thing this provides is a way to add skin coordinate information (weights and indexes) and skeletons to X3D files exported from Blender, via additions in glTF.  view3dscene has on their workplate to provide skeletons and skin coord information in X3DV, but we don't know when.  I am also working on extracting weights and indexes and skeleton directly with Blender Python.  

Reaching beta status.  Note that translations, rotations and scales are removed from humanoid.

Combine glTF and X3D exports from Blender, along with other sources.

# Required inputs (Provided by you), documentation pending.

./lily_73/blenderLily_notransrotbox.gltf (as exported by Blender, be sure to include normals)
./lily_73/blenderLily_notransrotbox.x3dv (as exported by Blender, be sure to include normals)

"./InputDir73/7_3 joint location.txt"
./InputDir73/7_3_WEIGHTS.txt

Note that the first model I worked with there were "patchups" required to the .x3dv file at the last step.  One is introduced, Shape, I think, the others are because the X3D and glTF have different DEF values for Coordinate and Normal.  See patchup*.pl


The main program is convertLily.sh or convertGramps.sh

Here's the basic workflow now, very simple.  I'm open to name changes now.  You may toggle validation between 0 and 1, which will improve performance if validation is disabled.

Blender export scripts are provided as a convenience.  Also, the experimental HAnim Blender export plugin is included as a zip.  Install from Blender GUI.

< means reading from file after.
> means writing to file after
${PREFIX} is a folder plus file prefix.

I'll be looking at bringing over animations pretty soon.

Workflow description

# set up variables

export WORKDIR=lily_73
export PREFIX="`pwd`/${WORKDIR}"/lily_73
export GLTFINPUT="${WORKDIR}"/blenderLily_notransrotbox.gltf
export X3DINPUT="${WORKDIR}"/blenderLily_notransrotbox.x3dv
mkdir -p "${WORKDIR}"
export VIEW3DSCENE=~/Downloads/view3dscene-4.3.0-win64-x86_64/view3dscene/
export X3DTIDY=x3d-tidy@latest
export TOVRMLX3D="${VIEW3DSCENE}"tovrmlx3d.exe
export PROCESSDIR=ProcessDir73
export INPUTDIR=InputDir73
export VALIDATE=1

# convert glTF input to X3DV
"${TOVRMLX3D}" --encoding classic ${GLTFINPUT} > "${PREFIX}".gltfmichalis.x3dv 

# convert X3DV input to X3DV
"${TOVRMLX3D}" --encoding classic ${X3DINPUT} > "${PREFIX}".x3dmichalis.x3dv 

# Add Toddler to DEFs

perl toddlerHRE.pl Toddler_ "${PREFIX}".gltfmichalis.x3dv < "${PREFIX}".gltfmichalis.x3dv > "${PREFIX}"toddlerized1.x3dv

# convert Transforms to HAnim nodes, add names to HAnim nodes.
perl haveTransformDEFaddName.pl < "${PREFIX}"toddlerized1.x3dv > "${PREFIX}"named.x3dv


# remove EXPORTS, rename sacroiliac

perl presweep.pl < "${PREFIX}"named.x3dv > "${PREFIX}"swept.x3dv

# add centers from joint location file (possibly pull from Blender?)
perl Newcenters.pl "${INPUTDIR}/7_3 joint location.txt" "${PREFIX}"swept.x3dv < "${PREFIX}"swept.x3dv > "${PREFIX}"centered.x3dv

# add skinCoord* info to HAnimJoints from weights file.
perl haveSkeletonAddSkinCoord.pl "${INPUTDIR}/7_3_WEIGHTS.txt" <  "${PREFIX}"centered.x3dv > "${PREFIX}"revised.x3dv

# move Skin to correct place
perl moveSkin.pl "${PREFIX}"revised.x3dv < "${PREFIX}"revised.x3dv > "${PREFIX}"skinplaced.x3dv

# move skin from X3DV export (michalis copy) to current workflow file, skinplaced

perl replaceSkin.pl  "${PREFIX}".x3dmichalis.x3dv "${PREFIX}"skinplaced.x3dv > "${PREFIX}"skinned.x3dv

# add skin image

perl haveAppearanceAddImage.pl < ${PREFIX}skinned.x3dv > "${PREFIX}"imaged.x3dv

# use names for Blender exported animations

perl patchupLily.pl < "${PREFIX}"imaged.x3dv > "${PREFIX}"final.x3dv

# appened animations from old workflow

cat < "${PREFIX}animations.txt" >> "${PREFIX}"final.x3dv

# view the 3D model
"${VIEW3DSCENE}"view3dscene.exe "${PREFIX}"final.x3dv
