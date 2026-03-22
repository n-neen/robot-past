;===========================================================================================
;======================================= SPRITES ===========================================
;===========================================================================================

;oam buffer
;actually use high table this time
;spritemaps

oam: {
    .uploadbuffer: {
        ;runs in vblank
        
        phx
        php
        
        sep #$10                        ;8 bit x/y mode
        rep #$20                        ;16 bit A
        
                                        ;width  register
        stz $2102                       ;1      oam high starting addr = 0
        
        ldx #$00                        ;1      transfur mode
        stx $4300
        
        ldx #$04                        ;1      register dest (oam add)
        stx $4301
        
        ldx.b #(($ff0000&w_oam)>>16)    ;1      source bank
        stx $4304
        
        lda.w #w_oam_lo_buffer          ;2      source addr
        sta $4302
        
        lda #$0220                      ;2      transfur size = 542 bytes (oam table size)
        sta $4305
        
        ldx #$01                        ;1      enable transfur on dma channel 0             
        stx $420b
        
        plp
        plx
        rtl
    }
    
    
    
    .addsprite: {
        ;argument:
        ;long spritemap pointer in p_0
        
        ;maybe do player first
        
        rtl
    }
}