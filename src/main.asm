;===========================================================================================
;====================================  M A I N  ============================================
;===========================================================================================
;
;this file contains main, and all top-level states, except those which only have a vector
;here, like main gameplay, which is in its own file. also contains some important
;system routines like fadein, fadeout
;
;there are some assumptions made that main.asm and interrupts.asm will be in the same bank!

main: {
    phk
    plb
    
    lda w_programstate
    asl
    tax
    
    jsr (main_table,x)
    
    jsr waitfornmi
    
    jmp main
    
    .table: {
        ;don't forget to make a corresponding define in defines.asm
        ;!state_[name]
        
        dw  setup,                      ;0      ;initial program setup after boot.asm happens
            introhandler,               ;1      ;loads dialog scenes in order when button pressed
            loadintroscene,             ;2      ;load the individual scenes for above
            gameplayvector,             ;3      ;playing the game, top level routine in gameplay.asm
            loadgame,                   ;4      ;set up gameplay initially, and also for room transitions
            loadnongameplayscene,       ;5      ;load dialog scenes that come from gameplay and return to gameplay
            nongameplayhandler,         ;6      ;handle running the above after loading
            setupgameoverscreen,        ;7      ;do game over graphics and tilemap transfurs
            handlegameoverscreen        ;8      ;display game over and handle interactions
    }
}

;===========================================================================================
;========================= B E G I N   S C E N E   T R A N S I T I O N =====================
;===========================================================================================
;populate scene area of memory
;typically call this then immediately call load_scene

;there are three types of scenes:
;
;=gameplay scenes, also called rooms
;
;=two types of dialog/text scenes:
; -intro scenes
; -nongameplay scenes, which are called from gameplay rooms and return to gameplay rooms
    ;such as through the dialogtrigger object
    

scenetransition: {
    ;arguments:
    ;x = scene pointer to scene header in scenedef bank
    
    phk
    plb
    
    stx w_scene_ptr                         ;save this first
    
    phb
    
    pea.w bank(scenedef)<<8                 ;db = scene def bank
    plb
    plb
    
    lda $0000,x
    sta.l w_scene_definitionptr
    
    lda $0002,x
    and #$00ff
    sta.l w_scene_bank
    
    lda $0003,x
    sta.l w_scene_palptr
    
    lda $0005,x
    sta.l w_scene_gfxptr
    
    lda $0007,x
    sta.l w_scene_mapptr
    
    lda $0009,x
    sta.l w_scene_gfxsize
    
    lda $000b,x
    sta.l w_scene_tilemapsize
    
    lda $000d,x
    sta.l w_scene_gameprops
    
    tax     ;x = pointer to gameplay properties, if it's a gameplay room
            ;otherwise, it's a dialogue scene properties list
    
    ;scene dialogue/gameplay properties
    
    lda $0000,x
    sta.l w_scene_mode
    
    cmp #!state_loadgame        ;if not gameplay, go to nongameplay
    bne .notgameplay
    
    .gameplay:                  ;else, gameplay
    
    lda $0002,x
    sta.l w_level_camerastartx
    
    lda $0004,x
    sta.l w_level_camerastarty
    
    lda $0006,x
    sta.l w_level_playerstartx
    
    lda $0008,x
    sta.l w_level_playerstarty
    
    lda $000a,x
    sta.l w_level_objlist_ptr
    
    lda $000c,x
    sta.l w_level_collisionmap_ptr
    
    lda $000e,x
    sta.l w_level_faelist_ptr
    
    lda $0010,x
    sta.l w_level_hudstring_ptr
    
    plb
    rts
    
    .notgameplay:
    
    lda $0002,x
    sta.l w_scene_strptr        ;eventually, script (list of text pointers)
    
    lda $0004,x
    and #$00ff
    sta.l w_scene_strline       ;what line to start text on
    
    lda $0005,x
    sta.l w_scene_hdmaobj       ;not currently implemented
    
    lda $0007,x
    sta.l w_scene_scrolltextptr ;ptr to scroll commands in strings.asm
    
    plb
    rts
    
    .long: {
        jsr scenetransition
        rtl
    }
}

;===========================================================================================
;=================== STATE 7:   L O A D N O N G A M E P L A Y S C E N E ====================
;===========================================================================================
;assumes that a call to scenetransition has been done


