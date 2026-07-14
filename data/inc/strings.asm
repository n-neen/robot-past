;===========================================================================================
;===================================                ========================================
;==================================   S T R I N G S   ======================================
;===================================                ========================================
;===========================================================================================




str: {
    .hudstring: {
        ;length is currently mandated by !hud_room_string_length
        ..room1:        db "room1     "
        ..room2:        db "room2     "
        ..icecave1:     db "ice cave 1"
        ..town:         db "town      "
    }
    
    .scrollingintro: {
        dw $0010, str_scrollingintro_0
        dw $0018, str_scrollingintro_1
        dw $0020, str_scrollingintro_2
        dw $0022, str_scrollingintro_3
        dw $8000, $1234
        dw $0024, str_scrollingintro_4
        dw $0026, str_scrollingintro_5
        dw $0028, str_scrollingintro_6
        dw $002a, str_scrollingintro_7
        dw $002c, str_scrollingintro_8
        dw $002e, str_scrollingintro_9
        dw $0030, str_scrollingintro_10
        dw $0032, str_scrollingintro_11
        dw $0034, str_scrollingintro_12
        dw $0036, str_scrollingintro_13
        dw $0038, str_scrollingintro_14
        dw $003a, str_scrollingintro_15
        dw $003c, str_scrollingintro_16
        dw $003e, str_scrollingintro_17
        dw $0040, str_scrollingintro_18
        dw $0042, str_scrollingintro_19
        dw $0044, str_scrollingintro_20
        dw $0046, str_scrollingintro_21
        dw $0048, str_scrollingintro_22
        dw $004a, str_scrollingintro_23
        dw $004c, str_scrollingintro_24
        dw $004e, str_scrollingintro_25
        dw $0050, str_scrollingintro_26
        dw $0052, str_scrollingintro_27
        dw $0054, str_scrollingintro_28
        dw $0056, str_scrollingintro_29
        dw $0058, str_scrollingintro_30
        dw $005a, str_scrollingintro_31
        dw $005c, str_scrollingintro_32
        dw $005e, str_scrollingintro_33
        dw $0060, str_scrollingintro_34
        dw $0062, str_scrollingintro_35
        dw $0000
        
        ..0:  db "         ROBOT PAST", !msg_end
        ..1:  db "      a game by neen", !msg_end
        ..2:  db "11111111111111111111111111111111", !msg_end
        ..3:  db "22222222222222222222222222222222", !msg_end
        ..4:  db "33333333333333333333333333333333", !msg_end
        ..5:  db "44444444444444444444444444444444", !msg_end
        ..6:  db "55555555555555555555555555555555", !msg_end
        ..7:  db "66666666666666666666666666666666", !msg_end
        ..8:  db "77777777777777777777777777777777", !msg_end
        ..9:  db "88888888888888888888888888888888", !msg_end
        ..10: db "99999999999999999999999999999999", !msg_end
        ..11: db "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", !msg_end
        ..12: db "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb", !msg_end
        ..13: db "cccccccccccccccccccccccccccccccc", !msg_end
        ..14: db "dddddddddddddddddddddddddddddddd", !msg_end
        ..15: db "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", !msg_end
        ..16: db "ffffffffffffffffffffffffffffffff", !msg_end
        ..17: db "01010101010101010101010101010101", !msg_end
        ..18: db "02020202020202020202020202020202", !msg_end
        ..19: db "03030303030303030303030303030303", !msg_end
        ..20: db "04040404040404040404040404040404", !msg_end
        ..21: db "05050505050505050505050505050505", !msg_end
        ..22: db "06060606060606060606060606060606", !msg_end
        ..23: db "07070707070707070707070707070707", !msg_end
        ..24: db "08080808080808080808080808080808", !msg_end
        ..25: db "09090909090909090909090909090909", !msg_end
        ..26: db "0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a", !msg_end
        ..27: db "0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b", !msg_end
        ..28: db "0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c", !msg_end
        ..29: db "0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d", !msg_end
        ..30: db "0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e", !msg_end
        ..31: db "0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f", !msg_end
        ..32: db "10101010101010101010101010101010", !msg_end
        ..33: db "12121212121212121212121212121212", !msg_end
        ..34: db "13131313131313131313131313131313", !msg_end
        ..35: db "14141414141414141414141414141414", !msg_end
    }
    
    .scrolltest: {
        ;scrolling text commands
        ;line to appear on : pointer to string
        dw $0004, str_scrolltest_0
        dw $0010, str_scrolltest_1
        dw $0018, str_scrolltest_2
        dw $0028, str_scrolltest_3
        dw $0038, str_scrolltest_4
        dw $0040, str_scrolltest_5
        dw $0050, str_scrolltest_6
        dw $00ff, str_scrolltest_7
        dw $0123, str_scrolltest_8
        dw $0150, str_scrolltest_9
        dw $0201, str_scrolltest_10
        dw $0000  ;end
        
        ..0:  db "0 words right here", !msg_end
        ..1:  db "1 different words...   line $10", !msg_end
        ..2:  db "2 once upon a tiem   line $18", !msg_end
        ..3:  db "3 THERE WUZ A CAPITAL line $28", !msg_end
        ..4:  db "4  SENTENCE OF WORDZ  LINE $38", !msg_end
        ..5:  db "5  AND THEN UHH line $40", !msg_end
        ..6:  db "6  i needed even more line $50", !msg_end
        ..7:  db "7  because this needs line $ff", !msg_end
        ..8:  db "8  to b infinitey wordline $123", !msg_end
        ..9:  db "9  infintie words line $150", !msg_end
        ..10: db "10 ok this is end line $201", !msg_end
    }
    
    .testtext: {
        ;used in a text trigger object
        db !msg_newline
        db !msg_newline
        db "        an act of love"
        db !msg_newline
        db !msg_newline
        db "          remains at last"
        db !msg_newline
        db !msg_newline
        db "            preserved above"
        db !msg_newline
        db !msg_newline
        db "              from robot past"
        
        db !msg_end
    }

    .text2: {
        ;used in a text trigger object
        db "text string 2"
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db "this one is less cool"
        db !msg_end
    }

    .intro1: {
        db "intro text 1"
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db "              intro text 1.1"
        db !msg_end
    }

    .intro2: {
        db "   intro text 2"
        db !msg_end
    }

    .intro3: {
        db "intro text 3 which is way longer"
        db !msg_end
    }

    .intro4: {
        db "intro text 4.0"
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db "intro text 4.1"
        db !msg_end
    }

    .entrance: {
        ;used in a dialogue trigger's dialog scene in ice cave intro
        db "             within"
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db "              this"
        db !msg_newline
        db !msg_newline
        db !msg_newline
        db "              cave"
        db !msg_end
    }
    
    .poem: {
        ;not used
        db "a thought occurs and brings a scream"
        db !msg_newline
        db "out in the agony of returning to me"
        db !msg_newline
        db !msg_newline
        db "the sound of your voice is a melody"
        db !msg_end
    }
    
    
    
}