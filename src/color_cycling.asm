;===========================================================================================
;==================================  COLOR CYCLING =========================================
;======================================= GLOWS =============================================
;===========================================================================================
;===========================================================================================

;unimplemented, untested

;local defines
    !glow_loop  =  $8001
    !glow_done  =  $8000



glow: {
    .top: {
        ;top level handler for color cycling
        
        lda w_glow_enable
        beq +
        
        jsr glow_runroutines
        jsr glow_handleall
        
        +
        rtl
    }
    
    
    .handleall: {
        phb
        
        phk
        plb
        
        ldx.w #!glow_objects_count*2
        
        {                               ;for x = number of slots
            -
            
            lda w_glow_id,x
            beq +
            
            sep #$20
            lda w_glow_timer,x
            dec
            sta w_glow_timer,x
            rep #$20
            bne +
            
            ;if timer is up:
            
            lda w_glow_list,x
            tay
            
            lda $0000,y
            bpl ++
            
            jsr glow_execinstruction    ;if negative, it's an instruction pointer
            bra +
            
            ++
            sta p_0
            jsr glow_writecolors        ;if positive, it's a color
            
            
            +
            
            dex
            dex
            bpl -                       ;next x
        }
        
        plb
        rts
    }
    
    
    .execinstruction: {
        ;x = glow object index
        ;y = instruction list pointer
        
        sta p_3
        jmp (p_3)
    }
    
    
    .inst: {
        ..done: {
            ;x = glow object index
            
            lda w_glow_timer,x
            and #$ff00
            xba
            ora w_glow_timer,x
            sta w_glow_timer,x
            
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
        ;p_0 = pointer to instruction list
        
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
        
        rts
    }
    
    
    .test: {
        dw glow_test_init, glow_test_routine, glow_test_list
        
        ..init: {
            ;
            rts
        }
        
        ..routine: {
            ;
            rts
        }
        
        ..list: {
            dw $0008    ;number of frames (timer nominal value)
            dw $0022    ;starting color index from start of cg ram buffer
                ;the colors
            dw $0802, $0c06, glow_inst_done
            dw $1808, $0c10, glow_inst_done
            dw $2008, $1c12, glow_inst_done
            dw glow_inst_loop
        }
    }
    
    
    .spawn: {
        ;y = object id
        ;returns:
        ;x = object index
        ;object spawned, init routine run if spawned
        ;x = $fffe if no slot found
        
        ldx #!glow_objects_count*2
        
        -
        lda w_glow_id,x
        beq ..foundslot
        dex
        dex
        bpl -
        
        rtl
        
        ..foundslot:
        
        phb
        
        phk
        plb
        
        tya
        sta w_glow_id,x
        
        lda $0000,y
        sta w_glow_init,x
        
        lda $0002,y
        sta w_glow_routine,x
        
        lda $0004,y
        sta w_glow_list,x
        
        jsr (w_glow_init,x)
        
        lda w_glow_list,x
        tay
        
        lda $0000,y                 ;timer
        and #$00ff                  
        sta w_glow_timer,x          ;low byte = current value
        xba
        ora w_glow_timer,x          ;high byte = nominal value
        sta w_glow_timer,x
        
        lda $0002,y                 ;starting color index
        sta w_glow_colorindex,x
        sta w_glow_colorindexstart,x
        
        lda w_glow_list,x           ;advance list to first entry
        clc
        adc #$0004
        sta w_glow_list,x
        sta w_glow_liststart,x      ;back this up to easily loop back on loop command
        
        plb
        rtl
    }
    
    
    .clearall: {
        ldx.w #!glow_objects_count*2
        
        -
        jsr glow_clear
        dex
        dex
        bpl -
        
        rtl
    }
    
    
    .clear: {
        ;x = object index
        
        stz w_glow_id,x
        stz w_glow_init,x
        stz w_glow_routine,x
        stz w_glow_timer,x
        stz w_glow_colorindex,x
        
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