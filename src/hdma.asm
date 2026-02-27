;===========================================================================================
;========================================= HDMA ============================================
;===========================================================================================

;hdma object:
    ;init routine   ;runs once when it is created
    ;main routine   ;runs once per frame
    ;hdma target
    ;indirect or direct
    ;table source bank
    ;specify channel or let handler pick on creation
        ;(1-7, keep channel 0 for regular dma)
    


hdma: {
    .nmihandler: {
        ;look for object slots that are occupied
        ;
        
        
        ;$420c write to enable hdma
        ;one bit per channel
        
        ;for channel x:                 ;width
            ;$43x0: parameters          ;1
            ;$43x1: target              ;1
            ;$43x2: source ptr          ;2
            ;$43x4: bank                ;1
            
            ;$43x5: indirect bank       ;1
            ;$43x6: indirect addr       ;2
            
            ;$43x8: table addr          ;2 (bank is from $43x4)
            ;$43xa: line counter        ;1 (maybe we don't touch this?)
        
        rtl
    }
    
    .spawn: {
        ;a = pointer to object header
        ;returns = index of object if created
        rtl
    }
    
    .clear: {
        ;x = object index
        
        stz w_hdma_init,x
        stz w_hdma_routine,x
        stz w_hdma_timer,x
        stz w_hdma_table,x
        
        sep #$20
        {
            stz w_hdma_bank,x
            stz w_hdma_target,x
            stz w_hdma_channel,x
            stz w_hdma_params,x
        }
        rep #$20
        
        rts
    }
}