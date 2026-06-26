;top level label is "fae"


.test: {
    dw ..main
    dw ..touch
    dw ..init
    dw ..spritemap
    
    dw $0030    ;x size
    dw $0030    ;y size
    
    ..main: {
        ;runs once per frame
        
        ;move fae with controller 2
        
        lda w_controller2
        bit #!controller_lf
        beq +
        {
            ;if lf pressed
            dec w_fae_x,x
        }
        +
        
        bit #!controller_rt
        beq +
        {
            ;if rt pressed
            inc w_fae_x,x
        }
        +
        
        bit #!controller_up
        beq +
        {
            ;if up pressed
            dec w_fae_y,x
        }
        +
        
        bit #!controller_dn
        beq +
        {
            ;if dn pressed
            inc w_fae_y,x
        }
        +
        
        rts
    }
    
    ..init: {
        lda #$0080
        sta w_fae_x,x
        
        lda #$0180
        sta w_fae_y,x
        rts
    }
    
    ..touch: {
        ;runs when collision is detected
        rts
    }
    
    ..spritemap: {
        ;number of sprites
        db 36
        ;  xx   yy   tt   pp         hh 01 = extra x bit, 02 = size select
        db $00, $00, $6a, %00111101, $00
        db $08, $00, $6b, %00111101, $00
        db $10, $00, $6c, %00111101, $00
        db $18, $00, $6d, %00111101, $00
        db $20, $00, $6e, %00111101, $00
        db $28, $00, $6f, %00111101, $00
        
        db $00, $08, $7a, %00111101, $00
        db $08, $08, $7b, %00111101, $00
        db $10, $08, $7c, %00111101, $00
        db $18, $08, $7d, %00111101, $00
        db $20, $08, $7e, %00111101, $00
        db $28, $08, $7f, %00111101, $00
        
        db $00, $10, $8a, %00111101, $00
        db $08, $10, $8b, %00111101, $00
        db $10, $10, $8c, %00111101, $00
        db $18, $10, $8d, %00111101, $00
        db $20, $10, $8e, %00111101, $00
        db $28, $10, $8f, %00111101, $00
        
        db $00, $18, $9a, %00111101, $00
        db $08, $18, $9b, %00111101, $00
        db $10, $18, $9c, %00111101, $00
        db $18, $18, $9d, %00111101, $00
        db $20, $18, $9e, %00111101, $00
        db $28, $18, $9f, %00111101, $00
        
        db $00, $20, $aa, %00111101, $00
        db $08, $20, $ab, %00111101, $00
        db $10, $20, $ac, %00111101, $00
        db $18, $20, $ad, %00111101, $00
        db $20, $20, $ae, %00111101, $00
        db $28, $20, $af, %00111101, $00
        
        db $00, $28, $ba, %00111101, $00
        db $08, $28, $bb, %00111101, $00
        db $10, $28, $bc, %00111101, $00
        db $18, $28, $bd, %00111101, $00
        db $20, $28, $be, %00111101, $00
        db $28, $28, $bf, %00111101, $00
    }
}