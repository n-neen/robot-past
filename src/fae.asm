fae: {
    .addspritemap: {
        ;adds one spritemap to oam
        ;argument:
        ;p_0 = long pointer to spritemap
        ;x = fae index
        
        ;used inroutine:
        ;p_4 = sprite counter
        ;p_6 = fae x onscreen position
        ;p_8 = fae y onscreen position
        ;p_a = extra x bit
        
        phb
        phx
        phy
        
        pei (p_1)               ;db = spritemap bank
        plb
        plb
        
        stz p_a
        
        lda w_fae_x,x
        sec
        sbc w_level_camerax
        cmp #$ffd0              ;if fae is offscreen entirely, exit
        bmi ..return
        sta p_6                 ;fae onscreen x position
        
        lda w_fae_y,x
        sec
        sbc w_level_cameray
        cmp #$ffd0              ;if fae is offscreen entirely, exit
        bmi ..return
        sta p_8                 ;fae onscreen y position
        
        ldx p_0                 ;x = spritemap ptr
        ldy w_oam_index         ;y = oam entry point
        
        ;sep #$20
        
        lda $0000,x
        sta p_4
        inx
        
        ..nextsprite
        
        lda $0000,x                     ;add camera position to fae's
        clc                             ;object position
        adc p_6
        ;cmp #$ffa0
        ;bmi ..skip
        sta p_c                         ;debug for watching position
        sta w_oam_lo_buffer,y           ;x
        
        lda $0001,x
        clc
        adc p_8
        ;cmp #$ffa0
        ;bpl ..skip
        sta p_e                         ;debug for watching position
        sta w_oam_lo_buffer+1,y         ;y
        
        lda $0002,x
        sta w_oam_lo_buffer+2,y         ;tile
        
        lda $0003,x
        sta w_oam_lo_buffer+3,y         ;properties bit field
        
        lda $0004,x
        sta w_oam_hi_bytebuffer,y       ;oam hi buffer
        
        ..skip
        
        inx
        inx
        inx
        inx
        inx                             ;the extra x is for high table bits
                                            ;at the end of spritemap line
        iny
        iny
        iny
        iny
        
        dec p_4
        bne ..nextsprite
        
        sty w_oam_index
        
        ..return
        
        rep #$20
        
        ply
        plx
        plb
        rtl
    }
    
    .spritedrawingtest: {
        phb
        
        phk
        plb
        
        lda #fae_testspritemap
        sta p_0
        lda #bank(fae_testspritemap)
        sta p_2
        
        ldx #!fae_count*2
        jsl fae_addspritemap
        
        plb
        rtl
    }
    
    
    .testspawn: {
        ldx #!fae_count*2           ;first slot
        
        lda #$0080
        sta w_fae_x,x
        sta w_fae_y,x
        
        rtl
    }
    
    
    .testspritemap: {
        ;number of sprites
        db 36
        ;  xx   yy   tt   pp         hh
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
    
    .clear: {
        ;x = fae index
        
        stz w_fae_id,x
        stz w_fae_x,x
        stz w_fae_subx,x
        stz w_fae_y,x
        stz w_fae_suby,x
        stz w_fae_spritemapptr,x
        stz w_fae_touchptr,x
        stz w_fae_mainptr,x
        
        rts
    }
    
}