;need:
    ;sprite drawing routine for fixed-to screen, so super easy
    ;string to spritemap routine
    ;bcd routine for writing hp to hud 

hud: {
    .draw: {
        phk
        plb
        
        phb
        
        ldx #$0000
        ldy w_oam_index
        
        sep #$20
        {
            ..nextletter
            ;do this first since if the tile is blank we bail
            lda w_hud_buffer,x          ;tile index
            cmp #$ff
            beq ..end
            sec 
            sbc #$20                    ;align ascii with tiles
            beq ..skip
            sta w_oam_lo_buffer+2,y
            
            lda #%00111111              ;properties:
            sta w_oam_lo_buffer+3,y     ;palette 7, high priority, second page
            
            lda #$00
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
            cpx #$0064
            bmi ..nextletter
            
        }
        ..end
        sty w_oam_index
        
        rep #$20
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
            db "life pointz: 42069 lol", !hud_end
        }
    }
}

.dummylabel3:
    ;for datasize of above