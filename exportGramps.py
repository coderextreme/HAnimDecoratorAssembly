import bpy

# Note: requires X3DV experimental HAnim Blender export addon.

objs = bpy.data.objects
objs.remove(objs["Cube"], do_unlink=True)
#bpy.ops.import_scene.fbx(filepath = "../../Tufani/InputDir73/maya to c4d files/gramps_my_c4d_anim.fbx")
bpy.ops.wm.collada_import(filepath = "gramps73/gramps-ANIM.dae", auto_connect = True, find_chains = True, fix_orientation = True)


#bpy.ops.export_scene.x3dv(filepath="blenderGramps_notransrot.json", export_normals=True, export_format="JSON")
#bpy.ops.export_scene.x3dv(filepath="blenderGramps_notransrot.html", export_normals=True, export_format="HTML")
#bpy.ops.export_scene.x3dv(filepath="blenderGramps_notransrotbox.x3d", export_normals=True, export_format="X3D")
bpy.ops.export_scene.gltf(filepath="gramps73/blenderGramps_notransrotbox.gltf", export_normals=True, export_format="GLTF_EMBEDDED")
bpy.ops.export_scene.x3dv(filepath="gramps73/blenderGramps_notransrotbox.x3dv", export_normals=True, export_format="X3DV")
