gameplay: {
    ;there's a problem with fadeout and fadein leaving
    ;screen brightness in a bad place
    ;maybe only happens on snes9x?!
    ;todo fix that
    ;ok i can't reproduce it anymore, no idea lol
    ;this bug seems to be permanently gone but
    ;i can't recall actually understanding how it worked
    ;or deliberately fixing it
    
    stz w_player_direction
    stz w_scroll_direction
    stz w_player_collisiontype          ;not really used currently
    stz w_oam_index
    
    jsl oam_cleanhibytebuffer
    
    jsl hud_draw
    
    jsl obj_runmain
    jsl obj_collision
    
    jsl player_main
    jsl scroll_main
    ;jsl scroll_bg2
    
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