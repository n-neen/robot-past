
scenedef: {
    macro scenedefentry(label)
        dl <label>                  ;long pointer to the scene data ;$0
        dw <label>_pal              ;inbank pointer to palette,     ;$3
        dw <label>_gfx              ;graphics,                      ;$5
        dw <label>_map              ;tilemap                        ;$7
        dw datasize(<label>_gfx)    ;graphics size                  ;$9
        dw datasize(<label>_map)    ;tilemap size                   ;$b
        dw properties_<label>       ;gameplay properties            ;$d; in scenedef
    endmacro
    
    ;run superfamiconv to output every scene using at most the bottom 7 palettes
    ;of bg palette area. reserve top 16 colors for bg3!
    ;the routine load_romtocolorbuffer will start at the second palette
    
;===========================================================================================
;======================================== scene definitions ================================
;===========================================================================================

;contains common data for nongameplay, dialogue scenes; and gameplay rooms
    
    ;unused
    .light:             %scenedefentry(light)           ;text
    
    ;intro scenes
    .meetsisters:       %scenedefentry(meetsisters)
    .bloodlotus:        %scenedefentry(bloodlotus)
    .flamecircle:       %scenedefentry(flamecircle)
    .city:              %scenedefentry(city)
    
    ;nongameplay scenes (gameplay subscenes)
    .entrance:          %scenedefentry(entrance)
    .pieces:            %scenedefentry(pieces2)
    .agony:             %scenedefentry(agony)
    
    ;gameplay rooms
    .room1:             %scenedefentry(room1)
    .room2:             %scenedefentry(room2)
    .town:              %scenedefentry(town)
    .moonroom:          %scenedefentry(moonroom)
    
    .icecave1:                      ;have to do this to reuse graphics :/
        dl icecave1                 ;long pointer to the scene data ;0
        dw entrance_pal             ;inbank pointer to palette,     ;3
        dw entrance_gfx             ;graphics,                      ;5
        dw icecave1_map             ;tilemap                        ;7
        dw datasize(entrance_gfx)   ;graphics size                  ;9
        dw datasize(icecave1_map)   ;tilemap size                   ;b
        dw properties_icecave1      ;gameplay properties            ;d
        
        
    .icecave2:                      ;have to do this to reuse graphics :/
        dl icecave1                 ;long pointer to the scene data ;0
        dw entrance_pal             ;inbank pointer to palette,     ;3
        dw entrance_gfx             ;graphics,                      ;5
        dw icecave2_map             ;tilemap                        ;7
        dw datasize(entrance_gfx)   ;graphics size                  ;9
        dw datasize(icecave2_map)   ;tilemap size                   ;b
        dw properties_icecave2      ;gameplay properties            ;d  
}

;===========================================================================================
;==================================== scene properties =====================================
;===========================================================================================

