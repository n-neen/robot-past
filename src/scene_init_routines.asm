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
        
        
        ldy #hdma_sinewave_indirect
        ldx #$0002
        lda #$0d42              ;
        jsl hdma_spawn
        
        ldy #hdma_sinewave_indirect
        ldx #$0004
        lda #$1042              ;
        jsl hdma_spawn
        
        lda #$0001
        sta w_hdma_enable
        
        ;load bg2 stuff
        {
            lda #pieces_bg2
            sta p_0
            
            lda #bank(pieces)
            sta p_2
            
            lda #datasize(pieces_bg2)
            jsl load_romtobuffer
        }
        
        lda #datasize(pieces_bg2)   ;tilemap size
        ldx #!bg2tilemap            ;destination in vram
        jsl load_buffertovram       ;dma tilemap to vram
        
        sep #$20
        {
            lda #%00000010
            sta w_colormathlogic
            sta $2130
            
            lda #%11100000      ;color math layers
            sta w_colormathlayers
            sta $2131
            
            lda #%00000101      ;main screen layers
            sta w_mainscreenlayers
            sta $212c
            
            lda #%00000010      ;subscreen layers
            sta w_subscreenlayers
            sta $212d
        }
        rep #$20
        
        rts
}