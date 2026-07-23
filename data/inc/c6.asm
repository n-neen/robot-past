;ice cave levels


entrance: {
    .pal:   incbin "./data/pal/entrance.pal"
    .gfx:   incbin "./data/gfx/entrance.gfx"
    .map:   incbin "./data/map/entrance.map"
    
    .props:
        ;unused, whoops
        dw $ffff
}

icecave1: {
    ;uses palette and graphics from above
    .map:   incbin "./data/map/ice_cave1_1.map"
            incbin "./data/map/ice_cave1_2.map"
            incbin "./data/map/ice_cave1_3.map"
            incbin "./data/map/ice_cave1_4.map"
}

icecave2: {
    .map: incbin "./data/map/ice_cave2_1.map"
          incbin "./data/map/ice_cave2_2.map"
          incbin "./data/map/ice_cave2_3.map"
          incbin "./data/map/ice_cave2_4.map"
}

icecave3: {
    .map: incbin "./data/map/ice_cave2_1.map"
          incbin "./data/map/ice_cave2_2.map"
          incbin "./data/map/ice_cave2_3.map"
          incbin "./data/map/ice_cave2_4.map"
}

icecave4: {
    .map: incbin "./data/map/ice_cave2_1.map"
          incbin "./data/map/ice_cave2_2.map"
          incbin "./data/map/ice_cave2_3.map"
          incbin "./data/map/ice_cave2_4.map"
}

icecave5: {
    .map: incbin "./data/map/ice_cave2_1.map"
          incbin "./data/map/ice_cave2_2.map"
}

dummylabel:
    ;this is the last label in the project so need this to calculate the above size