msg: {
    .display: {
        ;x = message pointer
        ;y = starting line
        
        ;used in routine
        ;p_0 = long pointer to string
        
        stx p_0
        
        lda #((str&$ff0000)>>16)    ;text string bank
        sta p_2
        
        tya
        asl
        asl
        asl
        asl
        asl
        asl
        sta w_msg_start
        tax                     ;x = starting index in tilemap (line * 32)*2 again for tilemap (2 bytes per tile)
        ldy #$0000              ;y = starting index in source text
        
        -
        lda [p_0],y
        and #$00ff
        beq ..done
        
        cmp #$0020                      ;characters < $20 are control characters
        bpl ..notcontrol
        jsr msg_handlecontrolchars
        bra +
        ..notcontrol:
        
        sec
        sbc #$0020                      ;align ascii with tiles
        ora #$2000                      ;add priority bit
        sta.l w_msgbuffer,x             ;write to ram. possibly hirom area so needs this
        
        
        {   ;use this if you want to type out one character per frame
            phy
            phx
            
            lda #$0001
            sta w_msg_uploadflag
            txa
            inc
            inc
            sta w_msg_size
            jsl waitfornmi_long
            
            ;jsl gameplay                ;could call gameplay here too
            ;jsl gameplay_shadow         ;this is a better idea but still not ideal
            
            ;maybe gameplay and scene handler both have shadow modes?
            ;scene handler doesn't need to do anyhting else, so i think gameplay
            ;is the only one that needs this
            
            plx
            ply
        }
        
        inx
        inx
        +
        iny     ;if it was a control character, inc source index but not destination index
        bra -
        
        
        ..done:
        
        ;stx w_msg_size
        rtl
    }
    
    
    .handlecontrolchars: {
        ;low byte of A = ascii character
        ;   (control characters are under $20)
        ;x = tilemap index
        ;y = source text index
        
        cmp.w #!msg_newline
        bne +
        
        ;if newline:
        
        pha
        txa
        
        clc
        adc #$0040      ;add $20*2 (two bytes of tilemap) to go down a line
        and #$ffc0      ;remove bits lower than $40 to align to left
        
        tax
        pla
        
        +
        rts
    }
    
    
    .reset: {
        jsl msg_cleartilemap
        
        lda #$0001
        sta w_msg_uploadflag
        lda #$0800
        sta w_msg_size
        
        jsl layer3off_long
        
        rtl
    }
    
    
    .cleartilemap: {
        pea.w (($ff0000&w_msgbuffer)>>8)+0     ;db = message buffer bank (7e)
        plb
        plb
        
        ldx #$0100
        
        -
        stz.w w_msgbuffer,x
        stz.w w_msgbuffer+$100,x
        stz.w w_msgbuffer+$200,x
        stz.w w_msgbuffer+$300,x
        stz.w w_msgbuffer+$400,x
        stz.w w_msgbuffer+$500,x
        stz.w w_msgbuffer+$600,x
        stz.w w_msgbuffer+$700,x
        dex
        dex
        bpl -
        
        rtl
    }

    
    
    .upload: {
        lda #(!bg3tilemap)
        sta w_dmabaseaddr
        
        lda.w #w_msgbuffer
        sta w_dmasrcptr
        
        lda.w #(($ff0000&w_msgbuffer)>>16)+0
        sta w_dmasrcbank
        
        lda w_msg_size
        sta w_dmasize
        
        jsl dma_vramtransfur
        
        rtl
    }
    
    
    .scroll: {
        ..main: {
            phk
            plb
            
            ;maybe this wrapping doesn't make sense right now
            ;but eventually we'll need a state machine here
            ;for wait, scroll up, and end scrolling
            ;(and it won't use the controller anymore)
            ;this scrolling routine can't really handle more than one pixel per frame speed
            ;(i tested two and three pixels per frame and it broke)
            ;i think, anyway. it could probably handle less, if you write the speed/subspeed
            
            ;jsr msg_scroll_input
            
            lda w_scene_timer
            cmp #!scrolling_text_delay
            bmi +
            
            lda w_bg3yscroll
            inc
            and #$00ff
            sta w_bg3yscroll
            
            lda w_msg_scrollpixels
            inc
            sta w_msg_scrollpixels
            
            jsr msg_scroll_seam
            
            +
            rtl
        }
        
        ..input: {
            lda w_controller
            and #(!controller_up|!controller_dn)
            
            bit #!controller_up
            beq +
            {
                ;if up pressed
                pha
                jsr msg_scroll_up
                pla
            }
            +
            
            bit #!controller_dn
            beq +
            {
                ;if down pressed
                pha
                jsr msg_scroll_down
                pla
            }
            +
            
            rts
        }
        
        
        ..up: {
            lda w_bg3yscroll
            dec
            and #$00ff
            sta w_bg3yscroll
            
            ldx #$3863              ;tile to fill rows with while scrolling up
            stx p_0
            jsr msg_scroll_seam
            
            rts
        }
        
        
        ..down: {
            lda w_bg3yscroll
            inc
            and #$00ff
            sta w_bg3yscroll
            
            ldx #$2000              ;high priority nothin
            stx p_0
            jsr msg_scroll_seam
            
            rts
        }
        
        ..writeline: {
            ;w_bg3yscroll will be 1 less than having the $0008 bit
            ;x = index into w_msgbuffer
            ;y is free to use
            
            ;print pc
            
            lda w_scene_scrolltextptr       ;check if this matches a prescribed line for writing
            sta p_0
            
            lda #bank(str)
            sta p_2
            
            ldy w_msg_scrollindex
            
            lda w_msg_scrollpixels
            inc
            lsr
            lsr
            lsr                             ;(w_bg3yscroll+1)/8 = text line
            cmp [p_0],y
            bne ...clearline
            
            ;we have a line count match
            ;p_0 contains long pointer to the line count. string pointer is the word after that
            lda [p_0],y
            inc p_0
            inc p_0
            lda [p_0],y
            sta p_0                         ;p_0 now long pointer to string
            
            inx                             ;off by one character somehow
            inx
            
            ldy #$0000
            -
            lda [p_0],y
            and #$00ff
            beq ...finishline
            sec
            sbc #$0020
            ora #$2000
            sta w_msgbuffer,x
            ...next
            inx
            inx
            iny
            cpy #$0020
            bne -
            
            lda w_msg_scrollindex
            clc
            adc #$0004
            sta w_msg_scrollindex
            
            +
            rts
            
            ...clearline:
            
            inx
            inx

            ldy #$0000
            
            lda #$2000
            -
            sta w_msgbuffer,x
            inx
            inx
            iny
            cpy #$0020
            bmi -
            
            rts
            
            ...finishline:
            
            ;y starts at 0 and goes towards $1f for the line anyway, so just leave it in tact
            
            inx
            inx
            dey
            
            lda #$2000
            -
            sta w_msgbuffer,x
            inx
            inx
            iny
            cpy #$0020
            bmi -
            
            lda w_msg_scrollindex
            clc
            adc #$0004
            sta w_msg_scrollindex
            
            rts
        }
        
        ..seam: {
            ;p_0 = word for filling rows
            ;print hex(w_bg3yscroll)
            
            ;print pc
            
            lda w_bg3yscroll        ;load tiles in advance of the scroll to keep it offscreen
            sec
            sbc #$0015              ;this subtract moves the seam further offscreen
            
            bit #$0007              ;only load rows when scroll mod 8
            bne +
            dec
            dec
            
            asl                     ;some kinda math
            asl
            asl
            clc
            adc #$004e
            
            cmp #$0800              ;wrap when > $800
            bmi ...nowrap
            ...wrap
            sec
            sbc #$0800
            ...nowrap
            tax
            ;stx $40                 ;debug for watching
            
            {   ;this loop gets replaced with writing a line of text
                jsr msg_scroll_writeline
                ;lda #$2045
                ;ldy #$001f
                ;-
                ;sta w_msgbuffer,x
                ;dex
                ;dex
                ;dey
                ;bpl -
            }
            
            lda #$0800
            sta w_msg_size
            sta w_msg_uploadflag
            
            +
            rts
        }
    }
    
}