        ;$420c write to enable hdma
        ;one bit per channel
        
        ;for channel x:                 ;width
            ;$43x0: parameters          ;1  ;combine into one 16 write
            ;$43x1: target              ;1
            
            ;$43x2: source ptr          ;2  table start address
            ;$43x4: bank                ;1
            
            ;$43x5: indirect bank       ;1
            ;$43x6: indirect addr       ;2
            
            
            
            
            ;dont need to touch for basic config?
            ;$43x8: table counter       ;2 (bank is from $43x4)
            ;$43xa: line counter        ;1 (maybe we don't touch this?)