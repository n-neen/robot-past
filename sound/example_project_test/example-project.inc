;; Song and Sound Effect asar enums for example-project.terrificaudio.
;;
;; Automatically generated using `tad-compiler asar-enums` or `tad-compiler asar-export`.
;;
;; This file MUST BE recreated if song list or sound effect export order changes.
;;


!LAST_SONG_ID = 24
!N_SOUND_EFFECTS = 19

;; Song enum.
;; Input argument for `Tad_LoadSong`
  !Song_BLANK = 0 ; blank (silent) song
  !Song_gimo_297 = 1
  !Song_ode_to_joy = 2
  !Song_chords = 3
  !Song_chords_transpose = 4
  !Song_broken_chord = 5
  !Song_quantize_with_temp_gain = 6
  !Song_early_release = 7
  !Song_echo = 8
  !Song_samples = 9
  !Song_play_pitch = 10
  !Song_portamento = 11
  !Song_continuous_portamento = 12
  !Song_vibrato = 13
  !Song_tremolo = 14
  !Song_volume_slide = 15
  !Song_pan = 16
  !Song_panbrello = 17
  !Song_pan_slide = 18
  !Song_play_noise = 19
  !Song_multi_channel_noise = 20
  !Song_detune = 21
  !Song_pitch_modulation = 22
  !Song_fir = 23
  !Song_bc_asm_in_mml = 24


;; Sound Effects enum.
;; Input argument for `Tad_QueueSoundEffect` and `Tad_QueuePannedSoundEffect`
; high-priority sound effects
  !SFX_player_hurt_low_health = 0
; normal-priority sound effects
  !SFX_menu_cursor = 1
  !SFX_menu_select = 2
  !SFX_menu_incorrect = 3
  !SFX_player_hurt = 4
  !SFX_jump = 5
  !SFX_vibrato_alarm = 6
  !SFX_play_samples_bytecode = 7
  !SFX_spawn_item = 8
  !SFX_collect_coin = 9
  !SFX_robot_notices_player = 10
  !SFX_robot_ascend = 11
  !SFX_robot_fires_laser = 12
  !SFX_fire_arrow = 13
  !SFX_noise = 14
  !SFX_sfx_calling_subroutine_asm = 15
  !SFX_sfx_calling_subroutine_mml = 16
; low-priority sound effects
  !SFX_low_priority_beep = 17
  !SFX_low_priority_long = 18
