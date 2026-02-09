import random

TargetLayers = gimp.image_list()[0].layers[5].layers[1].layers[1].layers

def RandomizeLayers(layers):
    for i in range(layers):
        Color = (255, 255, 255)
        pdb.gimp_context_set_foreground(Color)
        pdb.gimp_layer_set_lock_alpha(TargetLayers[i], 1)
        pdb.gimp_selection_all(gimp.image_list()[0])
        pdb.gimp_drawable_edit_fill(TargetLayers[i], 0)
        Color = (random.randrange(0, 255), random.randrange(0, 255), random.randrange(0, 255))  # edit last number here for Blue
        # print(Color)
        pdb.gimp_context_set_foreground(Color)
        pdb.gimp_layer_set_lock_alpha(TargetLayers[i], 0)
        pdb.gimp_selection_all(gimp.image_list()[0])
        pdb.gimp_image_select_color(gimp.image_list()[0], 3, TargetLayers[i], (255,255,255))
        pdb.gimp_drawable_edit_fill(TargetLayers[i], 0)

