;===========================================================================================
;=================================== dma routines ==========================================
;===========================================================================================


dma: {
    .vramtransfur: {        ;for dma channel 0
                                                ;register width (bytes)
        ;dma_control            =   $2115       ;1
        ;dma_dest_baseaddr      =   $2116       ;2
        ;dma_transfur_mode      =   $4300       ;1
        ;dma_reg_destination    =   $4301       ;1
        ;dma_source_address     =   $4302       ;2
        ;dma_bank               =   $4304       ;1
        ;dma_transfur_size      =   $4305       ;2
        ;dma_enable             =   $430b       ;1
                            ;set to #%00000001 to enable transfur on channel 0
        phx
        phb
        php
        
        phk
        plb
        
        rep #$20
        sep #$10
                                    ;width  register
        ldx.b #$80                  ;1      dma control
        stx $2115
        
        lda.w w_dmabaseaddr         ;2      dest base addr
        sta $2116
        
        ldx #$01                    ;1      transfur mode
        stx $4300
        
        ldx #$18                    ;1      register dest (vram port)
        stx $4301
        
        lda.w w_dmasrcptr           ;2      source addr
        sta $4302
        
        ldx w_dmasrcbank            ;1      source bank
        stx $4304
        
        lda.w w_dmasize             ;2      transfur size
        sta $4305
        
        ldx #$01                    ;1      enable transfur on dma channel 0
        stx $420b
        
        plp
        plb
        plx
        rtl
    }
    
    .cgramtransfur: {
        phx
        phb
        php
        
        phk
        plb
        
        rep #$20
        sep #$10                    ;width  register
        
        ldx w_dmabaseaddr           ;1      cgadd
        stx $2121
        
        ldx #$02                    ;1      transfur mode
        stx $4300
        
        ldx #$22                    ;1      register dest (cgram write)
        stx $4301
        
        lda.w w_dmasrcptr           ;2      source addr
        sta $4302
        
        ldx w_dmasrcbank            ;1      source bank
        stx $4304
        
        lda.w w_dmasize             ;2      transfur size
        sta $4305
        
        ldx #$01                    ;1      enable transfur on dma channel 0
        stx $420b
        
        plp
        plb
        plx
        rtl
    }
    
    .clearvram: {
        phx
        phb
        php
        
        phk
        plb        
        
        rep #$20
        sep #$10                    ;width  register
        
        ldx.b #$80                  ;1      dma control
        stx $2115
        
        lda #$0000                  ;2      dest base addr
        sta $2116
        
        ldx.b #%00011001            ;1      transfur mode
        stx $4300
        
        ldx #$18                    ;1      register dest (vram port)
        stx $4301
        
        lda.w #..fillword           ;2      source addr
        sta $4302
        
        stz $4305                   ;2      transfur size ($10000)
        
        ldx.b #!dmabankshort        ;1      source bank
        stx $4304
        
        ldx.b #$01                  ;1      enable transfur on dma channel 0    
        stx $420b
        
        plp
        plb
        plx
        rtl    
        ..fillword: {
            dw $0000
        }
    }
    
    
    .clearcgram: {
        phx
        phb
        php
        
        phk
        plb
        
        rep #$20
        sep #$10                    ;width  register
        
        ldx.b #$00                  ;1      cgadd
        stx $2121

        ldx.b #%00011001            ;1      transfur mode: write twice
        stx $4300
        
        ldx #$22                    ;1      register dest (cgram write)
        stx $4301
        
        lda.w #..fillword           ;2      source addr
        sta $4302
        
        ldx.b #!dmabankshort        ;1      source bank
        stx $4304
        
        lda.w #$0400                ;2      transfur size
        sta $4305
        
        ldx.b #$01                  ;1      enable transfur on dma channel 0
        stx $420b
        
        plp
        plb
        plx
        rtl  
        
        ..fillword: {
            dw $3800
        }
    }
}

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
    
    .cleanbuffer: {
        ;remove stale sprites after sprites for this frame are drawn
        
        ldx w_oam_index
        lda #$e0e0
        
        -
        sta w_oam_lo_buffer,x
        inx
        inx
        cpx #$0200          ;uhh is that right or no?
        bmi -
        
        rtl
    }
    
    .cleanhibytebuffer: {
        phk
        plb
        
        ldx #!oam_hi_byte_buffer_size
        
        -
        stz w_oam_hi_bytebuffer,x
        dex
        dex
        bpl -
        
        rtl
    }
    
    .constructhibuffer: {
        ;todo: clear both oam high buffers every frame
        
        phx
        phy
        php
        
        phk
        plb
        
        ldx #!oam_hi_byte_buffer_size
        ldy #$001f
        
        sep #$20            ;%00000000
        {
            -
            stz p_8
            
            lda w_oam_hi_bytebuffer,x
            ora p_8
            sta p_8
            
            lda w_oam_hi_bytebuffer+1,x
            asl
            asl
            ora p_8
            sta p_8
            
            lda w_oam_hi_bytebuffer+2,x
            asl
            asl
            asl
            asl
            ora p_8
            sta p_8
            
            lda w_oam_hi_bytebuffer+3,x
            asl
            asl
            asl
            asl
            asl
            asl
            ora p_8
            sta p_8
            
            sta w_oam_hi_buffer,y
            
            dex
            dex
            dex
            dex
            
            dey
            
            bpl -
        }
        
        plp
        ply
        plx
        rtl
    }
}
    
