sceneinit: {
    ;currently has to exist in the same bank as main.asm
    ;gets called from top level state in main.asm
    ;runs during a bunch of high level calls while setting up the
    ;program for a nongameplay scene (currently)
    ;so can probably clobber whatever it wants (except rep #$20)
    ;runs with forced blank so can dma to vram
    
    .pieces: {
        ;load cop\ies of bg1 tilemap to the right and down of the screen
        {
            lda #pieces_map
            sta p_0
            
            lda #bank(pieces_map)
            sta p_2
            
            lda #datasize(pieces_map)
            jsl load_romtobuffer
        }
        
        lda #datasize(pieces_map)   ;tilemap size
        ldx #!bg1tilemap+$400       ;destination in vram
        jsl load_buffertovram       ;dma tilemap to vram
        
        lda #datasize(pieces_map)   ;tilemap size
        ldx #!bg1tilemap+$800       ;destination in vram
        jsl load_buffertovram       ;dma tilemap to vram
        
        lda #datasize(pieces_map)   ;tilemap size
        ldx #!bg1tilemap+$c00       ;destination in vram
        jsl load_buffertovram       ;dma tilemap to vram
        
        lda #!layer_blend_scene_pieces
        sta w_layerblendmode
        
        lda #$01ff
        sta w_bg2yscroll
        
        stz w_bg2xscroll
        
        rts
        
        ;==============================================================================
        
        .agony: {
        
        lda #!layer_blend_scene_agony
        sta w_layerblendmode
        
        lda #$01ff
        sta w_bg2yscroll
        
        stz w_bg2xscroll
        
        rts
}