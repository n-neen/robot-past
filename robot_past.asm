hirom

optimize dp always
optimize address mirrors

incsrc "./src/defines.asm"
incsrc "./src/ram_labels.asm"

;===========================================================================================
;===================================               =========================================
;===================================   B A N K S   =========================================
;===================================               =========================================
;===========================================================================================



;================================= code banks =======================================

org $808000                             ;main system bank
    incsrc "./src/boot.asm"
    incsrc "./src/main.asm"
    incsrc "./src/gameplay.asm"
    incsrc "./src/interrupts.asm"
    incsrc "./src/dma.asm"
    incsrc "./src/oam.asm"
    incsrc "./src/hdma.asm"             ;broken, unfinished
    incsrc "./src/scroll.asm"
    incsrc "./src/loading.asm"
    incsrc "./src/player.asm"
    incsrc "./src/color_cycling.asm"    ;broken, unfinished
    incsrc "./src/messagebox.asm"
    incsrc "./src/objects.asm"          ;also contains inc for obj_def.asm for individual objects
    incsrc "./src/hud.asm"
    incsrc "./src/shot.asm"
    incsrc "./src/shot/bubble.asm"
    print "80 end: ", pc, " main system bank"
    
org $818000
    incsrc "./src/fae/fae.asm"
    incsrc "./src/fae/common.asm"
    incsrc "./src/fae/test.asm"
    incsrc "./src/fae/arrow.asm"
    incsrc "./src/fae/explosion.asm"
    print "81 end: ", pc, " fae code, spritemaps"
    
;================================= data banks =======================================
    
org $c00000                             ;bank for scenes, dialog and room data
    incsrc "./data/inc/scenedefs.asm"
    incsrc "./data/inc/objlists.asm"
    incsrc "./data/inc/faelists.asm"
    incsrc "./data/inc/strings.asm"
    print "c0 end: ", pc, " scenedef, obj/fae lists, strings"
    
org $c10000
    incsrc "./data/inc/c1.asm"
    print "c1 end: ", pc
    
org $c20000
    incsrc "./data/inc/c2.asm"
    print "c2 end: ", pc
    
org $c30000
    incsrc "./data/inc/c3.asm"
    print "c3 end: ", pc

org $c40000
    incsrc "./data/inc/c4.asm"
    print "c4 end: ", pc
    
org $c50000
    incsrc "./data/inc/c5.asm"
    print "c5 end: ", pc
    
org $c60000
    incsrc "./data/inc/c6.asm"
    print "c6 end: ", pc
    
org $c70000
    incsrc "./data/inc/c7.asm"
    print "c7 end: ", pc
    
org $c80000
    incsrc "./data/inc/collision_maps.asm"
    print "c8 end: ", pc, " collision maps"
    
org $c90000
    ;
    print "c9 end: ", pc
    
org $ca0000
    ;
    print "ca end: ", pc
    
org $cb0000
    ;
    print "cb end: ", pc
    
org $cc0000
    ;
    print "cc end: ", pc
    
org $cd0000
    ;
    print "cd end: ", pc
    
org $ce0000
    ;
    print "ce end: ", pc
    
org $cf0000
    ;
    print "cf end: ", pc
    
    
    ;pad the rom
    ;checksum will not calculate correctly if we don't have a whole bank
    ;at the end of the rom
    
org $cfffff
    db $00

;===========================================================================================
;==================================               ==========================================
;==================================  H E A D E R  ==========================================
;==================================               ==========================================
;===========================================================================================


org $c0ffc0                             ;game header
    db "robot past           "          ;cartridge name
    db $31                              ;fastrom, hirom
    db $02                              ;rom + ram + sram
    db $0a                              ;rom size = 1mb
    db $00                              ;sram size 0
    db $00                              ;country code
    db $ff                              ;developer code
    db $00                              ;rom version
    dw $FFFF                            ;checksum complement
    dw $FFFF                            ;checksum
    
    ;interrupt vectors
    
    ;native mode
    dw errhandle, errhandle, errhandle, errhandle, errhandle, nmi, errhandle, irq
    
    ;emulation mode
    dw errhandle, errhandle, errhandle, errhandle, errhandle, errhandle, boot, errhandle