properties: {
    ;contains separate sections for the properites that differ
    ;among gameplay and nongameplay scenes
    
    
; ============================ dialogue scenes (nongameplay) ===============================
    
    .meetsisters: {                 ;intro 1
        dw !state_loadintroscene    ;program state to enter
        dw str_intro1               ;text string pointer
        db $08                      ;starting line for text
        dw $0000                    ;init routine
        dw str_credits              ;scrolling text commands (ptr to strings.asm)
        dw $0000                    ;list of hdma objects to spawn
        dw $0000                    ;list of glow objects to spawn

    }
    
    .bloodlotus: {                  ;intro 2
        dw !state_loadintroscene
        dw str_intro2
        db $16
        dw $0000                    ;init routine
        dw str_scrollingintro       ;scrolling text commands
        dw $0000                    ;list of hdma objects to spawn
        dw $0000                    ;list of glow objects to spawn
    }
    
    .flamecircle: {                 ;intro 3
        dw !state_loadintroscene
        dw str_intro3
        db $18
        dw $0000                    ;init routine
        dw $0000                    ;scrolling text commands
        dw $0000                    ;list of hdma objects to spawn
        dw $0000                    ;list of glow objects to spawn
    }
    
    .city: {                        ;intro 4
        dw !state_loadintroscene    ;program state to enter
        dw str_intro4               ;text string pointer
        db $04                      ;starting line for text
        dw $0000                    ;init routine
        dw $0000                    ;scrolling text commands
        dw $0000                    ;list of hdma objects to spawn
        dw $0000                    ;list of glow objects to spawn
    }
    
    .entrance: {
        dw !state_loadnongame
        dw str_entrance
        db $0a                      ;starting line
        dw $0000                    ;init routine
        dw str_scrolltest           ;scrolling text commands
        dw $0000                    ;list of hdma objects to spawn
        dw $0000                    ;list of glow objects to spawn
    }
    
    .pieces2: {
        dw !state_loadnongame
        dw str_entrance
        db $0a                      ;starting line
        dw sceneinit_pieces         ;init routine
        dw $0000                    ;scrolling text commands
        dw hdmalist_pieces          ;list of hdma objects to spawn
        dw glowlist_pieces          ;list of glow objects to spawn
    }
    
    .agony: {
        dw !state_loadnongame
        dw str_agony
        db $02                      ;starting line
        dw sceneinit_agony          ;init routine
        dw $0000                    ;scrolling text commands
        dw hdmalist_agony           ;list of hdma objects to spawn
        dw glowlist_agony           ;list of glow objects to spawn
    }


; ===================================== gameplay ===========================================
; ===================================== rooms ==============================================

    .room1: {                           ;description                ;number of bytes in
        dw !state_loadgame              ;program mode to use        ;0
        dw $0001, $0001                 ;starting camera position   ;2,4
        dw $0028, $0058                 ;starting player position   ;6,8
        dw objlist_room1                ;object list pointer        ;a
        dw collisionmap_room1           ;                           ;c
        dw faelist_room1                ;list of fae for the room   ;e
        dw str_hudstring_room1          ;string to print on hud     ;$10
        dw $0000                        ;list of hdma objects to spawn
        dw $0000                        ;list of glow objects to spawn
    }
    
    .room2: {
        dw !state_loadgame              ;program mode to use
        dw $0100, $0000                 ;starting camera position x,y
        dw $01e0, $0080                 ;starting player position x,y
        dw objlist_room2                ;object list pointer
        dw collisionmap_room2           ;
        dw faelist_room2                ;
        dw str_hudstring_room2          ;string to print on hud     ;$10
        dw $0000                        ;list of hdma objects to spawn
        dw $0000                        ;list of glow objects to spawn
    }
    
    .town: {
        dw !state_loadgame
        dw $0080, $0080                 ;starting camera position x,y
        dw $0100, $0100                 ;starting player position x,y
        dw objlist_town                 ;object list pointer
        dw collisionmap_town            ;
        dw faelist_town                 ;
        dw str_hudstring_town           ;string to print on hud     ;$10
        dw $0000                        ;list of hdma objects to spawn
        dw $0000                        ;list of glow objects to spawn
    }
    
    .icecave1: {
        dw !state_loadgame              ;program mode to use
        dw $0000, $0000                 ;starting camera position x,y
        dw $0080, $0080                 ;starting player position x,y
        dw objlist_icecave1             ;object list pointer
        dw collisionmap_icecave1        ;
        dw faelist_icecave1             ;
        dw str_hudstring_icecave1       ;string to print on hud     ;$10
        dw $0000                        ;list of hdma objects to spawn
        dw $0000                        ;list of glow objects to spawn
    }
    
    .icecave2: {
        dw !state_loadgame              ;program mode to use
        dw $0000, $0000                 ;starting camera position x,y
        dw $0080, $0080                 ;starting player position x,y
        dw objlist_icecave2             ;object list pointer
        dw collisionmap_icecave2        ;
        dw faelist_icecave2             ;
        dw str_hudstring_icecave2       ;string to print on hud     ;$10
        dw $0000                        ;list of hdma objects to spawn
        dw $0000                        ;list of glow objects to spawn
    }
    
    .moonroom: {                        ;description                ;number of bytes in
        dw !state_loadgame              ;program mode to use        ;0
        dw $0001, $0001                 ;starting camera position   ;2,4
        dw $0028, $0058                 ;starting player position   ;6,8
        dw objlist_moonroom             ;object list pointer        ;a
        dw collisionmap_moonroom        ;                           ;c
        dw faelist_moonroom             ;list of fae for the room   ;e
        dw str_hudstring_moonroom       ;string to print on hud     ;$10
        dw $0000                        ;list of hdma objects to spawn
        dw $0000                        ;list of glow objects to spawn
    }
    
    
    
; ============================== unused scene properties ===================================
    .light: {
        dw !state_loadintroscene
    }
}


;=================================== HDMA OBJECTS LISTS ====================================
;not implemented yet

hdmalist: {
    .pieces: {                                      ;channel
        dw hdma_sinewave_indirect, $1042            ;1
        dw hdma_glitch_bands_indirect, $0f42        ;2
        dw hdma_sinewave_indirect, $0e42            ;3
        dw hdma_sinewave_indirect, $0d42            ;4
        dw $ffff                                    ;end
    }
    
    .agony: {
        dw hdma_sinewave_indirect, $1042            ;1
        dw $ffff
    }
    
}


;=================================== GLOW OBJECTS LISTS ====================================
;not implemented yet

glowlist: {
    .pieces: {
        dw glow_incrementing                        ;0
        dw $ffff                                    ;end
    }
    
    .agony: {
        dw glow_agony                               ;0
        dw $ffff                                    ;end
    }
}