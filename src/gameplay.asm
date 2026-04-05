gameplay: {
    ;there's a problem with fadeout and fadein leaving
    ;screen brightness in a bad place
    ;maybe only happens on snes9x?!
    ;todo fix that
    
    
    stz w_player_direction
    stz w_scroll_direction
    
    jsl player_main
    jsl scroll_main
    
    ;game goes here
    
    lda w_controller
    bit #$c0c0
    beq +
    ;test room change
    
    ldx #scenedef_room2         ;get scene pointer
    jsr scenetransition         ;populate scene area of memory
    
    lda w_scene_mode            ;transition to program state
    sta w_programstate          ;indicated by scene data (either loadscene or loadgame)
    
    jsl msg_cleartilemap
    
    jsr fadeout
    bra ++                      ;maybe we want to avoid doing both msg test and room transition at the same time
    +
    
    lda w_controller
    bit #$1000
    beq ++
    
    ;if start go here
    jsl msg_tilemaptest
    
    ++
    
    rtl
}