#!/bin/bash
set -uo pipefail
IFS=$'\n\t'
export WORKDIR=gramps73
export PREFIX="`pwd`/${WORKDIR}"/gramps
# export GLTFINPUT=${PREFIX}_c4d_omni.gltf
export GLTFINPUT=${PREFIX}_dae_blender.gltf
#export X3DINPUT=${PREFIX}_from_dae.x3d
export X3DINPUT=${PREFIX}_dae_blender.x3dv
mkdir -p "${WORKDIR}"
export VIEW3DSCENE=~/Downloads/view3dscene-4.3.0-win64-x86_64/view3dscene/
export X3DTIDY=x3d-tidy@latest
export TOVRMLX3D="${VIEW3DSCENE}"tovrmlx3d.exe
export PROCESSDIR=ProcessDir73
mkdir -p "${PROCESSDIR}"
export INPUTDIR=InputDir73
export VALIDATE=0

echo "The main inputs are ${GLTFINPUT} and ${X3DINPUT} as exported from Blender, there are other inputs, not documented yet"
#echo "npx ${X3DTIDY} -i ${GLTFINPUT} -o ${PREFIX}.gltfholger.x3dv"
#npx ${X3DTIDY} -i ${GLTFINPUT} -o "${PREFIX}.gltfholger.x3dv"
#echo "${TOVRMLX3D} --validate ${PREFIX}.gltfholger.x3dv"
#if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}".gltfholger.x3dv; else echo "Validate disabled"; fi

echo "${TOVRMLX3D} --encoding classic ${GLTFINPUT} > ${PREFIX}.gltfmichalis.x3dv"
#"${TOVRMLX3D}" --encoding classic ${GLTFINPUT} > "${PREFIX}".gltfmichalis.x3dv 
echo "${TOVRMLX3D} --validate ${PREFIX}.gltfmichalis.x3dv"
if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}".gltfmichalis.x3dv; else echo "Validate disabled"; fi

#echo "npx ${X3DTIDY} -i "${X3DINPUT}" -o ${PREFIX}.x3dholger.x3dv"
#npx ${X3DTIDY} -i "${X3DINPUT}" -o "${PREFIX}.x3dholger.x3dv"
#echo "${TOVRMLX3D} --validate ${PREFIX}.x3dholger.x3dv"
#if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}".x3dholger.x3dv; else echo "Validate disabled"; fi

echo "${TOVRMLX3D} --encoding classic ${X3DINPUT} > ${PREFIX}.x3dmichalis.x3dv"
#"${TOVRMLX3D}" --encoding classic ${X3DINPUT} > "${PREFIX}".x3dmichalis.x3dv 
echo "${TOVRMLX3D} --validate ${PREFIX}.x3dmichalis.x3dv"
if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}".x3dmichalis.x3dv; else echo "Validate disabled"; fi

#echo "perl toddlerHRE.pl Gramps_ < ${PREFIX}.gltfholger.x3dv > ${PREFIX}toddlerized1.x3dv"
#perl toddlerHRE.pl Gramps_ < ${PREFIX}.gltfholger.x3dv > "${PREFIX}"toddlerized1.x3dv
#echo "${TOVRMLX3D} --validate ${PREFIX}toddlerized1.x3dv"
#if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"toddlerized1.x3dv; else echo "Validate disabled"; fi

echo "perl toddlerHRE.pl Gramps_ ${PREFIX}.gltfmichalis.x3dv < ${PREFIX}.gltfmichalis.x3dv > ${PREFIX}toddlerized1.x3dv"
perl toddlerHRE.pl Gramps_ "${PREFIX}".gltfmichalis.x3dv < "${PREFIX}".gltfmichalis.x3dv > "${PREFIX}"toddlerized1.x3dv
echo "${TOVRMLX3D} --validate ${PREFIX}toddlerized1.x3dv"
if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"toddlerized1.x3dv; else echo "Validate disabled"; fi

echo "perl haveTransformDEFaddName.pl < "${PREFIX}"toddlerized1.x3dv > "${PREFIX}"named.x3dv"
perl haveTransformDEFaddName.pl < "${PREFIX}"toddlerized1.x3dv > "${PREFIX}"named.x3dv
echo "${TOVRMLX3D} --validate ${PREFIX}named.x3dv"
if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"named.x3dv; else echo "Validate disabled"; fi

echo "perl presweep.pl < "${PREFIX}"named.x3dv > "${PREFIX}"swept.x3dv"
perl presweep.pl < "${PREFIX}"named.x3dv > "${PREFIX}"swept.x3dv
echo "${TOVRMLX3D} --validate ${PREFIX}swept.x3dv"
if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"swept.x3dv; else echo "Validate disabled"; fi

