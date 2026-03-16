;===========================================================================================
;========================================== TEST ===========================================
;=============================== GRAPHICS, TILEMAP, PALETTES ===============================
;===========================================================================================

dw $1234, $1234, $1234, $1234, $1234, $1234, $1234, $1234, $1234

light: {
    print "light data: "
    print "pal ", pc
    .pal:   incbin "./data/pal/light.pal"
    print "gfx ", pc
    .gfx:   incbin "./data/gfx/light.gfx"
    print "map ", pc
    .map:   incbin "./data/map/light.map"
    
    
    .props:
        ;gameplay aspects of this scene
        dw $ffff
}


;light data:
;pal C10012
;gfx C10032
;map C16F92