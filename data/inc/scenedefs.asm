
scenedef: {
    macro scenedefentry(label)
        ;not using this in actual entries for now
        dl <label>                  ;long pointer to the scene data ;$0
        dw <label>_pal              ;inbank pointer to palette,     ;$3
        dw <label>_gfx              ;graphics,                      ;$5
        dw <label>_map              ;tilemap                        ;$7
        dw datasize(<label>_gfx)    ;graphics size                  ;$9
        dw datasize(<label>_map)    ;tilemap size                   ;$b
        dw properties_<label>       ;gameplay properties            ;$d; in scenedef
        dw hdmalist_<label>         ;list of hdma objects to spawn  ;$f
        dw glowlist_<label>         ;list of glow objects to spawn  ;$11
        dw bgdata_<label>           ;                               ;$13
        db !layer_blend_default     ;one byte, index for main.asm   ;$15
    endmacro
    
    ;run superfamiconv to output every scene using at most the bottom 7 palettes
    ;of bg palette area. reserve top 16 colors for bg3!
    ;the routine load_romtocolorbuffer will start at the second palette
    
;===========================================================================================
;======================================== scene definitions ================================
;===========================================================================================

;contains common data for nongameplay, dialogue scenes; and gameplay rooms
    
    ;unused
    .light:
        dl light                            ;long pointer to the scene data ;$0
        dw light_pal                        ;inbank pointer to palette,     ;$3
        dw light_gfx                        ;graphics,                      ;$5
        dw light_map                        ;tilemap                        ;$7
        dw datasize(light_gfx)              ;graphics size                  ;$9
        dw datasize(light_map)              ;tilemap size                   ;$b
        dw properties_light                 ;gameplay properties            ;$d; in scenedef
        dw $0000                            ;list of hdma objects to spawn  ;f
        dw $0000                            ;list of glow objects to spawn  ;11
        dw $0000                            ;background data list           ;$13
        db !layer_blend_intro               ;one byte, index for main.asm   ;$15
    
;====================================== intro scenes =======================================
    .meetsisters:       ;%scenedefentry(meetsisters)
        dl meetsisters                      ;long pointer to the scene data ;$0
        dw meetsisters_pal                  ;inbank pointer to palette,     ;$3
        dw meetsisters_gfx                  ;graphics,                      ;$5
        dw meetsisters_map                  ;tilemap                        ;$7
        dw datasize(meetsisters_gfx)        ;graphics size                  ;$9
        dw datasize(meetsisters_map)        ;tilemap size                   ;$b
        dw properties_meetsisters           ;gameplay properties            ;$d; in scenedef
        dw $0000                            ;list of hdma objects to spawn  ;$f
        dw glowlist_meetsisters             ;list of glow objects to spawn  ;$11
        dw $0000                            ;background data list           ;$13
        db !layer_blend_intro               ;one byte, index for handler    ;$15
    
    
    .bloodlotus:        ;%scenedefentry(bloodlotus)
        dl bloodlotus                       ;long pointer to the scene data ;$0
        dw bloodlotus_pal                   ;inbank pointer to palette,     ;$3
        dw bloodlotus_gfx                   ;graphics,                      ;$5
        dw bloodlotus_map                   ;tilemap                        ;$7
        dw datasize(bloodlotus_gfx)         ;graphics size                  ;$9
        dw datasize(bloodlotus_map)         ;tilemap size                   ;$b
        dw properties_bloodlotus            ;gameplay properties            ;$d; in scenedef
        dw $0000                            ;list of hdma objects to spawn  ;$f
        dw $0000                            ;list of glow objects to spawn  ;$11
        dw $0000                            ;background data list           ;$13
        db !layer_blend_intro               ;one byte, index for handler    ;$15
    
    
    .flamecircle:       ;%scenedefentry(flamecircle)
        dl flamecircle                      ;long pointer to the scene data ;$0
        dw flamecircle_pal                  ;inbank pointer to palette,     ;$3
        dw flamecircle_gfx                  ;graphics,                      ;$5
        dw flamecircle_map                  ;tilemap                        ;$7
        dw datasize(flamecircle_gfx)        ;graphics size                  ;$9
        dw datasize(flamecircle_map)        ;tilemap size                   ;$b
        dw properties_flamecircle           ;gameplay properties            ;$d; in scenedef
        dw $0000                            ;list of hdma objects to spawn  ;$f
        dw $0000                            ;list of glow objects to spawn  ;$11
        dw $0000                            ;background data list           ;$13
        db !layer_blend_intro               ;one byte, index for handler    ;$15
    

    .city:              ;%scenedefentry(city)
        dl city                             ;long pointer to the scene data ;$0
        dw city_pal                         ;inbank pointer to palette,     ;$3
        dw city_gfx                         ;graphics,                      ;$5
        dw city_map                         ;tilemap                        ;$7
        dw datasize(city_gfx)               ;graphics size                  ;$9
        dw datasize(city_map)               ;tilemap size                   ;$b
        dw properties_city                  ;gameplay properties            ;$d; in scenedef
        dw $0000                            ;list of hdma objects to spawn  ;$f
        dw $0000                            ;list of glow objects to spawn  ;$11
        dw $0000                            ;background data list           ;$13
        db !layer_blend_intro               ;one byte, index for handler    ;$15
    
;================================  nongameplay scenes ======================================
    .entrance:          ;%scenedefentry(entrance)
        dl entrance                         ;long pointer to the scene data ;$0
        dw entrance_pal                     ;inbank pointer to palette,     ;$3
        dw entrance_gfx                     ;graphics,                      ;$5
        dw entrance_map                     ;tilemap                        ;$7
        dw datasize(entrance_gfx)           ;graphics size                  ;$9
        dw datasize(entrance_map)           ;tilemap size                   ;$b
        dw properties_entrance              ;gameplay properties            ;$d; in scenedef
        dw $0000                            ;list of hdma objects to spawn  ;$f
        dw $0000                            ;list of glow objects to spawn  ;$11
        dw $0000                            ;background data list           ;$13
        db !layer_blend_default_nosprites   ;one byte, index for handler    ;$15
        
        
    .pieces:            ;%scenedefentry(pieces2)
        dl pieces                           ;long pointer to the scene data ;$0
        dw pieces_pal                       ;inbank pointer to palette,     ;$3
        dw pieces_gfx                       ;graphics,                      ;$5
        dw pieces_map                       ;tilemap                        ;$7
        dw datasize(pieces_gfx)             ;graphics size                  ;$9
        dw datasize(pieces_map)             ;tilemap size                   ;$b
        dw properties_pieces                ;gameplay properties            ;$d; in scenedef
        dw hdmalist_pieces                  ;list of hdma objects to spawn  ;$f
        dw glowlist_pieces                  ;list of glow objects to spawn  ;$11
        dw bgdata_pieces                    ;background data list           ;$13
        db !layer_blend_scene_pieces        ;one byte, index for handler    ;$15
    
    
    .agony:             ;%scenedefentry(agony)
        dl agony                            ;long pointer to the scene data ;$0
        dw agony_pal                        ;inbank pointer to palette,     ;$3
        dw agony_gfx                        ;graphics,                      ;$5
        dw agony_map                        ;tilemap                        ;$7
        dw datasize(agony_gfx)              ;graphics size                  ;$9
        dw datasize(agony_map)              ;tilemap size                   ;$b
        dw properties_agony                 ;gameplay properties            ;$d; in scenedef
        dw hdmalist_agony                   ;list of hdma objects to spawn  ;$f
        dw glowlist_agony                   ;list of glow objects to spawn  ;$11
        dw bgdata_agony                     ;background data list           ;$13
        db !layer_blend_scene_agony         ;one byte, index for handler    ;$15
        
        
    .blue:              ;%scenedefentry(blue)
        dl blue                             ;long pointer to the scene data ;$0
        dw blue_pal                         ;inbank pointer to palette,     ;$3
        dw blue_gfx                         ;graphics,                      ;$5
        dw blue_map                         ;tilemap                        ;$7
        dw datasize(blue_gfx)               ;graphics size                  ;$9
        dw datasize(blue_map)               ;tilemap size                   ;$b
        dw properties_blue                  ;gameplay properties            ;$d; in scenedef
        dw hdmalist_blue                    ;list of hdma objects to spawn  ;$f
        dw glowlist_blue                    ;list of glow objects to spawn  ;$11
        dw bgdata_blue                      ;background data list           ;$13
        db !layer_blend_scene_pieces        ;one byte, index for handler    ;$15
        
        
    .triangle:          ;%scenedefentry(triangle)
        dl triangle                         ;long pointer to the scene data ;$0
        dw triangle_pal                     ;inbank pointer to palette,     ;$3
        dw triangle_gfx                     ;graphics,                      ;$5
        dw triangle_map                     ;tilemap                        ;$7
        dw datasize(triangle_gfx)           ;graphics size                  ;$9
        dw datasize(triangle_map)           ;tilemap size                   ;$b
        dw properties_triangle              ;gameplay properties            ;$d; in scenedef
        dw hdmalist_triangle                ;list of hdma objects to spawn  ;$f
        dw glowlist_triangle                ;list of glow objects to spawn  ;$11
        dw bgdata_triangle                  ;background data list           ;$13
        db !layer_blend_scene_triangle      ;one byte, index for handler    ;$15
 
    
;=================================== gameplay rooms ========================================
    .room1:             ;%scenedefentry(room1)
        dl room1                            ;long pointer to the scene data ;$0
        dw room1_pal                        ;inbank pointer to palette,     ;$3
        dw room1_gfx                        ;graphics,                      ;$5
        dw room1_map                        ;tilemap                        ;$7
        dw datasize(room1_gfx)              ;graphics size                  ;$9
        dw datasize(room1_map)              ;tilemap size                   ;$b
        dw properties_room1                 ;gameplay properties            ;$d; in scenedef
        dw $0000                            ;list of hdma objects to spawn  ;$f
        dw glowlist_gameplaydefault         ;list of glow objects to spawn  ;$11
        dw bgdata_room1                     ;background data list           ;$13
        db !layer_blend_default_withbg2m    ;one byte, index for handler    ;$15
    
    
    .room2:             ;%scenedefentry(room2)
        dl room2                            ;long pointer to the scene data ;$0
        dw room2_pal                        ;inbank pointer to palette,     ;$3
        dw room2_gfx                        ;graphics,                      ;$5
        dw room2_map                        ;tilemap                        ;$7
        dw datasize(room2_gfx)              ;graphics size                  ;$9
        dw datasize(room2_map)              ;tilemap size                   ;$b
        dw properties_room2                 ;gameplay properties            ;$d; in scenedef
        dw $0000                            ;list of hdma objects to spawn  ;$f
        dw glowlist_gameplaydefault         ;list of glow objects to spawn  ;$11
        dw $0000                            ;background data list           ;$13
        db !layer_blend_default             ;one byte, index for handler    ;$15
    
    
    .town:              ;%scenedefentry(town)
        dl town                             ;long pointer to the scene data ;$0
        dw town_pal                         ;inbank pointer to palette,     ;$3
        dw town_gfx                         ;graphics,                      ;$5
        dw town_map                         ;tilemap                        ;$7
        dw datasize(town_gfx)               ;graphics size                  ;$9
        dw datasize(town_map)               ;tilemap size                   ;$b
        dw properties_town                  ;gameplay properties            ;$d; in scenedef
        dw $0000                            ;list of hdma objects to spawn  ;$f
        dw glowlist_gameplaydefault         ;list of glow objects to spawn  ;$11
        dw $0000                            ;background data list           ;$13
        db !layer_blend_default             ;one byte, index for handler    ;$15
        
    
    .moonroom:          ;%scenedefentry(moonroom)
        dl moonroom                         ;long pointer to the scene data ;$0
        dw moonroom_pal                     ;inbank pointer to palette,     ;$3
        dw moonroom_gfx                     ;graphics,                      ;$5
        dw moonroom_map                     ;tilemap                        ;$7
        dw datasize(moonroom_gfx)           ;graphics size                  ;$9
        dw datasize(moonroom_map)           ;tilemap size                   ;$b
        dw properties_moonroom              ;gameplay properties            ;$d; in scenedef
        dw $0000                            ;list of hdma objects to spawn  ;$f
        dw glowlist_gameplaydefault         ;list of glow objects to spawn  ;$11
        dw $0000                            ;background data list           ;$13
        db !layer_blend_default             ;one byte, index for handler    ;$15
    
    
    .icecave1:
        dl icecave1                         ;long pointer to the scene data ;$0
        dw entrance_pal                     ;inbank pointer to palette,     ;$3
        dw entrance_gfx                     ;graphics,                      ;$5
        dw icecave1_map                     ;tilemap                        ;$7
        dw datasize(entrance_gfx)           ;graphics size                  ;$9
        dw datasize(icecave1_map)           ;tilemap size                   ;$b
        dw properties_icecave1              ;gameplay properties            ;$d
        dw $0000                            ;list of hdma objects to spawn  ;$f 
        dw glowlist_gameplaydefault         ;list of glow objects to spawn  ;$11 
        dw $0000                            ;background data list           ;$13
        db !layer_blend_default             ;one byte, index for handler    ;$15
        
        
    .icecave2:
        dl icecave1                         ;long pointer to the scene data ;$0
        dw entrance_pal                     ;inbank pointer to palette,     ;$3
        dw entrance_gfx                     ;graphics,                      ;$5
        dw icecave2_map                     ;tilemap                        ;$7
        dw datasize(entrance_gfx)           ;graphics size                  ;$9
        dw datasize(icecave2_map)           ;tilemap size                   ;$b
        dw properties_icecave2              ;gameplay properties            ;$d
        dw $0000                            ;list of hdma objects to spawn  ;$f
        dw glowlist_gameplaydefault         ;list of glow objects to spawn  ;$11
        dw $0000                            ;background data list           ;$13
        db !layer_blend_default             ;one byte, index for handler    ;$15
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
    }
    
    .bloodlotus: {                  ;intro 2
        dw !state_loadintroscene
        dw str_intro2
        db $16
        dw $0000                    ;init routine
        dw str_scrollingintro       ;scrolling text commands
    }
    
    .flamecircle: {                 ;intro 3
        dw !state_loadintroscene
        dw str_intro3
        db $18
        dw $0000                    ;init routine
        dw $0000                    ;scrolling text commands
    }
    
    .city: {                        ;intro 4
        dw !state_loadintroscene    ;program state to enter
        dw str_intro4               ;text string pointer
        db $04                      ;starting line for text
        dw $0000                    ;init routine
        dw $0000                    ;scrolling text commands
    }
    
    .entrance: {
        dw !state_loadnongame
        dw str_entrance
        db $0a                      ;starting line
        dw $0000                    ;init routine
        dw str_scrolltest           ;scrolling text commands
    }
    
    .pieces: {
        dw !state_loadnongame
        dw str_entrance
        db $0a                      ;starting line
        dw sceneinit_pieces         ;init routine
        dw $0000                    ;scrolling text commands
    }
    
    .agony: {
        dw !state_loadnongame
        dw str_agony
        db $02                      ;starting line
        dw sceneinit_agony          ;init routine
        dw $0000                    ;scrolling text commands
    }
    
    .blue: {
        dw !state_loadnongame
        dw str_blue
        db $02                      ;starting line
        dw sceneinit_blue           ;init routine
        dw $0000                    ;scrolling text commands
    }
    
    .triangle: {
        dw !state_loadnongame
        dw str_blue
        db $02                      ;starting line
        dw sceneinit_triangle       ;init routine
        dw str_scrolltriangle       ;scrolling text commands
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
    }
    
    .room2: {
        dw !state_loadgame              ;program mode to use
        dw $0100, $0000                 ;starting camera position x,y
        dw $01e0, $0080                 ;starting player position x,y
        dw objlist_room2                ;object list pointer
        dw collisionmap_room2           ;
        dw faelist_room2                ;
        dw str_hudstring_room2          ;string to print on hud     ;$10
    }
    
    .town: {
        dw !state_loadgame
        dw $0080, $0080                 ;starting camera position x,y
        dw $0100, $0100                 ;starting player position x,y
        dw objlist_town                 ;object list pointer
        dw collisionmap_town            ;
        dw faelist_town                 ;
        dw str_hudstring_town           ;string to print on hud     ;$10
    }
    
    .icecave1: {
        dw !state_loadgame              ;program mode to use
        dw $0000, $0000                 ;starting camera position x,y
        dw $0080, $0080                 ;starting player position x,y
        dw objlist_icecave1             ;object list pointer
        dw collisionmap_icecave1        ;
        dw faelist_icecave1             ;
        dw str_hudstring_icecave1       ;string to print on hud     ;$10
    }
    
    .icecave2: {
        dw !state_loadgame              ;program mode to use
        dw $0000, $0000                 ;starting camera position x,y
        dw $0080, $0080                 ;starting player position x,y
        dw objlist_icecave2             ;object list pointer
        dw collisionmap_icecave2        ;
        dw faelist_icecave2             ;
        dw str_hudstring_icecave2       ;string to print on hud     ;$10
    }
    
    .moonroom: {                        ;description                ;number of bytes in
        dw !state_loadgame              ;program mode to use        ;0
        dw $0001, $0001                 ;starting camera position   ;2,4
        dw $0028, $0058                 ;starting player position   ;6,8
        dw objlist_moonroom             ;object list pointer        ;a
        dw collisionmap_moonroom        ;                           ;c
        dw faelist_moonroom             ;list of fae for the room   ;e
        dw str_hudstring_moonroom       ;string to print on hud     ;$10
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
    
    .blue: {
        dw hdma_interleaved_indirect, $0f42         ;1
        dw $ffff
    }
    
    .triangle: {
        dw hdma_interleaved_indirect, $0f42     ;bg2 x
        dw hdma_interleaved_indirect, $0d42     ;bg1 x
        
        dw hdma_sinewave_indirect, $0e42        ;bg1 y
        dw hdma_sinewave_indirect, $1042        ;bg2 y
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
    
    .meetsisters: {
        dw glow_meetsisters
        dw $ffff
    }
    
    .gameplaydefault: {
        dw glow_animationtest
        dw $ffff
    }
    
    .blue: {
        dw glow_bluebackdrop                        ;0
        dw $ffff                                    ;end
    }
    
    .triangle: {
        dw glow_trianglebackdrop
        ;dw glow_trianglemid
        dw $ffff
    }
}

;=================================== LAYER 2 BACKGROUND DATA ====================================

bgdata: {
    .agony:
        dl agony_bg2map
        dw datasize(agony_bg2map)
        
    .pieces:
        dl pieces_bg2
        dw datasize(pieces_bg2)
        
    .room1:
        dl room1bg2map
        dw datasize(room1bg2map)
        
    .blue:
        dl blue_map
        dw datasize(blue_map)
        
    .triangle:
        dl triangle_bg2map
        dw datasize(triangle_bg2map)
}