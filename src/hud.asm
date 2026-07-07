

hud: {
    .draw: {
        phb
        phx
        phy
        
        phk
        plb
        
        ldx #$0000
        ldy w_oam_index
        
        sep #$20
        {
            ..nextletter
            ;do this first since if the tile is blank we bail
            lda w_hud_buffer,x          ;tile index
            cmp.b #!hud_end
            beq ..end
            sec 
            sbc.b #!hud_ascii_offset    ;align ascii with tiles
            beq ..skip
            sta w_oam_lo_buffer+2,y
            
            lda #%00110000              ;properties:
            sta w_oam_lo_buffer+3,y     ;palette 0, high priority, first page
            
            cpx #!hud_row_length
            bpl ..secondrow
            
            lda.b #!hud_first_row_y_pos
            bra ..firstrow
            
            ..secondrow:
            lda.b #!hud_second_row_y_pos
            
            ..firstrow:
            sta w_oam_lo_buffer+1,y     ;temp, just do one row for now [y position]
            
            txa                         ;buffer index * 8 = pixels along row we are
            asl
            asl
            asl
            sta w_oam_lo_buffer,y       ;x position
            
            iny
            iny
            iny
            iny
            
            ..skip
            inx
            cpx #!hud_row_length*2
            bmi ..nextletter
            
            ..end:
        }
        rep #$20
        
        sty w_oam_index
        
        ply
        plx
        plb
        rtl
    }
    
    
    .init: {
        ;clear buffer
        ;if any tile in the buffer is blank (ascii $20) then we skip drawing it
        phb
        phx
        
        phk
        plb
        
        sep #$20
        {
            ldx #!hud_buffer_size
            lda #$20                ;ascii blank letter
            
            -
            sta w_hud_buffer,x
            dex
            bpl -
        }
        rep #$20
        
        plx
        plb
        rtl
    }
    
    .writeroomstring: {
        ;currently fixed at 10 (decimal) characters
        
        
        phb
        phx
        phy
        
        pea.w bank(str)<<8
        plb
        plb
        
        lda.l w_level_hudstring_ptr
        clc
        adc #!hud_room_string_length
        tay
        
        sep #$20
        {
            ldx #!hud_room_string_length
            
            -
            lda $0000,y
            sta.l w_hud_buffer+22,x
            
            dey
            dex
            bpl -
            
        }
        rep #$20
        
        ply
        plx
        plb
        rtl
    }
    
    
    .handleglow: {
        phk
        plb
        
        lda w_hud_glow
        beq +
        
        lda w_nmicounter
        and #$003e
        tax
        
        sep #$20
        
        lda hud_handleglow_triangletable,x
        ora #%00100000
        sta w_hud_colortint_r
        
        lda hud_handleglow_triangletable+2,x
        ora #%01000000
        sta w_hud_colortint_g
        
        lda hud_handleglow_triangletable+12,x
        ora #%10000000
        sta w_hud_colortint_b
        
        rep #$20
        rtl
        
        +
        sep #$20
        
        lda #%00101111
        sta w_hud_colortint_r
        
        lda #%01001111
        sta w_hud_colortint_g
        
        lda #%10001111
        sta w_hud_colortint_b
        
        rep #$20
        rtl
        
        ..triangletable: {   ;$3e entries... plus some 0 cause i'm off by one i guess
                            ;oh and then double it, too, why not
            db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,
               $11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,
               $1f,$1e,$1d,$1c,$1b,$1a,$19,$18,$17,$16,$15,$14,$13,$12,$11,
               $0f,$0e,$0d,$0c,$0b,$0a,$09,$08,$07,$06,$05,$04,$03,$02,$01
            db $00, $00, $00
            
            db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,
               $11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,
               $1f,$1e,$1d,$1c,$1b,$1a,$19,$18,$17,$16,$15,$14,$13,$12,$11,
               $0f,$0e,$0d,$0c,$0b,$0a,$09,$08,$07,$06,$05,$04,$03,$02,$01
            db $00, $00, $00
               
        }
    }
    
    
    .test: {
        phb
        phx
        
        phk
        plb
        
        ldx #datasize(hud_test_string)
        
        sep #$20
        {
            -
            lda hud_test_string,x
            sta w_hud_buffer,x
            
            dex
            bpl -
        }
        rep #$20
        
        plx
        plb
        rtl
        
        ..string: {
            db "life: 27                        "
            db "hud second row", !hud_end
        }
    }
}

.dummylabel3:
    ;for datasize of above