loadnongameplayscene: {
    sei
    jsr waitfornmi
    jsr screenoff
    jsr disablenmi
    
    stz w_hdma_enable
    stz w_glow_enable
    stz w_scene_timer
    
    stz w_bg1xscroll
    
    lda #$03ff
    sta w_bg1yscroll
    
    jsl load_scene
    
    stz w_msg_scrollindex
    stz w_msg_scrollpixels
    
    lda #!state_nongamehandler
    sta w_programstate
    
    jsr layer3on
    jsr spritesoff
    
    jsr enablenmi
    jsr waitfornmi
    jsr fadein
    
    rts
}

;===========================================================================================
;======================= STATE 6:    N O N G A M E P L A Y H A N D L E R ===================
;===========================================================================================
;handles dialogue scenes which aren't intro scenes
;goes from gameplay back to gameplay
;assumes w_nextscene has been set to the room we are going to return to

nongameplayhandler: {
    sei
    lda w_scene_timer
    bne +
    stz w_bg3yscroll
    
    ldx w_scene_strptr
    ldy w_scene_strline
    jsl msg_display
    +
    
    ;lda w_scene_scrolltextptr
    ;beq +
    ;jsl msg_scroll_main
    ;+
    
    lda w_controller
    beq +
    {
        ldx w_nextscene
        jsr scenetransition
        
        lda #!state_loadgame
        sta w_programstate
        
        jsr fadeout
    }
    +
    
    inc w_scene_timer
    
    rts
}


;===========================================================================================
;========================== STATE 2:   L O A D I N T R O S C E N E =========================
;===========================================================================================
;call scenetransition first, then change state to this.


loadintroscene: {
    sei
    jsr waitfornmi
    jsr screenoff
    jsr disablenmi
    
    stz w_hdma_enable
    stz w_glow_enable
    stz w_scene_timer
    stz w_msg_scrollpixels
    
    jsl load_scene
    
    lda #!state_introhandler
    sta w_programstate
    
    jsr layer3on
    
    jsr waitfornmi
    jsr fadein
    
    rts
}

;===========================================================================================
;================================== STATE 0:   S E T U P ===================================
;===========================================================================================

;first state that is called
;initial setup for loading graphics, tilemaps

setup: {
    sei
    
    jsr waitfornmi
    jsr screenoff
    
    ;load graphics, palette, tilemap
    
    stz w_oam_index
    
    jsl hdma_clearall
    jsl glow_clearall
    
    stz w_hdma_enable
    stz w_glow_enable
    
    jsl hud_init
    jsl hud_test
    
    lda #!fade_bitmask_default
    sta w_fadebitmask
    
    lda #!fade_timer_default
    sta w_fadetimer
    
    lda #!camera_subspeed_default
    sta w_scroll_camerasubspeed
    
    lda #!camera_speed_default
    sta w_scroll_cameraspeed
    
    ldx.w #scenedef_meetsisters             ;initial intro scene pointer
    jsr scenetransition
    
    
    jsl load_bg3colortobuffer       ;bg3 palette
    ;jsl load_bg3tilemaptobuffer    ;tilemap copy to buffer
    ;jsl load_bg3tilemapupload      ;upload buffer
    jsl load_bg3tilesupload         ;bg3 tiles to vram
    jsl load_playerpal
    jsl load_playergfx
    
    lda #!player_hp_default         ;number is bcd
    sta w_player_hp ;can't do this in loadgame cause that runs every room transition
    
    lda #$01ff
    sta w_bg3yscroll
    
    stz w_msg_scrollpixels
    
    jsl obj_clearall
    
    ;ldy #glow_test
    ;jsl glow_spawn
    
    jsr enablenmi
    jsr waitfornmi
    jsr screenon
    
    lda #!state_loadintroscene      ;program state = load text scene (for intro)
    sta w_programstate
    
    rts
}

;===========================================================================================
;=============================== STATE 3:   G A M E P L A Y=================================
;===========================================================================================

;high level gameplay
;see gameplay.asm


gameplayvector: {
    
    jsl gameplay
    
    rts
}

;===========================================================================================
;=========================== STATE 1:    I N T R O H A N D L E R ===========================
;===========================================================================================


