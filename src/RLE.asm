;rle

;i think this is in loading.asm now oops

decompress: {
    ;p_0                    = long pointer to source (p_2 is the bank)
    ;p_4                    = counter for repeats
    ;l_decompressionbuffer  = destination
    
    ;format:
    ;ss ss = size in words (number of times to repeat)
    ;dd dd = the data to repeat s times
    ;repeat until terminator (size of $0000)
    
    
    pei (p_2)   ;db = source bank
    plb
    
    ldy #$fffe
    ldx #$0000
    
    ..next
    
    iny
    iny
    
    lda (p_0),y                     ;read size
    beq ..done
    sta p_4
    
    iny                             ;next word
    iny
    
    lda (p_0),y                     ;fill
    -
    sta.l l_decompressionbuffer,x
    inx
    inx
    dec p_4
    bne -
    bra ..next
    
    ..done
    rtl
}