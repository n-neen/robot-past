

org $00

p: {
    ;0-f are reserved for pseudoregisters
    
    .0  : skip 2
    .1  : skip 2
    .2  : skip 2
    .3  : skip 2
    .4  : skip 2
    .5  : skip 2
    .6  : skip 2
    .7  : skip 2
}

;======================================= direct page =======================================

d: {
    ;
    ;todo
    ;
}


org $7e0100

;========================================= work ram ========================================

w: {                                    ;w
    .nmicounter         : skip 2
    .nmiflag            : skip 2
    .lagcounter         : skip 2
    
    .screenbrightness   : skip 2
    
    ;dma arguments
    .dmabaseaddr        : skip 2
    .dmasrcptr          : skip 2
    .dmasrcbank         : skip 2
    .dmasize            : skip 2
    
    .controller         : skip 2
    .programstate       : skip 2
    
    
    org $7e1000
    .hdma: {                           ;w_hdma
        ;object independent
        ..channels: skip 2
        ..enable:   skip 2

        ;object arrays
        !k_hdma_objects_count #=   $0007
        ..id:       skip 2*!k_hdma_objects_count+2
        ..init:     skip 2*!k_hdma_objects_count+2
        ..routine:  skip 2*!k_hdma_objects_count+2
        ..timer:    skip 2*!k_hdma_objects_count+2
        ..table:    skip 2*!k_hdma_objects_count+2
        ..params:   skip 2*!k_hdma_objects_count+2 ;for $4300 and $4301 write at once
        ..var:      skip 2*!k_hdma_objects_count+2
        
        ..bank:     skip 1*!k_hdma_objects_count
        
    }
    
    org $7ec000
    .cgrambuffer        : skip !k_cgrambuffersize
}
