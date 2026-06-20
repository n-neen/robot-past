;===========================================================================================
;======================================= PLAYER ============================================
;===========================================================================================

;need sprite system

player: {
    .init: {
        lda w_level_playerstartx
        sta w_player_x
        
        lda w_level_playerstarty
        sta w_player_y
        
        lda #!player_xsize_default
        sta w_player_xsize
        
        lda #!player_ysize_default
        sta w_player_ysize
        
        ;jsr player_olddraw             ;test sprite not real
        jsr player_draw
        
        rtl
    }
    
    
    .calchitbox: {
        phb
        
        phk
        plb
        
        lda w_player_x              ;player x - x size = left bound
        sec
        sbc w_player_xsize
        sta w_player_hitboxleft
        
        lda w_player_x              ;player x + x size = right bound
        clc
        adc w_player_xsize
        sta w_player_hitboxright
        
        lda w_player_y              ;player y + y size = bottom bound
        clc
        adc w_player_ysize
        sta w_player_hitboxbottom
        
        lda w_player_y              ;player y + y size = top bound
        sec
        sbc w_player_ysize
        sta w_player_hitboxtop
        
        plb
        rtl
    }
    
    
    .hitboxsize: {
        lda w_player_direction
        beq +
        
        lda #!player_xsize_default-4        ;if moving... why is subtracting making it bigger?
        sta w_player_xsize
        
        lda #!player_ysize_default-4
        sta w_player_ysize
        
        rts
        
        +
        lda #!player_xsize_default          ;if not moving
        sta w_player_xsize
        
        lda #!player_ysize_default
        sta w_player_ysize
        
        rts
    }
    
    .locateontile: {
        ;db=pb
        
        ;(player_y/8)*level_width+(player_x/8)
        
        ;this returns a tile index into l_level_collision
        ;to be used to do collision huh
        ;if you wanted, could get tile x,y by saving these right-shifted values below
        
        lda w_player_x
        lsr
        lsr
        lsr
        sta p_0             ;player x pixel position/8 = player x tile position
        
        lda w_player_y
        lsr
        lsr
        lsr                 ;player x pixel position/8
        
        sep #$20
        
        sta $4202
        
        lda.b #!level_width ;player y*level width
        sta $4203
        
        rep #$20
        nop #8
        
        lda $4216
        
        clc
        adc p_0             ;+ player x
        
        sta w_player_tileindex
        
        rts
    }
    
    
    
    .main: {
        phk
        plb
        
        jsr player_input            ;get input. adds direction bits to w_player_direction
        jsr player_hitboxsize       ;make hitbox bigger if moving
        jsr player_boundscheck      ;hardcoded test harness for level bounds
        jsr player_locateontile     ;translate player pixel position into tile index
        jsr player_collision        ;removes direction bits from w_player_direction (is what i would say if this worked)
        jsr player_applyvelocity    ;use subspeed and speed to affect player position
        jsr player_decelerate       ;use the same to do the same (but inverse, if dpad not held)
        
        lda w_player_direction
        jsr player_move             ;move in the directions of remaining direction bits
        
        ;locate player on screen
        
        lda w_player_x
        sec
        sbc w_level_camerax
        sta w_player_x_onscreen
        
        lda w_player_y
        sec
        sbc w_level_cameray
        sta w_player_y_onscreen
        
        ;then draw
        jsr player_draw
        ;jsr player_olddraw
        
        rtl
    }
    
    
    .decelerate: {
        lda w_player_direction
        bne ..return
        
        lda w_player_xspeed
        bmi +
        lda #!controller_lf
        jsr player_move
        +
        
        lda w_player_xspeed
        bpl +
        lda #!controller_rt
        jsr player_move
        +
        
        lda w_player_yspeed
        bmi +
        lda #!controller_up
        jsr player_move
        +
        
        lda w_player_yspeed
        bpl +
        lda #!controller_dn
        jsr player_move
        +
        
        
        ..return
        rts
    }
    
    
    .applyvelocity: {
        ..y
        
            lda w_player_suby
            clc
            adc w_player_ysubspeed
            sta w_player_suby
            
            lda w_player_y
            adc w_player_yspeed
            sta w_player_y
        
        ..x
        
            lda w_player_subx
            clc
            adc w_player_xsubspeed
            sta w_player_subx
            
            lda w_player_x
            adc w_player_xspeed
            sta w_player_x
        
        rts
    }
    
    
    .move: {
        ;A = direction bits
        
        bit #!controller_up
        beq +
        {
            pha
            jsr player_move_up
            pla
        }
        +
        
        bit #!controller_dn
        beq +
        {
            pha
            jsr player_move_down
            pla
        }
        +
        
        bit #!controller_lf
        beq +
        {
            pha
            jsr player_move_left
            pla
        }
        +
        
        
        bit #!controller_rt
        beq +
        {
            pha
            jsr player_move_right
            pla
        }
        +
        
        rts
        
        ..up: {
            lda w_player_yspeed
            cmp.w #-!player_max_speed
            bmi ...skip
            
            lda w_player_ysubspeed
            sec
            sbc #!player_y_subvelocity
            sta w_player_ysubspeed
            
            lda w_player_yspeed
            sbc #!player_y_velocity
            sta w_player_yspeed
            
            ...skip
            
            rts
        }
        
        ..down: {
            lda w_player_yspeed
            cmp.w #!player_max_speed
            bpl ...skip
            
            lda w_player_ysubspeed
            clc
            adc #!player_y_subvelocity
            sta w_player_ysubspeed
            
            lda w_player_yspeed
            adc #!player_y_velocity
            sta w_player_yspeed 
            
            ...skip
            
            rts
        }
        
        ..right: {
            lda w_player_xspeed
            cmp.w #!player_max_speed
            bpl ...skip
            
            lda w_player_xsubspeed
            clc
            adc #!player_x_subvelocity
            sta w_player_xsubspeed
            
            lda w_player_xspeed
            adc #!player_x_velocity
            sta w_player_xspeed
            
            ...skip
            
            rts
        }
        
        ..left: {
            lda w_player_xspeed
            cmp.w #-!player_max_speed
            bmi ...skip
            
            lda w_player_xsubspeed
            sec
            sbc #!player_x_subvelocity
            sta w_player_xsubspeed
            
            lda w_player_xspeed
            sbc #!player_x_velocity
            sta w_player_xspeed
            
            ...skip
            
            rts
        }
    }
    
    .collision: {
        ;lda w_player_collisiontype
        ;asl
        ;tax
        
        lda w_player_tileindex
        and #$00ff
        tax
        lda.l l_level_collision,x
        asl
        tax
        
        jsr (player_collision_table,x)
        
        rts
        
        ..table: {
            dw player_collision_air             ;0
            dw player_collision_preventup       ;1
            dw player_collision_preventdown     ;2
            dw player_collision_preventleft     ;3
            dw player_collision_preventright    ;4
            dw player_collision_solid           ;5
        }
        
        ..air: {
            
            rts
        }
        
        ..solid: {
            stz w_player_xspeed
            stz w_player_yspeed
            
            ;lda w_player_yspeed
            ;eor #$ffff
            ;inc
            ;sta w_player_yspeed
            
            ;lda w_player_xspeed
            ;eor #$ffff
            ;inc
            ;sta w_player_xspeed

            rts
        }
        
        ..preventup: {
            lda w_player_direction
            and #($ffff^!controller_up)
            sta w_player_direction
            
            rts
        }
        
        ..preventdown: {
            lda w_player_direction
            and #($ffff^!controller_dn)
            sta w_player_direction
            
            rts
        }
        
        ..preventleft: {
            lda w_player_direction
            and #($ffff^!controller_lf)
            sta w_player_direction
            
            rts
        }
        
        ..preventright: {
            lda w_player_direction
            and #($ffff^!controller_rt)
            sta w_player_direction
            
            rts
        }
    }
    
    
    .boundscheck: {
        ;todo: add level bounds to level metadata
        
        lda w_player_x          ;left bound
        cmp #$0004
        bpl +
        {
            lda #$0004
            sta w_player_x
            
            lda w_player_xspeed
            eor #$ffff
            inc
            sta w_player_xspeed
        }
        +
        
        lda w_player_x          ;right bound
        cmp #$01f0
        bmi +
        {
            lda #$01f0
            sta w_player_x
            
            lda w_player_xspeed
            eor #$ffff
            inc
            sta w_player_xspeed
        }
        +
        
        lda w_player_y          ;top bound
        cmp #$0004
        bpl +
        {
            lda #$0004
            sta w_player_y
            
            lda w_player_yspeed
            eor #$ffff
            inc
            sta w_player_yspeed
        }
        +
        
        lda w_player_y          ;bottom bound
        cmp #$01d0
        bmi +
        {
            lda #$01d0
            sta w_player_y
            
            lda w_player_yspeed
            eor #$ffff
            inc
            sta w_player_yspeed
        }
        +
        
        rts
    }
    
    
    .input: {
        lda w_controller
        
        bit #!controller_up
        beq ..noup
        {
            ;if up pressed
            pha
            
            lda w_player_direction      ;add up to the direction
            ora #!controller_up
            sta w_player_direction
            
            pla
        }
        ..noup:
        
        bit #!controller_dn
        beq ..nodn
        {
            ;if dn pressed
            pha
            
            lda w_player_direction      ;add down to the direction
            ora #!controller_dn
            sta w_player_direction
            
            pla
        }
        ..nodn:
        
        bit #!controller_lf
        beq ..nolf
        {
            ;if lf pressed
            pha
            
            lda w_player_direction      ;add left to the direction
            ora #!controller_lf
            sta w_player_direction
            
            pla
        }
        ..nolf:
        
        bit #!controller_rt
        beq ..nort
        {
            ;if rt pressed
            pha
            
            lda w_player_direction      ;add rt to the direction
            ora #!controller_rt
            sta w_player_direction
            
            pla
        }
        ..nort:
        
        bit #!controller_b
        beq ..nob
        {
            ;if b pressed, stop moving
            pha
            
            stz w_player_xspeed
            stz w_player_yspeed
            
            stz w_player_ysubspeed
            stz w_player_ysubspeed
            
            stz w_player_suby
            stz w_player_subx
            
            stz w_player_direction
            
            pla
        }
        ..nob:
        
        bit #!controller_x
        beq ..nox
        {
            ;if x pressed
            
            pha
            
            sep #$20
            {
                ;uhhhhhhhhhhhhhhh
            }
            rep #$20
            
            pla
        }
        ..nox:
        
        bit #!controller_y
        beq ..noy
        {
            ;if y pressed,
            pha
            
            jsr player_decelerate
            jsr player_decelerate
            
            pla
        }
        ..noy:
        
        bit #!controller_a
        beq ..noa
        {
            ;if a pressed
            pha
            
            jsl msg_reset
            jsl layer3off_long
            
            pla
        }
        ..noa:
        
        
        
        
        rts
    }
    
    .olddraw: {
        sep #$20
        
        ldx #$0000
        
        phk
        plb
        
        lda w_nmicounter
        bit #$07
        bne +
        
        lda w_player_animationtimer
        inc
        sta w_player_animationtimer
        cmp #$08
        bmi +
        stz w_player_animationtimer
        lda #$00
        +
        ldy w_player_animationtimer
        
        lda w_player_x_onscreen
        sta w_oam_lo_buffer,x       ;x pos
        inx
        
        lda w_player_y_onscreen
        sta w_oam_lo_buffer,x       ;y pos
        inx
        
        
        rep #$20
        lda w_player_direction
        bit #!controller_lf|!controller_rt
        bne ..h
        lda player_olddraw_animationlist_vert,y
        bra ..v
        ..h
        lda player_olddraw_animationlist_horz,y
        ..v
        sep #$20
        
        sta w_oam_lo_buffer,x       ;tile
        inx
        
        lda #%00111110              ;properties
        sta w_oam_lo_buffer,x
        inx
        
        ;stx oamindex
        
        rep #$20
        
        rts
        
        ..animationlist_vert: {
            db $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8
        }
        
        ..animationlist_horz: {
            db $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8
        }
    }
    
    
    
    
    .draw: {
        ;just wrote, not yet debugged
        ;whole routine is sep #$20 except where indented
        
        phb
        phx
        phy
        
        phk
        plb
        
        ldx #$0000
        
        lda w_nmicounter
        bit #$0007
        bne +
        
        lda w_player_animationtimer             ;timer cycling 0-8
        inc
        sta w_player_animationtimer
        cmp #$0008
        bmi +
        stz w_player_animationtimer
        lda #$0000
        +
        lda w_player_animationtimer             ;y = index for spritemap lists
        asl
        tay
        
        lda w_player_direction
        bit #!controller_lf|!controller_rt
        bne ..h
        lda player_spritemaplist_vertical,y
        bra ..v
        ..h
        lda player_spritemaplist_horizontal,y
        ..v
        
        tay                                     ;y = ptr to spritemap
        
        lda $0000,y
        sta p_0                                 ;number of sprites to draw
        iny                                     ;y = pointer to first spritemap
        
        ..nextsprite
        
        lda $0000,y
        and #$00ff
        clc
        adc w_player_x_onscreen
        sta w_oam_lo_buffer,x       ;x pos
        
        lda $0001,y
        and #$00ff
        clc
        adc w_player_y_onscreen
        sta w_oam_lo_buffer+1,x     ;y pos
        
        lda $0002,y
        and #$00ff
        sta w_oam_lo_buffer+2,x     ;tile
        
        lda $0003,y                 ;properties
        and #$00ff
        sta w_oam_lo_buffer+3,x
        
        iny                         ;y=y+5 (next spritemap)
        iny
        iny
        iny
        iny
        
        inx                         ;x=x+4 (next oam entry)
        inx
        inx
        inx
        dec p_0
        bne ..nextsprite
        
        stx w_oam_index
        
        rep #$20
        
        ply
        plx
        plb
        rts
        
        ..animationlist_vert: {
            db $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8
        }
        
        ..animationlist_horz: {
            db $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8
        }
    }
    
    .spritemaplist: {
        ..vertical
            dw player_spritemap_0
            dw player_spritemap_1
            dw player_spritemap_2
            dw player_spritemap_3
            dw player_spritemap_4
            dw player_spritemap_5
            dw player_spritemap_6
            dw player_spritemap_7
            dw player_spritemap_8
        ..horizontal
            dw player_spritemap_9
            dw player_spritemap_10
            dw player_spritemap_11
            dw player_spritemap_12
            dw player_spritemap_13
            dw player_spritemap_14
            dw player_spritemap_15
            dw player_spritemap_16
            dw player_spritemap_17
    }
    
    
    .spritemap: {
        ; xx yy tt pp hh
        ; ^  ^  ^  ^  ^
        ; x  ^  ^  ^  high table bits
        ;    y  ^  properties
        ;       tile
        ;
        
        ;vertical ====================================================================================
        ..0: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $c0, %00111110, $00
        }
        
        ..1: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $c1, %00111110, $00
        }
        
        ..2: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $c2, %00111110, $00
        }
        
        ..3: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $c3, %00111110, $00
        }
        
        ..4: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $c4, %00111110, $00
        }
        
        ..5: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $c5, %00111110, $00
        }
        
        ..6: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $c6, %00111110, $00
        }
        
        ..7: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $c7, %00111110, $00
        }
        
        ..8: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $c8, %00111110, $00
        }
        
        ;horizontal ====================================================================================
        
        ..9: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $d0, %00111110, $00
        }
        
        ..10: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $d1, %00111110, $00
        }
        
        ..11: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $d2, %00111110, $00
        }
        
        ..12: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $d3, %00111110, $00
        }
        
        ..13: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $d4, %00111110, $00
        }
        
        ..14: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $d5, %00111110, $00
        }
        
        ..15: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $d6, %00111110, $00
        }
        
        ..16: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $d7, %00111110, $00
        }
        
        ..17: {
            ;number of sprites
            db $01
             ;  xx   yy   tt   pp         hh
            db $00, $00, $d8, %00111110, $00
        }
        
    }
}

