;top level label is "hdma"

.interleaved_indirect: {
    dw ..init, ..routine
    dl ..table
    dw $0f42 
    
    ..init: {
        
        lda w_hdma_bank,x       ;set indirect bank
        ora #$7e00
        sta w_hdma_bank,x
        
        ;fall through and run the main routine once
    }
    
    ..routine: {
        ;this shouldn't work but does... ugh
        
        
        phb
        phx
        phy
        
        pea.w bank(w_indirecthdmatable2)<<8
        plb
        plb
        
        lda w_hdma_timer,x        ;not indexing by x makes this use the last slot (for object 0)
        inc                       ;we don't use object 0 so use this as a global timer
        sta w_hdma_timer,x
        
        and #$00ff
        tax
        
        lda #$00e0
        sta p_2
        
        sep #$20
        ldy #$00e0*2
        ldx #$00e0
        
        ...loop:
        lda.l hdma_neg30sinetable,x                 ;hdma_1fsinetable, hdma_neg30sinetable, hdma_neg30sinetabledoubled
        sta.w w_indirecthdmatable2,y
        
        lda.l hdma_neg30sinetable+1,x               ;hdma_1fsinetable, hdma_neg30sinetable, hdma_neg30sinetabledoubled
        eor #$ff
        inc
        sta.w w_indirecthdmatable2+2,y
        
        dey
        dey
        dey
        dey
        
        dex
        dex
        
        bpl ...loop
        
        rep #$20
        ply
        plx
        plb
        rts
    }
    
    ..table: {
        %indirecthdmatable(w_indirecthdmatable2)
        db $00
    }
}