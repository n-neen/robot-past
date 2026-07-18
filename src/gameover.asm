gameover: {
    .main: {
        ;jsr gameover_debugscroll
        
        ;state machine for which option cursor is on
        ;left and right options
        ;if on left (yes), continue game if affirmative press
        ;if on right (no), end game if affirmative press
        phk
        plb
        
        stz w_oam_index
        
        lda w_menu_state
        asl
        tax
        jsr (gameover_statetable,x)
        
        jsr gameover_drawcursor
        
        jsl oam_cleanbuffer
        rtl
    }
    
    .statetable: {
        dw gameover_leftoption,         ;0
           gameover_rightoption         ;1
    }
    
    .leftoption: {
        ;"Y", affirmative response
        lda w_controller
        bit #!controller_rt
        beq +
        pha
        lda #!gameover_menu_state_right
        sta w_menu_state
        pla
        +
        
        bit #!controller_a
        beq +
        ;continue game somehow
        lda #!state_loadgame
        sta w_programstate
        +
        rts
    }
    
    .rightoption: {
        ;"N", negative response
        lda w_controller
        bit #!controller_lf
        beq +
        {
            pha
            lda #!gameover_menu_state_left
            sta w_menu_state
            pla
        }
        +
        
        bit #!controller_a
        beq +
        ;end game somehow
        jml boot
        +
        
        rts
    }
    
    .drawcursor: {
        lda w_menu_state
        asl
        asl
        tax
        
        lda gameover_cursorpositions,x      ;x position
        sta p_4
        
        lda gameover_cursorpositions+2,x    ;y position
        sta p_2
        
        ldy w_oam_index
        ldx #gameover_cursorspritemap
        
        lda $0000,x
        and #$00ff
        sta p_0             ;number of sprites
        inx
        
        ..nextsprite
        
        sep #$20
        {
            lda $0000,x
            clc
            adc.b p_4
            sta w_oam_lo_buffer,y       ;x
            
            lda $0001,x
            clc
            adc.b p_2
            sta w_oam_lo_buffer+1,y     ;y
            
            lda $0002,x
            sta w_oam_lo_buffer+2,y     ;tile
            
            lda $0003,x
            sta w_oam_lo_buffer+3,y     ;properties
            
        }
        rep #$20
        
        inx
        inx
        inx
        inx
        inx
        
        iny
        iny
        iny
        iny
        
        dec p_0
        bne ..nextsprite
        
        sty w_oam_index
        
        plb
        plx
        ply
        rts
        
        
        
        rts
    }
    
    .cursorpositions: {
            ;x,     y
        dw $003c,   $00b4       ;position when on left option
        dw $0090,   $00b4       ;position when on right option
    }
    
    .debugscroll: {
        lda w_controller
        bit #!controller_rt
        beq +
        inc w_bg2xscroll
        +
        
        lda w_controller
        bit #!controller_lf
        beq +
        dec w_bg2xscroll
        +
        
        lda w_controller
        bit #!controller_up
        beq +
        dec w_bg2yscroll
        +
        
        lda w_controller
        bit #!controller_dn
        beq +
        inc w_bg2yscroll
        +
        
        lda w_controller
        bit #!controller_a
        beq +
        stz w_bg2yscroll
        stz w_bg2xscroll
        +
        
        rts
    }
    
    .cursorspritemap: {
        db 04
        ;  xx   yy   tt    vhrrpppt   hh 01 = extra x bit, 02 = size select
        db $20, $00, $84, %01110000, $00
        db $00, $20, $84, %10110000, $00
        db $00, $00, $84, %00110000, $00
        db $20, $20, $84, %11110000, $00
    }
}