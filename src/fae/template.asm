;top level label is "fae"


.template: {
    dw ..main
    dw ..touch
    dw ..init
    dw ..spritemap
    
    
    ..main: {
        ;runs once per frame
        rts
    }
    
    ..init: {
        ;runs once when the fae is spawned
        rts
    }
    
    ..touch: {
        ;runs when collision is detected
        rts
    }
    
    ..spritemap: {
        db 0
    }
}