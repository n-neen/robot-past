;top level label is "fae"


.test: {
    dw ..main
    dw ..touch
    dw ..init
    dw ..spritemap
    
    dw $001e    ;x size
    dw $001e    ;y size
    
    ..main: {
        ;runs once per frame
        
        ;move fae with controller 2
        
        lda w_controller2
        bit #!controller_lf
        beq +
        {
            ;if lf pressed
            pha
            lda w_fae_x,x
            sec
            sbc w_fae_var1,x
            sta w_fae_x,x
            pla
        }
        +
        
        bit #!controller_rt
        beq +
        {
            ;if rt pressed
            pha
            lda w_fae_x,x
            clc
            adc w_fae_var1,x
            sta w_fae_x,x
            pla
        }
        +
        
        bit #!controller_up
        beq +
        {
            ;if up pressed
            pha
            lda w_fae_y,x
            sec
            sbc w_fae_var1,x
            sta w_fae_y,x
            pla
        }
        +
        
        bit #!controller_dn
        beq +
        {
            ;if dn pressed
            pha
            lda w_fae_y,x
            clc
            adc w_fae_var1,x
            sta w_fae_y,x
            pla
        }
        +
        
        rts
    }
    
    ..init: {
        ;lda #$0080
        ;sta w_fae_x,x
        
        ;lda #$0180
        ;sta w_fae_y,x
        rts
    }
    
    ..touch: {
        
        lda w_player_yspeed
        eor #$ffff
        inc
        sta w_player_yspeed
        
        lda w_player_xspeed
        eor #$ffff
        inc
        sta w_player_xspeed
        
        rts
    }
    
    ..spritemap: {
        ;number of sprites
        db 09
        ;  xx   yy   tt   pp         hh 01 = extra x bit, 02 = size select
        db $f0, $f0, $6a, %00111101, $02
        db $00, $f0, $6c, %00111101, $02
        db $10, $f0, $6e, %00111101, $02
        
        db $f0, $00, $8a, %00111101, $02
        db $00, $00, $8c, %00111101, $02
        db $10, $00, $8e, %00111101, $02
        
        db $f0, $10, $aa, %00111101, $02
        db $00, $10, $ac, %00111101, $02
        db $10, $10, $ae, %00111101, $02

    }
}