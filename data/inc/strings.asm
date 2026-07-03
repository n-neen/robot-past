;===========================================================================================
;===================================                ========================================
;==================================   S T R I N G S   ======================================
;===================================                ========================================
;===========================================================================================




str: {
    .testtext: {
        db "        an act of love"
        db !msg_newline
        db !msg_newline
        db "         remains at last"
        db !msg_newline
        db !msg_newline
        db "          preserved above"
        db !msg_newline
        db !msg_newline
        db "           from robot past"
        
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
        db "intro text 4.0", !msg_newline
        db "intro text 4.1", !msg_newline
        db "intro text 4.2", !msg_newline
        db "intro text 4.3", !msg_newline
        db "intro text 4.4", !msg_newline
        db "intro text 4.5", !msg_newline
        db "intro text 4.6", !msg_newline
        db "intro text 4.7", !msg_newline
        db "intro text 4.8", !msg_newline
        db "intro text 4.9", !msg_newline
        db "intro text 4.10", !msg_newline
        db "intro text 4.11", !msg_newline
        db "intro text 4.12", !msg_newline
        db "intro text 4.13", !msg_newline
        db "intro text 4.14", !msg_newline
        db "intro text 4.15", !msg_newline
        db "intro text 4.16", !msg_newline
        db "intro text 4.17", !msg_newline
        db "intro text 4.18", !msg_newline
        db "intro text 4.19", !msg_newline
        db "intro text 4.20", !msg_newline
        db "intro text 4.21", !msg_newline
        db "intro text 4.22", !msg_newline
        db "intro text 4.23", !msg_newline
        db "intro text 4.24", !msg_newline
        db "intro text 4.25", !msg_newline
        db "intro text 4.25", !msg_newline
        db "intro text 4.26", !msg_newline
        db "intro text 4.27", !msg_newline
        db "intro text 4.28", !msg_newline
        db "intro text 4.29", !msg_newline
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