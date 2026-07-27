;top level label is "hdma"

.template_direct: {
    dw ..init, ..routine
    dl ..table                  ;bank byte is written last
    
    ..init: {
        ;x = object index
        
        lda #$3200              ;target is high byte ($21xx) to $43x1, params is low byte to $43x0
        sta w_hdma_params,x
        
        rts
    }
    
    ..routine: {
        rts
    }
    
    ..table: {
        ;direct hdma table
        
        db $01, $00     ;number of lines, value to write
        
        db $00
    }
    
}