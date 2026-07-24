;===========================================================================================
;==================================  COLOR CYCLING =========================================
;======================================= GLOWS =============================================
;===========================================================================================
;===========================================================================================

;finally works



glow: {
    .top: {
        ;top level handler for color cycling
        
        phk
        plb
        
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
        
        lda #bank(glow)
        sta p_2
        
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
    
    
    .title: {
        dw glow_title_init, glow_title_routine, glow_title_list
        
        ..init: {
            ;
            rts
        }
        
        ..routine: {
            ;
            rts
        }
        
        ..list: {
            dw $0004    ;number of frames (timer nominal value)
            dw $0028    ;starting color index from start of cg ram buffer
                ;the colors
            ;dw $7BFF, $7E40, glow_inst_done
            dw $77DE, $7A20, glow_inst_done
            dw $73BD, $7201, glow_inst_done
            dw $73BD, $6E01, glow_inst_done
            dw $6F9C, $69E2, glow_inst_done
            dw $6F7B, $65E2, glow_inst_done
            dw $6B7B, $61C3, glow_inst_done
            dw $6B5A, $5DA3, glow_inst_done
            dw $6739, $59A4, glow_inst_done
            dw $6739, $5584, glow_inst_done
            dw $6318, $5185, glow_inst_done
            dw $6318, $4D65, glow_inst_done
            dw $5EF7, $4946, glow_inst_done
            dw $5ED6, $4546, glow_inst_done
            dw $5AD6, $4127, glow_inst_done
            dw $5AB5, $3D28, glow_inst_done
            dw $5694, $3908, glow_inst_done
            dw $5294, $34E9, glow_inst_done
            dw $5273, $30E9, glow_inst_done
            dw $4E73, $2CCA, glow_inst_done
            dw $4E52, $28CA, glow_inst_done
            dw $4A31, $24AB, glow_inst_done
            dw $4A31, $208B, glow_inst_done
            dw $4610, $1C8C, glow_inst_done
            dw $45EF, $186C, glow_inst_done
            dw $41EF, $146D, glow_inst_done
            dw $41CE, $104D, glow_inst_done
            dw $3DAD, $0C2E, glow_inst_done
            dw $3DAD, $082E, glow_inst_done
            dw $398C, $0010, glow_inst_done
            dw $398C, $040F, glow_inst_done
            dw $3DAD, $082E, glow_inst_done
            dw $3DAD, $0C2E, glow_inst_done
            dw $41CE, $104D, glow_inst_done
            dw $41EF, $146D, glow_inst_done
            dw $45EF, $186C, glow_inst_done
            dw $4610, $1C8C, glow_inst_done
            dw $4A31, $208B, glow_inst_done
            dw $4A31, $24AB, glow_inst_done
            dw $4E52, $28CA, glow_inst_done
            dw $4E73, $2CCA, glow_inst_done
            dw $5273, $30E9, glow_inst_done
            dw $5294, $34E9, glow_inst_done
            dw $5694, $3908, glow_inst_done
            dw $5AB5, $3D28, glow_inst_done
            dw $5AD6, $4127, glow_inst_done
            dw $5ED6, $4546, glow_inst_done
            dw $5EF7, $4946, glow_inst_done
            dw $6318, $4D65, glow_inst_done
            dw $6318, $5185, glow_inst_done
            dw $6739, $5584, glow_inst_done
            dw $6739, $59A4, glow_inst_done
            dw $6B5A, $5DA3, glow_inst_done
            dw $6B7B, $61C3, glow_inst_done
            dw $6F7B, $65E2, glow_inst_done
            dw $6F9C, $69E2, glow_inst_done
            dw $73BD, $6E01, glow_inst_done
            dw $73BD, $7201, glow_inst_done
            dw glow_inst_loop
        }
    }
    
    
    .shot: {
        dw glow_shot_init, glow_shot_routine, glow_shot_list
        
        ..init: {
            ;find out if shots exist?
            rts
        }
        
        ..routine: {
            ;delete if no shots?
            rts
            
            phx
            phy
            
            ;uhhh
            ;get max shot index
            ;check if slot taken
            ldy #!shot_count*2
            lda w_shot_id,y
            bne +
            
            jsr glow_clear
            
            +
            ply
            plx
            rts
        }
        
        ..list: {
            dw $000a    ;number of frames (timer nominal value)
            dw $01e2    ;starting index from start of cg ram buffer
                ;the colors
            dw $7fff, $0000, glow_inst_done
            dw $0000, $7fff, glow_inst_done
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