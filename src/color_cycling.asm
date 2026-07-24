;===========================================================================================
;==================================  COLOR CYCLING =========================================
;======================================= GLOWS =============================================
;===========================================================================================
;===========================================================================================

;unimplemented, untested
;i think this is broken as shit

;local defines
    !glow_loop  =  $8001
    !glow_done  =  $8000



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
    
    ;print pc
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
            dw $0002    ;number of frames (timer nominal value)
            dw $0020    ;starting color index from start of cg ram buffer
                ;the colors
            dw $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, glow_inst_done
            dw $0000, $1E52, $26C7, $3E0C, $4687, $5A47, $0400, $2400, $50E9, $24E9, $44F2, $4A13, $2852, $1C73, $3172, $0829, glow_inst_done
            dw $0000, $2232, $2688, $3E0C, $4267, $5648, $0400, $2020, $4CE9, $24E9, $4111, $4A13, $2C71, $1C92, $3172, $0C28, glow_inst_done
            dw $0000, $2612, $2669, $3E0D, $3E68, $5269, $0400, $2020, $4909, $24E9, $4130, $4A13, $2C90, $2091, $3571, $0C28, glow_inst_done
            dw $0000, $2A11, $264A, $3E0D, $3E49, $4E6A, $0400, $1C40, $4529, $24E9, $4150, $4A13, $30AF, $24B0, $3591, $1047, glow_inst_done
            dw $0000, $29F1, $262B, $3A0D, $3A4A, $4A6B, $0400, $1861, $4149, $2509, $414F, $4A32, $34CE, $28AF, $3990, $1047, glow_inst_done
            dw $0000, $2DD1, $260C, $39ED, $362B, $466C, $0400, $1861, $3D68, $2508, $416E, $4A32, $34ED, $2CCE, $3990, $1446, glow_inst_done
            dw $0000, $31B0, $25ED, $39EE, $322C, $428D, $0400, $1481, $3988, $2508, $418D, $4A32, $390C, $30ED, $3D8F, $1446, glow_inst_done
            dw $0000, $35B0, $25CE, $39EE, $320D, $3E8F, $0420, $14A1, $35A8, $2508, $41AD, $4E32, $3D2B, $34EC, $3DAF, $1865, glow_inst_done
            dw $0000, $3590, $25AF, $35EE, $2E0E, $3690, $0020, $10A1, $31C8, $2108, $41AC, $4E31, $3D29, $390A, $41AE, $1865, glow_inst_done
            dw $0000, $396F, $2590, $35EF, $29EF, $32B1, $0020, $0CC1, $2DE8, $2108, $41CB, $4E31, $4148, $3D09, $41AE, $1C64, glow_inst_done
            dw $0000, $3D4F, $2571, $35EF, $25D0, $2EB2, $0020, $0CC2, $2A08, $2128, $41EA, $4E51, $4167, $4128, $41AD, $1C63, glow_inst_done
            dw $0000, $414F, $2552, $35CF, $25D1, $2AB3, $0020, $08E2, $2627, $2127, $420A, $4E51, $4586, $4527, $45CD, $2083, glow_inst_done
            dw $0000, $412F, $2533, $31D0, $21B2, $26D4, $0020, $0502, $2247, $2127, $4209, $4E50, $49A5, $4946, $45CC, $2082, glow_inst_done
            dw $0000, $450E, $2514, $31D0, $1DB3, $22D5, $0020, $0502, $1E67, $2127, $4228, $4E50, $49C4, $4D45, $49CC, $2482, glow_inst_done
            dw $0000, $4CEE, $24D7, $31D1, $1995, $1AF8, $0040, $0143, $1AA7, $2147, $4267, $5270, $5202, $5583, $4DEB, $28A1, glow_inst_done
            dw $0000, $450E, $2514, $31D0, $1DB3, $22D5, $0020, $0502, $1E67, $2127, $4228, $4E50, $49C4, $4D45, $49CC, $2482, glow_inst_done
            dw $0000, $412F, $2533, $31D0, $21B2, $26D4, $0020, $0502, $2247, $2127, $4209, $4E50, $49A5, $4946, $45CC, $2082, glow_inst_done
            dw $0000, $414F, $2552, $35CF, $25D1, $2AB3, $0020, $08E2, $2627, $2127, $420A, $4E51, $4586, $4527, $45CD, $2083, glow_inst_done
            dw $0000, $3D4F, $2571, $35EF, $25D0, $2EB2, $0020, $0CC2, $2A08, $2128, $41EA, $4E51, $4167, $4128, $41AD, $1C63, glow_inst_done
            dw $0000, $396F, $2590, $35EF, $29EF, $32B1, $0020, $0CC1, $2DE8, $2108, $41CB, $4E31, $4148, $3D09, $41AE, $1C64, glow_inst_done
            dw $0000, $3590, $25AF, $35EE, $2E0E, $3690, $0020, $10A1, $31C8, $2108, $41AC, $4E31, $3D29, $390A, $41AE, $1865, glow_inst_done
            dw $0000, $35B0, $25CE, $39EE, $320D, $3E8F, $0420, $14A1, $35A8, $2508, $41AD, $4E32, $3D2B, $34EC, $3DAF, $1865, glow_inst_done
            dw $0000, $31B0, $25ED, $39EE, $322C, $428D, $0400, $1481, $3988, $2508, $418D, $4A32, $390C, $30ED, $3D8F, $1446, glow_inst_done
            dw $0000, $2DD1, $260C, $39ED, $362B, $466C, $0400, $1861, $3D68, $2508, $416E, $4A32, $34ED, $2CCE, $3990, $1446, glow_inst_done
            dw $0000, $29F1, $262B, $3A0D, $3A4A, $4A6B, $0400, $1861, $4149, $2509, $414F, $4A32, $34CE, $28AF, $3990, $1047, glow_inst_done
            dw $0000, $2A11, $264A, $3E0D, $3E49, $4E6A, $0400, $1C40, $4529, $24E9, $4150, $4A13, $30AF, $24B0, $3591, $1047, glow_inst_done
            dw $0000, $2612, $2669, $3E0D, $3E68, $5269, $0400, $2020, $4909, $24E9, $4130, $4A13, $2C90, $2091, $3571, $0C28, glow_inst_done
            dw $0000, $2232, $2688, $3E0C, $4267, $5648, $0400, $2020, $4CE9, $24E9, $4111, $4A13, $2C71, $1C92, $3172, $0C28, glow_inst_done
            dw $0000, $1E52, $26C7, $3E0C, $4687, $5A47, $0400, $2400, $50E9, $24E9, $44F2, $4A13, $2852, $1C73, $3172, $0829, glow_inst_done
            dw $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, glow_inst_done
            dw glow_inst_loop
        }
    }
    ;print pc
    
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