;===========================================================================================
;========================================= HDMA ============================================
;===========================================================================================

;hdma object:
    ;init routine   ;runs once when it is created
    ;main routine   ;runs once per frame
    ;hdma target
    ;indirect or direct
    ;table source bank
    ;(object's index in hdma system arrays)/2 is used as hdma channel
    
    ;w_hdma_params contains data to write to both $4300 and $4301
        ;ttpp
        ;p = params
        ;t = ppu target

hdma: {
    .nmihandler: {
        ;look for object slots that are occupied
        ;use the object's prarmeters to configure the hdma channel
        
        ;ok we unroll this
        
        ;print pc
        
        macro hdmachannelconfig(channel)
            !regbitmask #= (<channel>)<<4       ;obj slot 3 = bitmask $30
                                                ;mask onto hdma reg addr
            lda w_hdma_id+((<channel>)<<1)
            beq +++
            
            lda w_hdma_params+((<channel>)<<1)  ;$43x0/43x1
            sta $4300|!regbitmask
            
            bit #$0040
            beq +                               ;if indirect
            
            lda w_hdma_bank+((<channel>)<<1)
            and #$00ff
            sta $4305|!regbitmask
            
            lda w_hdma_table+((<channel>)<<1)   ;use $43x5/43x6/43x7
            sta $4306|!regbitmask
            
            bra ++
            
            +                                   ;if direct
            
            lda w_hdma_table+((<channel>)<<1)   ;use $43x2/43x3/43x4
            sta $4302|!regbitmask
            
            lda w_hdma_bank+((<channel>)<<1)
            and #$00ff
            sta $4304|!regbitmask
            
            ++
            
            lda #($0100)|($0001<<(<channel>))
            ora w_hdma_channels
            sta w_hdma_channels
            
            +++
        endmacro
        
        lda w_hdma_enable
        bne +
        
        %hdmachannelconfig(1)
        %hdmachannelconfig(2)
        %hdmachannelconfig(3)
        %hdmachannelconfig(4)
        %hdmachannelconfig(5)
        %hdmachannelconfig(6)
        %hdmachannelconfig(7)
        
        +
        rtl
    }
    
    
    .top: {
        ;main routine for when gameplay is happening
        ;iterate over slots
        ;run main routine for each
        
        ldx #!k_hdma_objects_count*2
        -
        
        lda w_hdma_id,x
        beq +
        
        phx
        jsr (w_hdma_routine,x)
        plx
        
        +
        dex
        dex
        bpl -
        
        rtl
    }
    
    
    .spawn: {
        ;y = pointer to object header
        ;x = object index
        
        phb
        
        phk
        plb
        
        tya
        sta w_hdma_id,x         ;object id (pointer to header)
        
        lda $0000,y             ;object init routine
        sta w_hdma_init,x
        
        lda $0002,y             ;object main routine
        sta w_hdma_routine,x
        
        lda $0004,y             ;object table pointer
        sta w_hdma_table,x
        
        lda $0006,y             ;object table bank
        and #$00ff
        sep #$20
        sta w_hdma_bank,x
        rep #$20
        
        phx
        jsr (w_hdma_init,x)     ;run init routine
        plx
        
        plb
        rtl
    }
    
    
    .clearall: {
        ldx #!k_hdma_objects_count*2
        -
        
        jsr hdma_clear
        dex
        dex
        bpl -
        
        rtl
    }
    
    
    .clear: {
        ;x = object index
        
        ;we could probably do without setting db here
        ;but we're a hirom program, so it's best to do this
        
        phb
        
        phk
        plb
        
        stz w_hdma_id,x
        stz w_hdma_init,x
        stz w_hdma_routine,x
        stz w_hdma_timer,x
        stz w_hdma_table,x
        stz w_hdma_params,x
        
        sep #$20
        {
            stz w_hdma_bank,x       ;how to get around this sep?
        }
        rep #$20
        
        plb
        rts
    }
    
    
    
    
    
    .testobject: {
        ;to create the structure
        dw ..init, ..routine
        dl ..table                  ;bank byte is written last
        
        ..init: {
            rts
        }
        
        ..routine: {
            rts
        }
        
        ..table: {
            db $01, $ff
            db $00
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
}