introhandler: {
    ;lda w_scene_hdmaobj
    ;beq +
    ;lda #$0001
    ;sta w_hdma_enable
    ;bra ++
    ;+
    ;stz w_hdma_enable
    ;++
    
    sei
    
    lda w_scene_timer
    bne +
    {
        stz w_bg3yscroll
        jsr layer3on
        
        ldx w_scene_strptr
        ldy w_scene_strline
        jsl msg_display
    }
    +
    
    inc w_scene_timer
    
    lda w_scene_scrolltextptr
    beq +
    jsl msg_scroll_main
    +
    
    lda w_controller
    bit #!controller_no_dpad
    beq .return
    {
        lda w_testsceneindex
        inc
        sta w_testsceneindex            ;advance scene index
        
        lda w_testsceneindex
        asl
        tax
        lda.l introhandler_testtable,x
        tax
        jsr scenetransition             ;initiate scene change
        
        lda w_scene_mode
        sta w_programstate
        
        jsr fadeout
        jsl msg_reset
    }
    .return:
    rts
    
    
    .testtable: {
        dw scenedef_meetsisters,        ;0
           scenedef_bloodlotus,         ;1
           scenedef_flamecircle,        ;2
           scenedef_city,               ;3
           scenedef_room1,              ;4
           scenedef_room2               ;5
    }
}


;===========================================================================================
;================================ STATE 4:   L O A D G A M E ===============================
;===========================================================================================

;set up gameplay
;relies on the scene area of memory being populated by a call to
;'scenetransition' having been done, probably immediately prior
;is used for setting up gameplay for the first time and also
;for doing room transitions between two gameplay rooms

loadgame: {
    jsr disablenmi
    jsr screenoff
    sei
    
    phk
    plb
    
    jsl load_scene                  ;depends on a call to scenetransition having been done
    
    ;stz w_hdma_enable
    
    stz w_hud_glow
    jsl hud_handleglow
    
    stz w_oam_index
    jsl oam_cleanbuffer
    jsl oam_cleanhibytebuffer
    
    ;initialize scroll
    stz w_scroll_direction
    
    lda #!scroll_upbound_default
    sta w_scroll_upbound
    
    lda #!scroll_downbound_default
    sta w_scroll_downbound
    
    lda #!scroll_leftbound_default
    sta w_scroll_leftbound
    
    lda #!scroll_rightbound_default
    sta w_scroll_rightbound
    
    ;initialize message tilemap
    jsr layer3off
    jsl msg_cleartilemap
    lda #$0001
    sta w_msg_uploadflag
    lda #$0800
    sta w_msg_size
    
    jsl speech_clear
    
    jsl player_init
    
    jsl hud_writeroomstring
    
    lda #w_player_hp
    ldx #$0007
    jsl hud_writethreedigitnumber
    
    jsl hud_draw
    
    sep #$20
    {
        lda w_mainscreenlayers
        ora #%00010000
        sta w_mainscreenlayers
        
        ;lda #%00100001
        ;sta w_colormathlayers
        
        ;lda #%00000010
        ;sta w_colormathlogic
    }
    rep #$20
    
    ;jsl load_bg2test
    
    lda w_level_camerastartx
    sta w_level_camerax
    sta w_bg1xscroll
    
    lda w_level_camerastarty
    sta w_level_cameray
    sta w_bg1yscroll
    
    jsl load_collisionmap
    
    jsl obj_clearall
    jsl obj_spawnall
    jsl obj_runinit
    jsl obj_drawall
    
    jsl player_main
    jsl scroll_main
    
    jsl fae_clearall
    jsl fae_spawnall
    jsl fae_top
    
    jsl shot_clearall
    
    jsl oam_cleanbuffer
    jsl oam_constructhibuffer
    jsl oam_uploadbuffer
    
    lda #$0001
    sta w_irq_command
    jsr irq_settarget
    jsr irq_enable
    cli
    
    jsr enablenmi
    jsr waitfornmi
    jsr fadein
    jsr screenon
    
    lda #!state_gameplay
    sta w_programstate
    
    rts
}

;===========================================================================================
;===================== STATE 7:   S E T U P G A M E O V E R S C R E E N ====================
;===========================================================================================

