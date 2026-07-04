;top level label is 'fae'

.common:
    ..explode: {
        lda #fae_explosion
        sta w_fae_id,x
        
        lda #fae_explosion_main
        sta w_fae_mainptr,x
        
        stz w_fae_touchptr,x
        
        lda #datasize(fae_explosion_spritemaplist)/2
        sta w_fae_var1,x
        
        rts
    }
    
    ..bounce: {
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