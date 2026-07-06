shot: {
    .top: {
        jsr shot_moveall
        jsr shot_cullall
        jsr shot_drawall
        
        rtl
    }
    
    .draw: {
        ;just wrote, not debrugged yet
        
        ;arguments:
        ;x = shot index
        
        ;used in routine:
        ;p_0 = x position on screen
        ;p_2 = y position on screen
        ;p_4 = number of sprites in spritemap to draw
        
        phb
        phx
        phy
        
        phk
        plb
        
        lda w_shot_x,x
        sec
        sbc w_level_camerax
        sta p_0                     ;x position on screen
        
        lda w_shot_y,x
        sec
        sbc w_level_cameray
        sta p_2                     ;y position on screen
        
        lda w_shot_spritemap_ptr,x
        tay                         ;y = spritemap pointer
        
        ldx w_oam_index
        
        pea.w bank(shot)<<8         ;just in case we put spritemaps elsewhere
        plb
        plb
        
        lda $0000,y
        sta p_4
        iny
        
        ..nextsprite
        
        sep #$20
        {
            lda $0000,y             ;x pos from spritemap (relative to object)
            clc                         ;signed byte
            adc p_0                 ;onscreen position
            sta.l w_oam_lo_buffer,x
            
            lda $0001,y             ;y pos from spritemap (relative to object)
            clc                         ;signed byte
            adc p_2                 ;onscreen position
            sta.l w_oam_lo_buffer+1,x
            
            lda $0002,y             ;tile index
            sta.l w_oam_lo_buffer+2,x
            
            lda $0003,y             ;flips/properties
            sta.l w_oam_lo_buffer+3,x
            
            ;high table
            
            {
                phx
                
                txa                         ;x/4 (for hi table byte array)
                lsr
                lsr
                tax
                
                lda $0004,y
                sta.l w_oam_hi_bytebuffer,x     ;oam hi buffer
                
                plx
            }
        }
        rep #$20
        
        iny
        iny
        iny
        iny
        iny
        
        inx
        inx
        inx
        inx
        
        dec p_4
        bne ..nextsprite
        
        stx w_oam_index
        
        ply
        plx
        plb
        rts
    }
    
    .cullall: {
        ldx #!shot_count*2
        
        -
        lda w_shot_id,x
        beq +
        jsr shot_cull
        +
        dex
        dex
        bpl -
        
        rts
    }
    
    .cull: {
        ;x = shot index
        ;print pc
        
        lda w_level_camerax
        clc
        adc #$00f0
        cmp w_shot_x,x
        bpl +
        jsr shot_clear
        +
        
        lda w_level_camerax
        cmp w_shot_x,x
        bmi +
        jsr shot_clear
        +
        
        lda w_level_cameray
        clc
        adc #$00f0
        cmp w_shot_y,x
        bpl +
        jsr shot_clear
        +
        
        lda w_level_cameray
        cmp w_shot_y,x
        bmi +
        jsr shot_clear
        +
        
        rts
    }
    
    .drawall: {
        ldx #!shot_count*2
        
        -
        lda w_shot_spritemap_ptr,x
        beq +
        jsr shot_draw
        +
        dex
        dex
        bpl -
        
        rts
    }
    
    .findslot: {
        ldx #!shot_count*2
        
        -
        lda w_shot_id,x
        beq ..slotfound
        dex
        dex
        bpl -
        ;returns x = $fffe if no slot found
        
        ..slotfound:
        ;returns x = available shot index
        rts
    }
    
    .spawntest: {
        phx
        
        jsr shot_findslot
        ;x = shot index
        bmi ..noslotavailable
        
        lda #shot_testspritemap
        sta w_shot_id,x
        
        lda #shot_testspritemap
        sta w_shot_spritemap_ptr,x
        
        lda w_player_x
        sta w_shot_x,x
        
        lda w_player_subx
        sta w_shot_subx,x
        
        lda w_player_y
        sta w_shot_y,x
        
        lda w_player_suby
        sta w_shot_suby,x
        
        lda w_player_xspeed
        asl
        sta w_shot_xspeed,x
        
        lda w_player_xsubspeed
        sta w_shot_xsubspeed,x
        
        lda w_player_yspeed
        asl
        sta w_shot_yspeed,x
        
        lda w_player_ysubspeed
        sta w_shot_ysubspeed,x
        
        ..noslotavailable
        plx
        rtl
    }
    
    .move: {
        ;x = shot index
        
        lda w_shot_subx,x
        clc
        adc w_shot_xsubspeed,x
        sta w_shot_subx,x
        
        lda w_shot_x,x
        adc w_shot_xspeed,x
        sta w_shot_x,x
        
        lda w_shot_suby,x
        clc
        adc w_shot_ysubspeed,x
        sta w_shot_suby,x
        
        lda w_shot_y,x
        adc w_shot_yspeed,x
        sta w_shot_y,x
        
        rts
    }
    
    .moveall: {
        phk
        plb
        
        ldx #!shot_count*2
        
        -
        lda w_shot_id,x
        beq +
        jsr shot_move
        +
        dex
        dex
        bpl -
        
        rts
    }
    
    .testspritemap: {
        db 01
        ;  xx   yy   tt    vhrrpppt   hh 01 = extra x bit, 02 = size select
        db $00, $00, $62, %00111110, $02
    }
    
    .clearall: {
        phk
        plb
        
        ldx #!shot_count*2
        
        -
        jsr shot_clear
        dex
        dex
        bpl -
        
        rtl
    }
    
    .clear: {
        ;x = index
        
        stz w_shot_id,x
        stz w_shot_x,x
        stz w_shot_y,x
        stz w_shot_subx,x
        stz w_shot_suby,x
        stz w_shot_xspeed,x
        stz w_shot_xsubspeed,x
        stz w_shot_yspeed,x
        stz w_shot_ysubspeed,x
        stz w_shot_spritemap_ptr,x
        
        rts
    }
    
    
    
    
}