setupgameoverscreen: {
    sei
    jsr irq_disable
    jsr disablenmi
    jsr screenoff
    
    ;do vram transfurs
    
    ; ============================= tilemap =============================
    lda #bank(gameoverdata)     ;tilemap bank
    sta p_2
        
    lda #gameoverdata_map       ;tilemap pointer
    sta p_0
        
    lda #$0800                  ;tilemap size
    jsl load_romtolevelbuffer   ;copy tilemap to level buffer
    
    lda #$0800                  ;tilemap size
    ldx #!bg1tilemap            ;destination in vram
    jsl load_levelbuffertovram  ;dma tilemap to vram
    
    ; ========================= bg2 tilemap =============================
    lda #bank(gameoverdata)     ;tilemap bank
    sta p_2
        
    lda #gameoverdata_bg2map    ;tilemap pointer
    sta p_0
        
    lda #$0800                  ;tilemap size
    jsl load_romtolevelbuffer   ;copy tilemap to level buffer
   
    lda #$0800                  ;tilemap size
    ldx #!bg2tilemap            ;destination in vram
    jsl load_levelbuffertovram  ;dma tilemap to vram
    
    ; =========================== graphics ==============================
    
    lda #bank(gameoverdata)             ;graphics bank
    sta p_2
    
    lda #gameoverdata_gfx               ;gfx pointer
    sta p_0
    
    lda #datasize(gameoverdata_gfx)     ;gfx size
    jsl load_romtobuffer                ;copy gfx to buffer
    
    lda #datasize(gameoverdata_gfx)     ;gfx size
    ldx #!bg1tiles                      ;destination in vram
    jsl load_buffertovram               ;dma gfx to vram
    
    ; ============================= palette =============================
    
    lda #bank(gameoverdata)
    ldx #gameoverdata_pal
    jsl load_romtocolorbuffer
    
    lda #$01ff
    sta w_bg1yscroll
    stz w_bg1xscroll
    
    stz w_bg2xscroll
    stz w_bg2yscroll
    
    stz w_oam_index
    jsl oam_cleanbuffer
    jsl oam_cleanhibytebuffer
    jsl oam_constructhibuffer
    
    sep #$20
    {
        ;lda.b #!bg1tileshifted|(!spritegfxshifted<<4)     ;sprites and bg2 use same graphics here
        ;sta $210b
        
        lda #%00000010
        sta w_colormathlogic
        sta $2130
        
        lda #%10000011      ;color math layers: 1, 2; subtractive mode
        sta w_colormathlayers
        sta $2131
        
        lda #%00010001      ;main screen layers: 1
        sta w_mainscreenlayers
        sta $212c
        
        lda #%00000000      ;subscreen layers: nothing
        sta w_subscreenlayers
        sta $212d
    }
    rep #$20
    
    jsr enablenmi
    jsr waitfornmi
    jsr fadein
    jsr screenon
    
    lda #!state_handlegameoverscreen
    sta w_programstate
    
    rts
}

;===========================================================================================
;=================== STATE 8:   H A N D L E G A M E O V E R S C R E E N ====================
;===========================================================================================

handlegameoverscreen: {
    ;see gameover.asm
    
    jsl gameover_main
    
    rts
}

;===========================================================================================
;==================== routines for turning layers on and off ===============================
;===========================================================================================

spritesoff: {
    sep #$20
    
    lda w_mainscreenlayers
    and #%11101111
    sta w_mainscreenlayers
    
    rep #$20
    rts
}


layer3on: {
    sep #$20
    lda w_mainscreenlayers
    ora #%00000100
    sta w_mainscreenlayers
    rep #$20
    
    rts
    
    .long: {
        jsr layer3on
        rtl
    }
}


layer3off: {
    sep #$20
    lda w_mainscreenlayers
    and #%11111011
    sta w_mainscreenlayers
    rep #$20
    
    rts
    
    .long: {
        jsr layer3off
        rtl
    }
}

;===========================================================================================
;============================= fade in and out routines ====================================
;===========================================================================================


fadeout: {
    ;screen must be ON when this is called
    jsr enablenmi
    jsr screenon        ;in fact just do this to be sure
    
    -
    jsr waitfornmi
    
    lda w_nmicounter
    bit w_fadebitmask
    beq -
    
    lda w_screenbrightness
    dec
    sta w_screenbrightness
    bne -
    
    jsr screenoff
    rts
    
    .long: {
        jsr fadeout
        rtl
    }
}


fadein: {
    jsr enablenmi
    stz w_screenbrightness
    
    -
    jsr waitfornmi
    
    lda w_nmicounter
    bit w_fadebitmask
    beq -
    
    lda w_screenbrightness
    inc
    sta w_screenbrightness
    cmp #$000f
    bne -
    
    ;returns with screen brightness = $0f
    jsr screenon
    rts
    
    .long: {
        jsr fadein
        rtl
    }
}