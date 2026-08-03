light: {
    .pal:   incbin "./data/pal/light.pal"
    .gfx:   incbin "./data/gfx/light.gfx"
    .map:   incbin "./data/map/light.map"
    
    
    .props:
        ;gameplay aspects of this scene
        dw $0000
}

agony: {
    .pal:       incbin "./data/pal/agony.pal"
    .gfx:       incbin "./data/gfx/agony.gfx"
    .map:       incbin "./data/map/agony_bg1.map"
    .bg2map:    incbin "./data/map/agony_bg2.map"
    
    .dummylabel:
}

triangle: {
    .pal:       incbin "./data/pal/triangle.pal"
    .gfx:       incbin "./data/gfx/triangle.gfx"
    .map:       incbin "./data/map/triangle.map"
    .bg2map:    incbin "./data/map/triangle_bg2.map"
    .dummylabel:
}