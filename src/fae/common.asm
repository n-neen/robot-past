;top level label is 'fae'

.common:
    ..explode: {
        ;only currently tested calling this from touch reaction
        ;but it could maybe be called from main too?
        ;eventually we'll have shot reactions and that's the main place it'll go
        
        ;changes the fae's identity, main routine to that of the explosion
        ;also needs to stop touch routine from running repeatedly
        ;(and eventually when shot reactions exist, zero that pointer too)
        ;var1 is used as an index into spritemap list for running animation
        
        lda #fae_explosion
        sta w_fae_id,x
        
        lda #fae_explosion_main
        sta w_fae_mainptr,x
        
        stz w_fae_touchptr,x
        
        lda #datasize(fae_explosion_spritemaplist)/2
        sta w_fae_var1,x
        
        ;could set init and run it here too, but i dcurrently don't have a use for that
        
        rts
    }
    
    
    ..normalhit: {
        ;touch reaction
        
        lda #$00c0
        sta w_player_iframes
        
        ;write some structure to "how much contact damage and enemy does"
        
        ;lda w_player_hp
        ;sec
        ;sec w_fae_contactdamage,x
        ;sta w_player_hp
        
        ;or
        
        ;phx
        ;lda w_fae_id,x
        ;tax
        ;lda.l (bank(fae)<<16)+!contactdamage,x     ;!contactdamage is how far into the header it is
        ;sta p_0
        ;lda w_player_hp
        ;sec
        ;sbc p_0
        ;sta w_player_hp
        ;plx
        ;
        
        
        rts
    }
    
    
    ..bounce: {
        ;touch reaction
        lda w_player_yspeed
        eor #$ffff
        inc
        sta w_player_yspeed
        
        lda w_player_xspeed
        eor #$ffff
        inc
        sta w_player_xspeed
        
        rts
    }
}