;top level label is "hdma"

.sinewave_indirect: {
    ;this doesn't really logically work but it's my fault for messing up the table logic
    ;as a way to test that hdma functions, it was a success
    
    
    dw ..init, ..routine
    dl ..table                  ;bank byte is written last
    
    ..init: {
        lda #$1042              ;target is high byte ($2110), params $42 (indirect, write twice)
        sta w_hdma_params,x
        
        lda w_hdma_bank,x       ;set indirect bank (kept in high byte of w_hdma_bank)
        ora #bank(w_indirecthdmatable)<<8
        sta w_hdma_bank,x
        
        ;fall through and run the main routine once
    }
    
    ..routine: {
        phb
        phx
        phy
        
        pea.w bank(w_indirecthdmatable)<<8
        plb
        plb
        
        ;build the table
        ;only kinda works
        
        ;print pc
        
        
        lda w_hdma_timer,x
        inc
        ;cmp #$00ff
        ;bmi +
        ;lda #$0000
        ;+
        sta w_hdma_timer,x
        
        tax
        
        sep #$30
        
        ldy #$40
        -
        lda.l hdma_1fsinetable,x
        sta.w w_indirecthdmatable,y
        
        lda.l hdma_1fsinetable+$40,x
        sta.w w_indirecthdmatable+$40,y
        
        lda.l hdma_1fsinetable+$80,x
        sta.w w_indirecthdmatable+$80,y
        
        lda.l hdma_1fsinetable+$c0,x
        sta.w w_indirecthdmatable+$c0,y
        
        lda.l hdma_1fsinetable+$0,x
        sta.w w_indirecthdmatable+$100,y
        
        lda.l hdma_1fsinetable+$40,x
        sta.w w_indirecthdmatable+$140,y
        
        lda.l hdma_1fsinetable+$80,x
        sta.w w_indirecthdmatable+$180,y
        
        dex
        dex
        dey
        dey
        bne -
        
        rep #$30
        ply
        plx
        plb
        rts
    }
    
    ..table: {
        macro indirecthdmatable(startaddr)
            !a #= 0
            while !a < $1b4
                db $01 : dw <startaddr>+!a
                !a #= !a+2
            endwhile
            
        endmacro
        %indirecthdmatable(w_indirecthdmatable)
        db $00
    }
}