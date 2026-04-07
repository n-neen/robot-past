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
    
    jsl obj_runmain
    jsl obj_collision
    
    jsl player_main
    jsl scroll_main
    
    ;game goes here
    
    lda w_controller
    bit #!controller_a      ;push A: clear text
    beq +
    
    {   ;reset dialog prototype
        jsl msg_cleartilemap
        
        lda #$0001
        sta w_msg_uploadflag
        lda #$0800
        sta w_msg_size
        
        jsl layer3off_long
    }
    +
    
    rtl
}