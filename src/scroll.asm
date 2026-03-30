;===========================================================================================
;======================================== SCROLLING ========================================
;===========================================================================================

scroll: {
    .main: {
        lda w_player_x_onscreen
        cmp #!camera_box_lf_bound
        bpl ..skipleft
        ;if > x bound (towards center of screen),
        lda w_player_direction
        bit #!controller_lf
        beq ..skipleft
        ;and moving left,
        and #!controller_lf
        ora w_scroll_direction
        sta w_scroll_direction
        ..skipleft:
        
        lda w_player_x_onscreen
        cmp #!camera_box_rt_bound
        bmi ..skipright
        ;if < x bound (towards center of screen),
        lda w_player_direction
        bit #!controller_rt
        beq ..skipright
        ;and moving right,
        and #!controller_rt
        ora w_scroll_direction
        sta w_scroll_direction
        ..skipright:
        
        lda w_player_y_onscreen
        cmp #!camera_box_up_bound
        bpl ..skipup
        ;if > y bound (towards center of screen),
        lda w_player_direction
        bit #!controller_up
        beq ..skipup
        ;and moving up,
        and #!controller_up
        ora w_scroll_direction
        sta w_scroll_direction
        ..skipup:
        
        lda w_player_y_onscreen
        cmp #!camera_box_dn_bound
        bmi ..skipdown
        ;if < y bound (towards center of screen),
        lda w_player_direction
        bit #!controller_dn
        beq ..skipdown
        ;and moving down,
        and #!controller_dn
        ora w_scroll_direction
        sta w_scroll_direction
        ..skipdown:
        
        lda w_scroll_direction
        
        bit #!controller_up
        beq ..noup
        jsr scroll_up
        ..noup:
        
        bit #!controller_dn
        beq ..nodown
        jsr scroll_down
        ..nodown:
        
        bit #!controller_lf
        beq ..noleft
        jsr scroll_left
        ..noleft:
        
        bit #!controller_rt
        beq ..noright
        jsr scroll_right
        ..noright:
        
        ;apply camera to bg1 scroll
        lda w_level_camerax
        sta w_bg1xscroll
        
        lda w_level_cameray
        sta w_bg1yscroll
        
        rtl
    }
    
    .up: {
        pha
        
        lda w_level_cameray
        cmp w_scroll_upbound
        bmi +
        
        lda w_level_camerasuby
        sec
        sbc w_scroll_camerasubspeed
        sta w_level_camerasuby
        
        lda w_level_cameray
        sbc w_scroll_cameraspeed
        sta w_level_cameray
        
        +
        
        pla
        rts
    }
    
    .down: {
        pha
        
        lda w_level_cameray
        cmp w_scroll_downbound
        bpl +
        
        lda w_level_camerasuby
        clc
        adc w_scroll_camerasubspeed
        sta w_level_camerasuby
        
        lda w_level_cameray
        adc w_scroll_cameraspeed
        sta w_level_cameray
        
        +
        
        pla
        rts
    }

    .left: {
        pha
        
        lda w_level_camerax
        cmp w_scroll_leftbound
        bmi +
        
        lda w_level_camerasubx
        sec
        sbc w_scroll_camerasubspeed
        sta w_level_camerasubx
        
        lda w_level_camerax
        sbc w_scroll_cameraspeed
        sta w_level_camerax
        
        +
        
        pla
        rts
    }

    .right: {
        pha
        
        lda w_level_camerax
        cmp w_scroll_rightbound
        bpl +
        
        lda w_level_camerasubx
        clc
        adc w_scroll_camerasubspeed
        sta w_level_camerasubx
        
        lda w_level_camerax
        adc w_scroll_cameraspeed
        sta w_level_camerax
        
        +
        
        pla
        rts
    }
    
    
    
    ;i doubt i will ever use the stuff below here:
    
    
    
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