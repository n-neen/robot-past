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
    
    .scrolltest: {
        ;scrolling text commands
        ;line to appear on : pointer to string
        ;length is fixed at 32 characters right now
        dw $0004, str_scrolltest_0
        dw $0010, str_scrolltest_1
        dw $0018, str_scrolltest_2
        dw $0028, str_scrolltest_3
        dw $0038, str_scrolltest_4
        dw $0041, str_scrolltest_5
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
        db "a thought occurs and brings a scream"
        db !msg_newline
        db "out in the agony of returning to me"
        db !msg_newline
        db !msg_newline
        db "the sound of your voice is a melody"
        db !msg_end
    }
    
    
    
}