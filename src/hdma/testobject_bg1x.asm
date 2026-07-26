;top level label is "hdma"

.testobject_bg1x_indirect: {
    ;this doesn't really logically work but it's my fault for messing up the table logic
    ;as a way to test that hdma functions, it was a success
    
    
    dw ..init, ..routine
    dl ..table                  ;bank byte is written last
    
    ..init: {
        lda #$0d42              ;target is high byte ($210d), params $40 (indirect)
        sta w_hdma_params,x
        
        lda w_hdma_bank,x       ;set indirect bank
        ora #$7e00
        sta w_hdma_bank,x
        
        ;fall through
    }
    
    ..routine: {
        phb
        phx
        phy
        
        pea $7e7e
        plb
        plb
        
        ;build the table
        
        sep #$10
        
        lda w_nmicounter
        asl
        tax
        
        ldy #$ba
        ;print pc
        -
        lda.l hdma_1fsinetable,x
        sta.w w_indirecthdmatable,y
        
        lda.l hdma_1fsinetable+$40,x
        sta.w w_indirecthdmatable+$40,y
        
        lda.l hdma_1fsinetable+$80,x
        sta.w w_indirecthdmatable+$80,y
        
        lda.l hdma_1fsinetable+$c0,x
        sta.w w_indirecthdmatable+$c0,y
        dex
        dex
        dey
        dey
        bne -
        
        rep #$10
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
        %indirecthdmatable($2000)
        db $00
    }
}