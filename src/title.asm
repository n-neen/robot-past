title: {
    .main: {
        phk
        plb
        
        lda w_nmicounter
        bit #$000f
        bne +
        
        lda w_menu_state
        asl
        tax
        jsr (title_statetable,x)
        
        +
        stz w_oam_index
        jsr title_drawcursor
        jsl oam_cleanbuffer
        
        rtl
    }
    
    .statetable: {
        dw title_menustartgame,         ;0
           title_menuresumegame,        ;1
           title_menuoptions            ;2
    }
    
    .menustartgame: {
        lda w_controller
        
        bit #!controller_dn
        beq ..nodn
        {
            ;if dn pressed
            pha
            lda #!title_menu_state_resumegame
            sta w_menu_state
            pla
        }
        ..nodn
        
        bit #!controller_a|!controller_st
        beq ..noa
        {
            ;if dn pressed
            pha
            jsr title_startgame
            pla
        }
        ..noa
        
        
        rts
    }
    
    .menuresumegame: {
        lda w_controller
        
        bit #!controller_up
        beq ..noup
        {
            ;if dn pressed
            pha
            lda #!title_menu_state_startgame
            sta w_menu_state
            pla
        }
        ..noup
        
        bit #!controller_dn
        beq ..nodn
        {
            ;if dn pressed
            pha
            lda #!title_menu_state_options
            sta w_menu_state
            pla
        }
        ..nodn
        
        bit #!controller_a|!controller_st
        beq ..noa
        {
            ;if dn pressed
            pha
            jsr title_resumegame
            pla
        }
        ..noa
        
        
        rts
    }
    
    .resumegame: {
        jsl setupresumedgame
        
        rts
    }
    
    .menuoptions: {
        lda w_controller
        bit #!controller_up
        beq ..noup
        {
            ;if up pressed
            pha
            lda #!title_menu_state_resumegame
            sta w_menu_state
            pla
        }
        ..noup
        
        bit #!controller_a|!controller_st
        beq ..noa
        {
            ;if dn pressed
            pha
            ;do options menu eventually
            ;jsr title_options
            pla
        }
        ..noa
        
        
        rts
    }
    
    
    .startgame: {
        lda #!state_introsetup
        sta w_programstate
        
        lda #!fade_bitmask_default
        sta w_fadebitmask
        
        jsl fadeout_long
        jsl msg_reset
        
        rts
    }
    
    
    .drawcursor: {
        phb
        phx
        phy
        
        phk
        plb
        
        lda w_menu_state
        asl
        asl
        tax
        
        lda title_cursorpositions,x         ;x position
        sta p_4
        
        lda title_cursorpositions+2,x       ;y position
        sta p_2
        
        ldy w_oam_index
        ldx #title_cursorspritemap
        
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
        
        ply
        plx
        plb
        rts
        
        ..long: {
            jsr title_drawcursor
            rtl
        }
    }
    
    .cursorpositions: {
            ;x,     y
        dw $0030,   $0098       ;position when on "start game"
        dw $0030,   $00ae       ;position when on "resume game"
        dw $0030,   $00c4       ;position when on "options"
    }
    
    .cursorspritemap: {
        db 01
        ;  xx   yy   tt    vhrrpppt   hh 01 = extra x bit, 02 = size select
        db $00, $00, $00, %01110010, $00
    }
}