

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
            
            lda #%00111111              ;properties:
            sta w_oam_lo_buffer+3,y     ;palette 7, high priority, second page
            
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
        
        ldx #!hud_buffer_size
        lda #$20                ;ascii blank letter
        
        -
        sta w_hud_buffer,x
        dex
        bpl -
        
        rep #$20
        plx
        plb
        rtl
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
            db "life: 27              robot past"
            db "hud second row", !hud_end
        }
    }
}

.dummylabel3:
    ;for datasize of above