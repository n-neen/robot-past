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
            dw $0008    ;number of frames (timer nominal value)
            dw $0040    ;starting color index from start of cg ram buffer
                ;the colors
            dw $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, glow_inst_done,
               $0000, $2610, $2E89, $39CE, $3E49, $5609, $0400, $2021, $492B, $2108, $3D30, $4A31, $28B1, $20D2, $35B0, $0C48, glow_inst_done,
               $0000, $31CE, $362C, $3590, $35EC, $49EC, $0400, $1C63, $3D8D, $1D27, $358E, $4A6F, $290F, $294F, $3E0E, $1087, glow_inst_done,
               $0000, $3D6B, $41CF, $2D52, $2DAF, $3DAF, $0400, $18A5, $35EE, $1946, $2DEB, $4AAD, $2D8C, $35AD, $464B, $14A6, glow_inst_done,
               $0000, $4929, $4972, $2914, $2552, $3192, $0421, $14E7, $2A50, $1585, $2649, $4AEB, $2DEA, $3E2A, $4EA9, $1CE5, glow_inst_done,
               $0000, $54E7, $5115, $24D6, $1CF5, $2575, $0021, $0D08, $1EB1, $0DA3, $1EA7, $4B29, $2E47, $4687, $56E7, $2123, glow_inst_done,
               $0000, $6084, $5CB8, $1C98, $14B8, $1938, $0021, $094A, $1713, $09C2, $1704, $4B67, $32C5, $5305, $5F44, $2542, glow_inst_done,
               $0000, $7800, $701F, $141D, $041F, $00FF, $0042, $01CE, $03F6, $0220, $07C0, $4BE3, $37A0, $67E0, $6FE0, $31C0, glow_inst_done,
               $0000, $6C42, $645B, $185A, $0C5B, $0D1B, $0021, $058C, $0B74, $05E1, $0F62, $4BA5, $3322, $5B62, $6782, $2981, glow_inst_done,
               $0000, $6084, $5CB8, $1C98, $14B8, $1938, $0021, $094A, $1713, $09C2, $1704, $4B67, $32C5, $5305, $5F44, $2542, glow_inst_done,
               $0000, $54E7, $5115, $24D6, $1CF5, $2575, $0021, $0D08, $1EB1, $0DA3, $1EA7, $4B29, $2E47, $4687, $56E7, $2123, glow_inst_done,
               $0000, $4929, $4972, $2914, $2552, $3192, $0421, $14E7, $2A50, $1585, $2649, $4AEB, $2DEA, $3E2A, $4EA9, $1CE5, glow_inst_done,
               $0000, $3D6B, $41CF, $2D52, $2DAF, $3DAF, $0400, $18A5, $35EE, $1946, $2DEB, $4AAD, $2D8C, $35AD, $464B, $14A6, glow_inst_done,
               $0000, $31CE, $362C, $3590, $35EC, $49EC, $0400, $1C63, $3D8D, $1D27, $358E, $4A6F, $290F, $294F, $3E0E, $1087, glow_inst_done
            
            ;dw $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, glow_inst_done
            ;dw $082A, $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, glow_inst_done
            ;dw $3173, $082A, $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, glow_inst_done
            ;dw $1875, $3173, $082A, $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, glow_inst_done
            ;dw $2854, $1875, $3173, $082A, $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, glow_inst_done
            ;dw $4A14, $2854, $1875, $3173, $082A, $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, glow_inst_done
            ;dw $44F3, $4A14, $2854, $1875, $3173, $082A, $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, glow_inst_done
            ;dw $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, glow_inst_done
            ;dw $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, glow_inst_done
            ;dw $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, $0000, $1E73, $26E6, $422C, $4AA6, $6246, $0800, glow_inst_done
            ;dw $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, $0000, $1E73, $26E6, $422C, $4AA6, $6246, glow_inst_done
            ;dw $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, $0000, $1E73, $26E6, $422C, $4AA6, glow_inst_done
            ;dw $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, $0000, $1E73, $26E6, $422C, glow_inst_done
            ;dw $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, $0000, $1E73, $26E6, glow_inst_done
            ;dw $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, $0000, $1E73, glow_inst_done
            ;dw $1E73, $26E6, $422C, $4AA6, $6246, $0800, $2800, $54CA, $28EA, $44F3, $4A14, $2854, $1875, $3173, $082A, $0000, glow_inst_done
            dw glow_inst_loop
            ;dw glow_clear                      ;this does just work btw
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
    
    
    .animationtest: {
        dw ..init,      ;init
           ..routine,   ;routine
           ..list       ;instruction list
        
        ..init:
            rts
        
        ..routine:
            rts
            
            
        ..list: {
            dw $0004    ;number of frames (timer nominal value)
            dw $01a2    ;starting color index from start of cg ram buffer
            dw $5818, $5C78, $60F9, $657A, $69FB, $6E7C, $72FD, $7FFF, $72FD, $6E7C, $69FB, $657A, $60F9, $5C78, $5818, glow_inst_done,
               $5818, $5818, $5C78, $60F9, $657A, $69FB, $6E7C, $72FD, $7FFF, $72FD, $6E7C, $69FB, $657A, $60F9, $5C78, glow_inst_done,
               $5C78, $5818, $5818, $5C78, $60F9, $657A, $69FB, $6E7C, $72FD, $7FFF, $72FD, $6E7C, $69FB, $657A, $60F9, glow_inst_done,
               $60F9, $5C78, $5818, $5818, $5C78, $60F9, $657A, $69FB, $6E7C, $72FD, $7FFF, $72FD, $6E7C, $69FB, $657A, glow_inst_done,
               $657A, $60F9, $5C78, $5818, $5818, $5C78, $60F9, $657A, $69FB, $6E7C, $72FD, $7FFF, $72FD, $6E7C, $69FB, glow_inst_done,
               $69FB, $657A, $60F9, $5C78, $5818, $5818, $5C78, $60F9, $657A, $69FB, $6E7C, $72FD, $7FFF, $72FD, $6E7C, glow_inst_done,
               $6E7C, $69FB, $657A, $60F9, $5C78, $5818, $5818, $5C78, $60F9, $657A, $69FB, $6E7C, $72FD, $7FFF, $72FD, glow_inst_done,
               $72FD, $6E7C, $69FB, $657A, $60F9, $5C78, $5818, $5818, $5C78, $60F9, $657A, $69FB, $6E7C, $72FD, $7FFF, glow_inst_done,
               $7FFF, $72FD, $6E7C, $69FB, $657A, $60F9, $5C78, $5818, $5818, $5C78, $60F9, $657A, $69FB, $6E7C, $72FD, glow_inst_done,
               $72FD, $7FFF, $72FD, $6E7C, $69FB, $657A, $60F9, $5C78, $5818, $5818, $5C78, $60F9, $657A, $69FB, $6E7C, glow_inst_done,
               $6E7C, $72FD, $7FFF, $72FD, $6E7C, $69FB, $657A, $60F9, $5C78, $5818, $5818, $5C78, $60F9, $657A, $69FB, glow_inst_done,
               $69FB, $6E7C, $72FD, $7FFF, $72FD, $6E7C, $69FB, $657A, $60F9, $5C78, $5818, $5818, $5C78, $60F9, $657A, glow_inst_done,
               $657A, $69FB, $6E7C, $72FD, $7FFF, $72FD, $6E7C, $69FB, $657A, $60F9, $5C78, $5818, $5818, $5C78, $60F9, glow_inst_done,
               $60F9, $657A, $69FB, $6E7C, $72FD, $7FFF, $72FD, $6E7C, $69FB, $657A, $60F9, $5C78, $5818, $5818, $5C78, glow_inst_done,
               $5C78, $60F9, $657A, $69FB, $6E7C, $72FD, $7FFF, $72FD, $6E7C, $69FB, $657A, $60F9, $5C78, $5818, $5818, glow_inst_done
            dw glow_inst_loop
        }
    }
    
    
    .playerhurt: {
        dw  ..init,      ;init
            ..routine,   ;routine
            ..list       ;instruction list
            
        ..init:
            lda #!player_hurt_cooldown_default
            sta w_player_hurtglowcooldown
            rts
            
        ..routine:
            rts
            
        ..list: {
            dw $0002    ;number of frames (timer nominal value)
            dw $0180    ;starting color index from start of cg ram buffer
            dw $3838, $7FFF, $0000, $7BD2, $7BCA, $7BC2, $7BC6, $7B46, $7B5A, $7B4A, $7B56, $7AD6, $7B52, $7A4A, $7C1F, $7AC6, glow_inst_done,
               $30B8, $77F9, $04A3, $73D3, $73CC, $73C6, $6BAA, $7749, $6B5A, $6B2D, $6737, $6AD7, $6B34, $726D, $6419, $7AEA, glow_inst_done,
               $2D59, $6FF4, $0D47, $6BD5, $6FCE, $6FCA, $5FAE, $736D, $5B5B, $5B30, $5318, $5ED8, $5F36, $6A90, $5014, $7B2E, glow_inst_done,
               $29FA, $6BEF, $15EB, $63D7, $6BD1, $6BCF, $53B2, $7390, $4B5C, $4B14, $42FA, $52FA, $5338, $62D4, $3C0F, $7B52, glow_inst_done,
               $229B, $63EA, $1A8F, $5BD9, $63D3, $63D3, $4396, $6F94, $3B5C, $3B17, $2EDB, $42FB, $431A, $5AF7, $280A, $7B96, glow_inst_done,
               $1BDD, $57E0, $2BD7, $4BDD, $5BD8, $5BDC, $2B9E, $6BDB, $1B7E, $1AFE, $0ABE, $2B1E, $2B1E, $4B5E, $0000, $7FFF, glow_inst_done,
               $1F3C, $5BE5, $2333, $53DB, $5FD5, $5FD7, $379A, $6BB7, $2B5D, $2AFA, $1ABC, $36FC, $371C, $531A, $1405, $7BBA, glow_inst_done,
               $229B, $63EA, $1A8F, $5BD9, $63D3, $63D3, $4396, $6F94, $3B5C, $3B17, $2EDB, $42FB, $431A, $5AF7, $280A, $7B96, glow_inst_done,
               $29FA, $6BEF, $15EB, $63D7, $6BD1, $6BCF, $53B2, $7390, $4B5C, $4B14, $42FA, $52FA, $5338, $62D4, $3C0F, $7B52, glow_inst_done,
               $2D59, $6FF4, $0D47, $6BD5, $6FCE, $6FCA, $5FAE, $736D, $5B5B, $5B30, $5318, $5ED8, $5F36, $6A90, $5014, $7B2E, glow_inst_done,
               $3838, $7FFF, $0000, $7BD2, $7BCA, $7BC2, $7BC6, $7B46, $7B5A, $7B4A, $7B56, $7AD6, $7B52, $7A4A, $7C1F, $7AC6, glow_inst_done
            dw glow_clear
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