;===========================================================================================
;==================================  COLOR CYCLING =========================================
;======================================= GLOWS =============================================
;===========================================================================================
;===========================================================================================

;finally works


glow: {
    .top: {
        ;top level handler for color cycling
        phb
        
        phk
        plb
        
        lda w_glow_enable
        beq +
        
        jsr glow_runroutines
        jsr glow_handleall
        
        +
        plb
        rtl
    }
    
    
    .handleall: {
        ldx.w #!glow_objects_count*2
        
        {                               ;for x = number of slots
            ..loop
            
            lda w_glow_id,x
            beq +
            
            
            lda w_glow_timer,x
            dec
            sta w_glow_timer,x
            bpl +
            
            ;if timer is up:
            -
            lda w_glow_list,x
            tay
            
            lda $0000,y
            bpl ++
            
            jsr glow_execinstruction    ;if negative, it's an instruction pointer
            bra +
            
            ++
            jsr glow_writecolors        ;if positive, it's a color
            bra -
            
            
            +
            
            dex
            dex
            bpl ..loop                       ;next x
        }
        
        rts
    }
    
    
    .execinstruction: {
        ;x = glow object index
        ;y = instruction list pointer
        ;a = pointer to instruction to run
        
        sta p_3
        jmp (p_3)
    }
    
    
    .inst: {
        ..done: {
            ;x = glow object index
            ;y = instruction list ptr
            
            ;print pc
            
            phy
            
            ldy w_glow_id,x
            lda $0004,y
            tay
            lda $0000,y
            sta w_glow_timer,x
            
            ply
            
            lda w_glow_list,x
            inc
            inc
            sta w_glow_list,x
            
            lda w_glow_colorindexstart,x
            sta w_glow_colorindex,x
            
            rts
        }
        
        ..loop: {
            ;x = glow object index
            
            lda w_glow_liststart,x
            sta w_glow_list,x
            
            lda w_glow_colorindexstart,x
            sta w_glow_colorindex,x
            
            rts
        }
        
    }
    
    
    
    .writecolors: {
        ;x   = glow object index
        ;y   = instruction list ptr
        ;a   = color
        phy
        
        ldy w_glow_colorindex,x
        
        phx
        tyx
        sta.l w_cgrambuffer,x
        plx
        
        lda w_glow_list,x
        inc
        inc
        sta w_glow_list,x
        
        lda w_glow_colorindex,x
        inc
        inc
        sta w_glow_colorindex,x
        
        ply
        rts
    }
    
    
    .spawn: {
        ;y = object id
        ;returns:
        ;x = object index
        ;object spawned, init routine run if spawned
        ;x = $fffe if no slot found
        phb
        
        phk
        plb
        
        ldx #!glow_objects_count*2
        
        -
        lda w_glow_id,x
        beq ..foundslot
        dex
        dex
        bpl -
        
        plb
        rtl
        
        ..foundslot:
        
        tya
        sta w_glow_id,x
        
        lda $0000,y
        sta w_glow_init,x
        
        lda $0002,y
        sta w_glow_routine,x
        
        lda $0004,y
        sta w_glow_list,x
        
        lda w_glow_list,x
        tay
        
        lda $0000,y                 ;timer
        sta w_glow_timer,x
        
        lda $0002,y                 ;starting color index
        sta w_glow_colorindex,x
        sta w_glow_colorindexstart,x
        
        lda w_glow_list,x           ;advance list to first entry
        clc
        adc #$0004
        sta w_glow_list,x
        sta w_glow_liststart,x      ;back this up to easily loop back on loop command
        
        lda w_glow_init,x
        beq +
        jsr (w_glow_init,x)
        +
        
        plb
        rtl
    }
    
    
    .clearall: {
        phb
        
        phk
        plb
        
        ldx.w #!glow_objects_count*2
        
        -
        jsr glow_clear
        dex
        dex
        bpl -
        
        plb
        rtl
    }
    
    
    .clear: {
        ;x = object index
        
        stz w_glow_id,x
        stz w_glow_init,x
        stz w_glow_routine,x
        stz w_glow_timer,x
        stz w_glow_colorindex,x
        stz w_glow_list,x
        stz w_glow_liststart,x
        stz w_glow_colorindexstart,x
        
        rts
    }
    
    
    .runroutines: {
        ldx.w #!glow_objects_count*2
        
        -
        lda w_glow_routine,x
        beq +
        jsr (w_glow_routine,x)
        +
        dex
        dex
        bpl -
        
        rts
    }
}