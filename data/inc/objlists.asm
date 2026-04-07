objlist: {
    macro obj_list_entry(type, x, y, var1, var2, var3)
        dw <type>
        db <x>
        db <y>
        dw <var1>
        dw <var2>
        dw <var3>
    endmacro
    
    .definitionstart:
        ;this is used in defines.asm to determine the length of each entry
                        ;type       x   y    var1   var2   var3
        %obj_list_entry (obj_door, $10, $50, $1111, $2222, scenedef_room2)
    .definitionend:
    
    .room1: {
                         ;type,     x    y    var1,  var2,  var3
        %obj_list_entry (obj_door, $33, $3b, $0234, $2222, scenedef_room2)
        dw $ffff    ;terminator
    }
    
    .room2: {
                        ;type,             x    y   var1,  var2,  var3
        %obj_list_entry (obj_door,        $1a, $13, $0234, $0223, scenedef_room1)
        %obj_list_entry (obj_texttrigger, $1a, $33, $2012, $0122, msg_testtext)
        %obj_list_entry (obj_texttrigger, $0a, $16, $0234, $0122, msg_testtext)
        dw $ffff    ;terminator
    }
}
