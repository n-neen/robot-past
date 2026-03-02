;===========================================================================================
;======================================== SCROLLING ========================================
;===========================================================================================

scroll: {
    .main: {
        
        ;move background layer,
        ;determine if scrolling update is necessary,
        ;possibly use layer (camera) scroll % 8
        ;and if panned to edge of scroll area
        
        ;then
        
        lda w_scroll_direction
        beq +
        asl
        tax
        
        jsr (scroll_main_directiontable,x)
        
        +
        rtl
        
        ..directiontable: {
            dw scroll_up
            dw scroll_down
            dw scroll_left
            dw scroll_right
        }
    }
    
    .up: {
        ;do somethin then
        jsr scroll_figurerow
        rts
    }
    
    .down: {
        ;
        jsr scroll_figurerow
        rts
    }

    .left: {
        ;
        jsr scroll_figurecolumn
        rts
    }

    .right: {
        ;
        jsr scroll_figurecolumn
        rts
    }    
    
    .figurecolumn: {
        
        ;if going left or right, scroll update is a column at
        ;the edge of the scroll area
        
        ;figure out location in source (in level data)
        ;and destimation (in vram)
        ;for horizontal scroll (column update)
        
        sta w_level_seamcolumn
        sta w_level_dmastart
        
        jsr scroll_uploadcolumn
        
        rts
    }
    
    
    .figurerow: {
        
        ;if going up or down, scroll update is a row at
        ;the edge of the scroll area
        
        ;figure out source (in level data)
        ;and destimation (in vram)
        ;for horizontal scroll (column update)
        
        sta w_level_seamrow
        sta w_level_dmastart
        
        rts
    }
    
    
    .uploadcolumn: {
        phx
        phb
        php
        
        phk
        plb
        
        rep #$20
        sep #$10
                                    ;width  register
        ldx.b #$81                  ;1      inc by 32 words
        stx $2115
        
        lda.w w_level_seamcolumn    ;2      dest base addr
        sta $2116
        
        ldx #$01                    ;1      transfur mode
        stx $4300
        
        ldx #$18                    ;1      register dest (vram port)
        stx $4301
        
        lda.w w_level_dmastart      ;2      source addr
        sta $4302
        
        ldx.b #!k_level_bank        ;1      source bank
        stx $4304
        
        lda.w #!k_scroll_columnsize ;2      transfur size
        sta $4305
        
        ldx #$01                    ;1      enable transfur on dma channel 0
        stx $420b
        
        plp
        plb
        plx
        rts
    }
    
    
    .dmarow: {
        ;same as above but with normal write pattern
        
        
        rts
    }
}