echo "perl reformatCenters.pl < ${INPUTDIR}/JointCenterCheck.txt > ${PROCESSDIR}/gramps_joint_location.txt"
perl reformatCenters.pl < "${INPUTDIR}"/JointCenterCheck.txt > "${PROCESSDIR}"/gramps_joint_location.txt

echo "perl Newcenters.pl "${PROCESSDIR}"/gramps_joint_location.txt < ${PREFIX}swept.x3dv > ${PREFIX}centered.x3dv"
perl Newcenters.pl "${PROCESSDIR}"/gramps_joint_location.txt "${PREFIX}"swept.x3dv < "${PREFIX}"swept.x3dv > "${PREFIX}"centered.x3dv
echo "${TOVRMLX3D} --validate ${PREFIX}centered.x3dv"
if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"centered.x3dv; else echo "Validate disabled"; fi


echo "perl haveSkeletonAddSkinCoord.pl ${INPUTDIR}/GRAMPS_WIEGHTS.txt <  "${PREFIX}"centered.x3dv > "${PREFIX}"revised.x3dv"
perl haveSkeletonAddSkinCoord.pl "${INPUTDIR}/GRAMPS_WIEGHTS.txt" <  "${PREFIX}"centered.x3dv > "${PREFIX}"revised.x3dv
#echo "perl haveSkeletonAddSkinCoord.pl ${INPUTDIR}/7_3_WEIGHTS.txt <  "${PREFIX}"centered.x3dv > "${PREFIX}"revised.x3dv"
#perl haveSkeletonAddSkinCoord.pl "${INPUTDIR}/7_3_WEIGHTS.txt" <  "${PREFIX}"centered.x3dv > "${PREFIX}"revised.x3dv
#echo "perl haveSkeletonAddSkinCoord.pl ${WORKDIR}/LILY_7_3_1_john.txt <  "${PREFIX}"centered.x3dv > "${PREFIX}"revised.x3dv"
#perl haveSkeletonAddSkinCoord.pl "${WORKDIR}/LILY_7_3_1_john.txt" <  "${PREFIX}"centered.x3dv > "${PREFIX}"revised.x3dv
echo "${TOVRMLX3D} --validate ${PREFIX}revised.x3dv"
if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"revised.x3dv; else echo "Validate disabled"; fi


#tail +2 "${INPUTDIR}/lily_7_3_points.txt" | sed -e 's/root //' |
#	sed -e 's/^(/0\t/' |
#	sed -e 's/)//g' |
#	sed -e 's/\r//g' |
#	sed -e 's/, /\t/g' |
#	sed -e 's/  / /g' |
#	sed -e 's/[ \t][ \t][ \t]*/\t/g' |
#	sed -e "s/^\([-0-9\.][0-9\.]*\)\t/print(\1);\t/" |
#	sed -e "s/\t\([-0-9e\.][-0-9e\.]*\) \xB5m/\tprint(\1*0.000001);/g" |
#	sed -e "s/\t\([-0-9e\.][-0-9e\.]*\) µm/\tprint(\1*0.000001);/g" |
#	sed -e "s/\t\([-0-9e\.][-0-9e\.]*\) mm/\tprint(\1*0.001);/g" |
#	sed -e "s/\t\([-0-9e\.][-0-9e\.]*\) cm/\tprint(\1*0.01);/g" |
#	sed -e "s/\t\([-0-9e\.][-0-9e\.]*\) m/\tprint(\1*1.0);/g" |
#	sed -e "s/\t\([-0-9e\.][-0-9e\.]*\)/\tprint(\1);/g" |
#	sed -e "s/^\(print([0-9][0-9]*);\tprint\)\(([^)][^)]*)\)\(;\tprint\)\(([^)][^)]*)\)\(;\tprint\)\(([^)][^)]*)\)\(.*\)/\1(\2)\3(\4)\5(\6)\7/" |
#	sed -e 's/\t/print("\\t");\t/g' |
#	sed -e 's/$/print("\\n");\t/g' |
#	sed -e 's/[<>`|]//g' |
#	perl |
#	sed -e 's/\r$//' -e 's/^[0-9][0-9]*\t//' -e 's/\t$//' | tr '\t' ' ' > "$PROCESSDIR"/points.txt
#
#tail +2 "${INPUTDIR}/lily_7_3_polygon.txt" | sed -e 's/\r//g' -e 's/\t$//' -e 's/[^\t]*\t\([-0-9]*\)\t\([-0-9]*\)\t\([-0-9]*\)$/\1 \2 \3 -1/' > "${PROCESSDIR}"/triangles.txt
#
#tail +2 "${INPUTDIR}/lily_6_1_UVW.txt" | sed -n -e 's/^\([0-9][0-9]*\)\t\([0-9\.][0-9\.]*\)\t\([0-9\.][0-9\.]*\)\t\([0-9\.][0-9\.]*\)\t\([0-9\.][0-9\.]*\)\t\([0-9\.][0-9\.]*\)\t\([0-9\.][0-9\.]*\)\t\([0-9\.][0-9\.]*\)\t\([0-9\.][0-9\.]*\)\t\([0-9\.][0-9\.]*\)\t/\1 \2 \3 \5 \6 \8 \9/p' > "${PROCESSDIR}"/textures.txt
#
#echo "perl replacepointsvertices.pl ${PREFIX}revised.x3dv ${PREFIX}pav.x3dv ${PROCESSDIR}/points.txt  ${PROCESSDIR}/triangles.txt ${PROCESSDIR}/textures.txt"
#perl replacepointsvertices.pl "${PREFIX}"revised.x3dv "${PREFIX}"pav.x3dv "${PROCESSDIR}"/points.txt  "${PROCESSDIR}"/triangles.txt "${PROCESSDIR}"/textures.txt
#echo "${TOVRMLX3D} --validate ${PREFIX}pav.x3dv"
#if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"pav.x3dv; else echo "Validate disabled"; fi

