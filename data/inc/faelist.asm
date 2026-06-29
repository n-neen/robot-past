faelist: {
    macro fae_list_entry(type, x, y, var1, var2, var3)
        dw <type>
        dw <x>
        dw <y>
        dw <var1>
        dw <var2>
        dw <var3>
    endmacro
    
    .definitionstart:
        ;this is used in defines.asm to determine the length of each entry
                        ;type       x      y      var1   var2   var3
        %fae_list_entry (fae_test, $0080, $0080, $0000, $0000, $0000)
    .definitionend:
    
;========================================== fae lists ======================================
    
    
    .room1:
                        ;type       x      y      var1   var2   var3
        %fae_list_entry (fae_test, $0080, $0080, $0001, $0000, $0000)
        %fae_list_entry (fae_test, $0090, $0090, $0002, $0000, $0000)
        %fae_list_entry (fae_test, $00b0, $00b0, $0003, $0000, $0000)
        dw $ffff
        
    .room2:
                        ;type        x      y      var1   var2   var3
        %fae_list_entry (fae_test,  $0180, $0080, $0000, $0000, $0000)
        %fae_list_entry (fae_arrow, $0180, $0040, $0000, $0000, $0000)
        dw $ffff
        
    .icecave1:
                        ;type       x      y      var1   var2   var3
        %fae_list_entry (fae_test, $0180, $0180, $0000, $0000, $0000)
        dw $ffff
}