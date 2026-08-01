sceneinit: {
    ;currently has to exist in the same bank as main.asm
    ;gets called from top level state in main.asm
    ;runs during a bunch of high level calls while setting up the
    ;program for a nongameplay scene (currently)
    ;so can probably clobber whatever it wants (except rep #$20)
    ;runs with forced blank so can dma to vram
    
    .pieces: {
        ;this should probably serve as decent prototyping for
        ;systems to write. i imagine a lot of routines like this
        ;should not be this massive
        
        ;ldy #glow_incrementing
        ;jsl glow_spawn
        
        ;load bg2 stuff
        {
            lda #pieces2_bg2
            sta p_0
            
            lda #bank(pieces2)
            sta p_2
            
            lda #datasize(pieces2_bg2)
            jsl load_romtobuffer
        }
        
        lda #datasize(pieces2_bg2)  ;tilemap size
        ldx #!bg2tilemap            ;destination in vram
        jsl load_buffertovram       ;dma tilemap to vram
        
        ;load copy of bg1 tilemap to the right
        {
            lda #pieces2_map
            sta p_0
            
            lda #bank(pieces2_map)
            sta p_2
            
            lda #datasize(pieces2_map)
            jsl load_romtobuffer
        }
        
        lda #datasize(pieces2_map)  ;tilemap size
        ldx #!bg1tilemap+$400       ;destination in vram
        jsl load_buffertovram       ;dma tilemap to vram
        
        lda #datasize(pieces2_map)  ;tilemap size
        ldx #!bg1tilemap+$800       ;destination in vram
        jsl load_buffertovram       ;dma tilemap to vram
        
        lda #datasize(pieces2_map)  ;tilemap size
        ldx #!bg1tilemap+$c00       ;destination in vram
        jsl load_buffertovram       ;dma tilemap to vram
        
        lda #!layer_blend_scene_pieces
        sta w_layerblendmode
        
        lda #$01ff
        sta w_bg2yscroll
        
        stz w_bg2xscroll
        
        ;ldy #hdma_sinewave_indirect
        ;ldx #$0002
        ;lda #$1042              ;bg2 y
        ;jsl hdma_spawn
        
        ;ldy #hdma_glitch_bands_indirect
        ;ldx #$0004
        ;lda #$0f42              ;bg2 x
        ;jsl hdma_spawn
        
        ;ldy #hdma_sinewave_indirect
        ;ldx #$0006
        ;lda #$0e42              ;bg1 y
        ;jsl hdma_spawn
        
        ;ldy #hdma_sinewave_indirect
        ;ldx #$0008
        ;lda #$0d42              ;bg1 x
        ;jsl hdma_spawn
        
        ;ldy #hdma_glitch_bands_indirect
        ;ldx #$000a
        ;lda #$0640              ;mosaic
        ;jsl hdma_spawn
        
        lda #$0001
        sta w_hdma_enable
        
        rts
        
        ;==============================================================================
        
        .agony: {
        ;load bg2 stuff
        {
            lda #agony_bg2map
            sta p_0
            
            lda #bank(agony)
            sta p_2
            
            lda #datasize(agony_bg2map)
            jsl load_romtobuffer
        }
        
        lda #datasize(agony_bg2map) ;tilemap size
        ldx #!bg2tilemap            ;destination in vram
        jsl load_buffertovram       ;dma tilemap to vram
        
        lda #!layer_blend_scene_agony
        sta w_layerblendmode
        
        lda #$01ff
        sta w_bg2yscroll
        
        stz w_bg2xscroll
        
        ;ldy #hdma_sinewave_indirect
        ;ldx #$0002
        ;lda #$1042              ;bg2 y
        ;jsl hdma_spawn
        
        ;ldy #hdma_sinewave_indirect
        ;ldx #$0008
        ;lda #$0e42              ;bg1 y
        ;jsl hdma_spawn
        
        ;ldy #hdma_sinewave_indirect
        ;ldx #$0004
        ;lda #$0f42              ;bg2 x
        ;jsl hdma_spawn
        
        lda #$0001
        sta w_hdma_enable
        
        ;ldy #glow_agony
        ;jsl glow_spawn
            
        rts
}