#echo "perl replaceSkinHolger.pl  ${PREFIX}.x3dholger.x3dv ${PREFIX}revised.x3dv > ${PREFIX}skinned.x3dv"
#perl replaceSkinHolger.pl  "${PREFIX}".x3dholger.x3dv "${PREFIX}"revised.x3dv > "${PREFIX}"skinned.x3dv
#echo "${TOVRMLX3D} --validate ${PREFIX}skinned.x3dv"
#if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"skinned.x3dv; else echo "Validate disabled"; fi

#echo "perl replaceSkinHolger.pl  ${PREFIX}.x3dmichalis.x3dv ${PREFIX}revised.x3dv > ${PREFIX}skinned.x3dv"
#perl replaceSkinHolger.pl  "${PREFIX}".x3dmichalis.x3dv "${PREFIX}"revised.x3dv > "${PREFIX}"skinned.x3dv
#echo "${TOVRMLX3D} --validate ${PREFIX}skinned.x3dv"
#if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"skinned.x3dv; else echo "Validate disabled"; fi

echo "perl moveSkin.pl ${PREFIX}revised.x3dv < ${PREFIX}revised.x3dv > ${PREFIX}skinplaced.x3dv"
perl moveSkin.pl "${PREFIX}"revised.x3dv < "${PREFIX}"revised.x3dv > "${PREFIX}"skinplaced.x3dv
echo "${TOVRMLX3D} --validate ${PREFIX}skinplaced.x3dv"
if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"skinplaced.x3dv; else echo "Validate disabled"; fi


echo "perl replaceSkin.pl  ${PREFIX}.x3dmichalis.x3dv ${PREFIX}skinplaced.x3dv > ${PREFIX}skinned.x3dv"
perl replaceSkin.pl  "${PREFIX}".x3dmichalis.x3dv "${PREFIX}"skinplaced.x3dv > "${PREFIX}"skinned.x3dv
echo "${TOVRMLX3D} --validate ${PREFIX}skinned.x3dv"
if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"skinned.x3dv; else echo "Validate disabled"; fi

echo "perl haveAppearanceAddImage.pl < ${PREFIX}skinned.x3dv > ${PREFIX}imaged.x3dv"
perl haveAppearanceAddImage.pl < ${PREFIX}skinned.x3dv > "${PREFIX}"imaged.x3dv
echo "${TOVRMLX3D} --validate ${PREFIX}imaged.x3dv"
if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"imaged.x3dv; else echo "Validate disabled"; fi


echo "perl patchupGramps.pl < ${PREFIX}imaged.x3dv > ${PREFIX}final.x3dv"
perl patchupGramps.pl < "${PREFIX}"imaged.x3dv > "${PREFIX}"final.x3dv
echo "${TOVRMLX3D} --validate ${PREFIX}final.x3dv"
if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"final.x3dv; else echo "Validate disabled"; fi

echo "cat < ${PREFIX}animations.txt | sed s/Toddler_//g >> ${PREFIX}final.x3dv"
cat < "${PREFIX}animations.txt" | sed 's/Toddler_//g' >> "${PREFIX}"final.x3dv
echo "${TOVRMLX3D} --validate ${PREFIX}final.x3dv"
if [ $VALIDATE -eq 1 ]; then "${TOVRMLX3D}" --validate "${PREFIX}"final.x3dv; else echo "Validate disabled"; fi

echo "${VIEW3DSCENE}view3dscene.exe ${PREFIX}final.x3dv"
"${VIEW3DSCENE}"view3dscene.exe "${PREFIX}"final.x3dv
