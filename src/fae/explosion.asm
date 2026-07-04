;top level label is "fae"

;ram reference

;w_fae_id
;w_fae_x
;w_fae_subx
;w_fae_y
;w_fae_suby
;w_fae_spritemapptr
;w_fae_touchptr
;w_fae_mainptr
;w_fae_initptr
;w_fae_xsize
;w_fae_ysize
;w_fae_var1
;w_fae_var2
;w_fae_var3

.explosion: {
    dw ..main
    dw ..touch
    dw ..init
    dw ..spritemap
    dw $0030    ;x size
    dw $0030    ;y size
    
    ..main: {
        ;runs once per frame
        ;x = fae index
        ;w_fae_var1 = timer
        ;w_fae_var2 = spritemap index
        
        ;var1 is set to count down before we get here
        
        lda w_nmicounter
        bit #$0007
        bne +
        
        lda w_fae_var1,x
        dec
        sta w_fae_var1,x
        bpl ++
        
        jsr fae_clear
        bra +
        
        ++
        
        asl
        tay
        
        lda fae_explosion_spritemaplist,y
        sta w_fae_spritemapptr,x
        
        +
        
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
    
    ..spritemaplist: {
        dw fae_explosion_spritemap_0
        dw fae_explosion_spritemap_1
        dw fae_explosion_spritemap_2
        dw fae_explosion_spritemap_3
        dw fae_explosion_spritemap_4
        dw fae_explosion_spritemap_5
    }
    
    ..spritemap: {
        ...0
            db 01
            ;  xx   yy   tt    vhrrpppt   hh 01 = extra x bit, 02 = size select
            db $00, $00, $a0, %00111110, $02
        ...1
            db 01
            ;  xx   yy   tt    vhrrpppt   hh 01 = extra x bit, 02 = size select
            db $00, $00, $a2, %00111100, $02
        ...2
            db 01
            ;  xx   yy   tt    vhrrpppt   hh 01 = extra x bit, 02 = size select
            db $00, $00, $a4, %00111110, $02
        ...3
            db 01
            ;  xx   yy   tt    vhrrpppt   hh 01 = extra x bit, 02 = size select
            db $00, $00, $a6, %00111100, $02
        ...4
            db 01
            ;  xx   yy   tt    vhrrpppt   hh 01 = extra x bit, 02 = size select
            db $00, $00, $a8, %00111110, $02
        ...5
            db 01
            ;  xx   yy   tt    vhrrpppt   hh 01 = extra x bit, 02 = size select
            db $00, $00, $aa, %00111100, $02
    }
}