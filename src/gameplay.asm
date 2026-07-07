gameplay: {
    phk
    plb
    
    jsl hud_handleglow
    
    stz w_player_direction
    stz w_scroll_direction
    stz w_player_collisiontype          ;not really used currently
    stz w_oam_index
    
    jsl oam_cleanhibytebuffer
    
    jsl hud_draw
    
    jsl player_main
    jsl scroll_main
    ;jsl scroll_bg2
    
    jsl obj_runmain
    jsl obj_collision
    
    .hudwordtest: {
        ;test
        ;clear the hud area so the fae collision test result
        ;can be seen
        
        lda w_nmicounter
        bit #$005f
        bne +
        lda #$2020
        sta w_hud_buffer+10
        sta w_hud_buffer+12
        +
    }
    
    jsl shot_top
    
    jsl fae_top
    
    jsl oam_cleanbuffer                 ;write $e0e0 to the remainder of the oam buffer not used by this frame
    jsl oam_constructhibuffer           ;construct the real (two bits per sprite) oam hi table from the byte table (one byte per sprite)
    
    rtl
    
    
    .shadow: {
        ;stripped down gameplay to allow player to move during text
        ;but does not allow for collision
        
        stz w_player_direction
        stz w_scroll_direction
        
        jsl player_main
        jsl scroll_main
        
        rtl
    }
    
    
}
