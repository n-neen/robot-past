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
        dw $0040, str_scrolltest_5
        dw $0050, str_scrolltest_6
        dw $00ff, str_scrolltest_7
        dw $0123, str_scrolltest_8
        dw $0150, str_scrolltest_9
        dw $0200, str_scrolltest_10
        dw $0000  ;end
        
        ..0:  db "words right here,               "
        ..1:  db "different words...              "
        ..2:  db "ooh, some other words           "
        ..3:  db "ooh, some other words  3        "
        ..4:  db "ooh, some other words  4        "
        ..5:  db "ooh, some other words  5        "
        ..6:  db "ooh, some other words  6        "
        ..7:  db "ooh, some other words  7        "
        ..8:  db "ooh, some other words  8        "
        ..9:  db "ooh, some other words  9        "
        ..10: db "ooh, some other words  10       "
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