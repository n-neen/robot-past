;top level label is "hdma"

.interleaved_indirect: {
    dw ..init, ..routine
    dl ..table
    dw $0f42 
    
    ..init: {
        ;lda #$0040              ;target is high byte ($21xx), params $40 (indirect)
        ;sta w_hdma_params,x
        
        lda w_hdma_bank,x       ;set indirect bank
        ora #$7e00
        sta w_hdma_bank,x
        
        ;fall through and run the main routine once
    }
    
    ..routine: {
        phb
        phx
        phy
        
        pea.w bank(w_indirecthdmatable2)<<8
        plb
        plb
        
        lda w_hdma_timer,x        ;not indexing by x makes this use the last slot (for object 0)
        inc                     ;we don't use object 0 so use this as a global timer
        sta w_hdma_timer,x
        
        tax
        
        lda #$00e0
        sta p_2
        
        sep #$30
        ldy #$e0+2
        
        ...loop:
        lda.l hdma_neg30sinetable,x                 ;hdma_1fsinetable, hdma_neg30sinetable, hdma_neg30sinetabledoubled
        sta.w w_indirecthdmatable2,y
        
        lda.l hdma_neg30sinetable,x               ;hdma_1fsinetable, hdma_neg30sinetable, hdma_neg30sinetabledoubled
        eor #$ff
        inc
        sta.w w_indirecthdmatable2+2,y
        
        ;
        
        lda.l hdma_neg30sinetable+$60,x             ;hdma_1fsinetable, hdma_neg30sinetable, hdma_neg30sinetabledoubled
        sta.w w_indirecthdmatable2+$c0,y
        
        lda.l hdma_neg30sinetable+$61,x             ;hdma_1fsinetable, hdma_neg30sinetable, hdma_neg30sinetabledoubled
        eor #$ff
        inc
        sta.w w_indirecthdmatable2+$c2,y
        
        dex
        dex
        
        dey
        dey
        dey
        dey
        
        rep #$20
        dec p_2
        sep #$20
        bpl ...loop
        
        rep #$30
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