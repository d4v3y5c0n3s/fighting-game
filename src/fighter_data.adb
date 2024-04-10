with allegro5_bitmap_io_h; use allegro5_bitmap_io_h;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with Move;
with allegro_audio_h; use allegro_audio_h;
with Extended_Bitmap;
with Projectile;

package body Fighter_Data is
  
  function Load_Fighter (F : Fighter_Options) return Fighter.Fighter is
    jump_sound_path : constant String := "assets/jump_sound.flac";
    data : Fighter.Fighter;
  begin
    data.extended_bitmaps := (case F is
      when others =>
        new Fighter.Extended_Bitmap_Array'(
          0 => Extended_Bitmap.Extended_Bitmap'(
            pos => Position'(100.0, -32.0),
            graphic => al_load_bitmap(New_String("assets/temp_stage_char_icon.png")),
            graphic_width => 64.0, graphic_height => 64.0,
            active_anim => new Animation_Data'(
              0 => Animation_Frame'(x_start => 0.0, y_start => 0.0, frame_dration => 1)
            ),
            anim_index => 0,
            anim_frame => 0,
            x_offset => -32.0,
            shown => false
          ),
          1 => Extended_Bitmap.Extended_Bitmap'(
            pos => Position'(150.0, -32.0),
            graphic => al_load_bitmap(New_String("assets/temp_stage_char_icon.png")),
            graphic_width => 64.0, graphic_height => 64.0,
            active_anim => new Animation_Data'(
              0 => Animation_Frame'(x_start => 0.0, y_start => 0.0, frame_dration => 1)
            ),
            anim_index => 0,
            anim_frame => 0,
            x_offset => -32.0,
            shown => false
          )
        )
    );
    
    data.projectiles := (case F is
      when others =>
        new Fighter.Projectile_Array'(0 => Projectile.Make_Projectile(
          Position'(X => 0.0, Y => -50.0),
          Projectile.To_Add_Hitboxes'(0 => Hitbox'(
            effect => Attack,
            grab_opponent_steps_index => 0,
            identity => 0,
            shape => Circle'(pos => Position'(X => 30.0, Y => -30.0), radius => 40.0),
            hit => false,
            damage => 22,
            knockback_vertical => 30.0,
            knockback_horizontal => 13.0,
            knockback_duration => 2,
            hitstun_duration => 11
          )),
          Position'(X => 8.0, Y => -7.0),
          al_load_bitmap(New_String("assets/temp_stage_char_icon.png")),
          64.0, 64.0,
          -32.0,
          new Animation_Data'(
            0 => Animation_Frame'(x_start => 0.0, y_start => 0.0, frame_dration => 1)
          ),
          20
        ))
    );
    
    data.upper_hitbox := (case F is
      when Shambler =>
        Circle'(pos => Position'(X => 0.0, Y => -45.0), radius => 45.0),
      when Test =>
        Circle'(pos => Position'(X => 0.0, Y => -45.0), radius => 45.0)
    );
    
    data.lower_hitbox := (case F is
      when Shambler =>
        Circle'(pos => Position'(X => 0.0, Y => 55.0), radius => 45.0),
      when Test =>
        Circle'(pos => Position'(X => 0.0, Y => 55.0), radius => 45.0)
    );
    
    data.sounds := (case F is
      when others =>
        new Fighter.Fighter_Sounds'(0 => Fighter.Single_Sound'(value => al_load_sample(New_String("assets/test_audio.flac"))))
    );
    
    data.sprite_data := al_load_bitmap(New_String(
    (case F is
      when Shambler =>
        "assets/shambler.png",
      when Test =>
        "assets/test_fighter.png"
    )
    ));
    
    data.start_crouch_steps := (case F is
      when Shambler =>
        new Move.Move_Step_Array'(0 => new Move.Move_Step'(frame_duration => 3, operations => new Move.Move_Sub_Step_Collection'(
          0 => new Move.Move_Sub_Step'(
            O => Move.Play_Animation,
            anim => new Animation_Data'(
              0 => Animation_Frame'(x_start => 600.0, y_start => 200.0, frame_dration => 3)
            )
          ),
          1 => new Move.Move_Sub_Step'(
            O => Move.Move_Upper_Hitbox,
            upper_offset => Position'(X => 0.0, Y => 50.0)
          )
        ))),
      when Test =>
        new Move.Move_Step_Array'(
          0 => new Move.Move_Step'(frame_duration => 5, operations => new Move.Move_Sub_Step_Collection'(
            0 => new Move.Move_Sub_Step'(
              O => Move.Play_Animation,
              anim => new Animation_Data'(
                0 => Animation_Frame'(x_start => 200.0, y_start => 0.0, frame_dration => 5)
              )
            )
          ))
        )
    );
    
    data.start_uncrouch_steps := (case F is
      when Shambler =>
        new Move.Move_Step_Array'(0 => new Move.Move_Step'(frame_duration => 3, operations => new Move.Move_Sub_Step_Collection'(
          0 => new Move.Move_Sub_Step'(
            O => Move.Play_Animation,
            anim => new Animation_Data'(
              0 => Animation_Frame'(x_start => 600.0, y_start => 200.0, frame_dration => 3)
            )
          )
        ))),
      when Test =>
        new Move.Move_Step_Array'(
          0 => new Move.Move_Step'(frame_duration => 5, operations => new Move.Move_Sub_Step_Collection'(
            0 => new Move.Move_Sub_Step'(
              O => Move.Play_Animation,
              anim => new Animation_Data'(
                0 => Animation_Frame'(x_start => 200.0, y_start => 0.0, frame_dration => 5)
              )
            )
          ))
        )
    );
    
    data.idle_crouch_steps := (case F is
      when Shambler =>
        new Move.Move_Step_Array'(0 => new Move.Move_Step'(frame_duration => 1, operations => new Move.Move_Sub_Step_Collection'(
          0 => new Move.Move_Sub_Step'(
            O => Move.Play_Animation,
            anim => new Animation_Data'(
              0 => Animation_Frame'(x_start => 600.0, y_start => 200.0, frame_dration => 3)
            )
          ),
          1 => new Move.Move_Sub_Step'(
            O => Move.Move_Upper_Hitbox,
            upper_offset => Position'(X => 0.0, Y => 50.0)
          )
        ))),
      when Test =>
        new Move.Move_Step_Array'(
          0 => new Move.Move_Step'(frame_duration => 1, operations => new Move.Move_Sub_Step_Collection'(
            0 => new Move.Move_Sub_Step'(
              O => Move.Play_Animation,
              anim => new Animation_Data'(
                0 => Animation_Frame'(x_start => 0.0, y_start => 200.0, frame_dration => 1)
              )
            ),
            1 => new Move.Move_Sub_Step'(
              O => Move.Move_Lower_Hitbox,
              lower_offset => Position'(X => 150.0, Y => 0.0)
            )
          ))
        )
    );
    
    data.idle_stand_steps := (case F is
      when Shambler =>
        new Move.Move_Step_Array'(0 => new Move.Move_Step'(frame_duration => 4, operations => new Move.Move_Sub_Step_Collection'(
          0 => new Move.Move_Sub_Step'(
            O => Move.Play_Animation,
            anim => new Animation_Data'(
              Animation_Frame'(x_start => 0.0, y_start => 0.0, frame_dration => 2),
              Animation_Frame'(x_start => 200.0, y_start => 0.0, frame_dration => 2)
            )
          )
        ))),
      when Test =>
        new Move.Move_Step_Array'(
          0 => new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
            0 => new Move.Move_Sub_Step'(
              O => Move.Play_Animation,
              anim => new Animation_Data'(
                Animation_Frame'(x_start => 0.0, y_start => 0.0, frame_dration => 5),
                Animation_Frame'(x_start => 400.0, y_start => 0.0, frame_dration => 5)
              )
            )
          ))
        )
    );
    
    data.on_hit_steps := (case F is
      when Shambler =>
        new Move.Move_Step_Array'(0 => new Move.Move_Step'(frame_duration => 4, operations => new Move.Move_Sub_Step_Collection'(
          0 => new Move.Move_Sub_Step'(
            O => Move.Play_Animation,
            anim => new Animation_Data'(
              0 => Animation_Frame'(x_start => 400.0, y_start => 400.0, frame_dration => 4)
            )
          )
        ))),
      when Test =>
        new Move.Move_Step_Array'(
          0 => new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
            0 => new Move.Move_Sub_Step'(
              O => Move.Play_Animation,
              anim => new Animation_Data'(
                0 => Animation_Frame'(x_start => 200.0, y_start => 200.0, frame_dration => 10)
              )
            )
          ))
        )
    );
    
    data.standing_block_steps := (case F is
      when Shambler =>
        new Move.Move_Step_Array'(0 => new Move.Move_Step'(frame_duration => 4, operations => new Move.Move_Sub_Step_Collection'(
          0 => new Move.Move_Sub_Step'(
            O => Move.Play_Animation,
            anim => new Animation_Data'(
              0 => Animation_Frame'(x_start => 0.0, y_start => 400.0, frame_dration => 4)
            )
          )
        ))),
      when Test =>
        new Move.Move_Step_Array'(
          0 => new Move.Move_Step'(frame_duration => 5, operations => new Move.Move_Sub_Step_Collection'(
            0 => new Move.Move_Sub_Step'(
              O => Move.Play_Animation,
              anim => new Animation_Data'(
                0 => Animation_Frame'(x_start => 400.0, y_start => 200.0, frame_dration => 5)
              )
            )
          ))
        )
    );
    
    data.crouching_block_steps := (case F is
      when Shambler =>
        new Move.Move_Step_Array'(0 => new Move.Move_Step'(frame_duration => 4, operations => new Move.Move_Sub_Step_Collection'(
          0 => new Move.Move_Sub_Step'(
            O => Move.Play_Animation,
            anim => new Animation_Data'(
              0 => Animation_Frame'(x_start => 800.0, y_start => 200.0, frame_dration => 4)
            )
          )
        ))),
      when Test =>
        new Move.Move_Step_Array'(
          0 => new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
            0 => new Move.Move_Sub_Step'(
              O => Move.Play_Animation,
              anim => new Animation_Data'(
                Animation_Frame'(x_start => 0.0, y_start => 0.0, frame_dration => 5),
                Animation_Frame'(x_start => 400.0, y_start => 0.0, frame_dration => 5)
              )
            )
          ))
        )
    );
    
    data.grab_actions_steps := (case F is
      when Shambler =>
        new Fighter.Move_Steps_Collection'(0 => new Move.Move_Step_Array'(
          0 => new Move.Move_Step'(
            frame_duration => 3,
            operations => new Move.Move_Sub_Step_Collection'(
              0 => new Move.Move_Sub_Step'(
                O => Move.Dash,
                dash_duration => 3,
                dash_vertical => 20.0,
                dash_horizontal => 20.0
              )
            )
          )
        )),
      when Test =>
        new Fighter.Move_Steps_Collection'(
          0 => new Move.Move_Step_Array'(
            0 => new Move.Move_Step'(
              frame_duration => 3,
              operations => new Move.Move_Sub_Step_Collection'(
                0 => new Move.Move_Sub_Step'(
                  O => Move.Dash,
                  dash_duration => 3,
                  dash_vertical => 20.0,
                  dash_horizontal => 20.0
                )
              )
            )
          )
        )
    );
    
    data.grabbed_opponent_reactions_steps := (case F is
      when Shambler =>
        new Fighter.Move_Steps_Collection'(0 => new Move.Move_Step_Array'(
          0 => new Move.Move_Step'(
            frame_duration => 6,
            operations => new Move.Move_Sub_Step_Collection'(
              0 => new Move.Move_Sub_Step'(
                O => Move.Dash,
                dash_duration => 3,
                dash_vertical => 20.0,
                dash_horizontal => -20.0
              ),
              1 => new Move.Move_Sub_Step'(
                O => Move.Dash,
                dash_duration => 3,
                dash_vertical => 30.0,
                dash_horizontal => -40.0
              )
            )
          )
        )),
      when Test =>
        new Fighter.Move_Steps_Collection'(
          0 => new Move.Move_Step_Array'(
            0 => new Move.Move_Step'(
              frame_duration => 6,
              operations => new Move.Move_Sub_Step_Collection'(
                0 => new Move.Move_Sub_Step'(
                  O => Move.Dash,
                  dash_duration => 3,
                  dash_vertical => 20.0,
                  dash_horizontal => -20.0
                ),
                1 => new Move.Move_Sub_Step'(
                  O => Move.Dash,
                  dash_duration => 3,
                  dash_vertical => 30.0,
                  dash_horizontal => -40.0
                )
              )
            )
          )
        )
    );
    
    data.on_jump_steps := (case F is
      when Shambler =>
        new Move.Move_Step_Array'(0 => new Move.Move_Step'(frame_duration => 4, operations => new Move.Move_Sub_Step_Collection'(
          0 => new Move.Move_Sub_Step'(
            O => Move.Play_Animation,
            anim => new Animation_Data'(
              Animation_Frame'(x_start => 0.0, y_start => 0.0, frame_dration => 2),
              Animation_Frame'(x_start => 200.0, y_start => 0.0, frame_dration => 2)
            )
          )
        ))),
      when Test =>
        new Move.Move_Step_Array'(
          0 => new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
            0 => new Move.Move_Sub_Step'(
              O => Move.Play_Animation,
              anim => new Animation_Data'(
                Animation_Frame'(x_start => 0.0, y_start => 0.0, frame_dration => 5),
                Animation_Frame'(x_start => 400.0, y_start => 0.0, frame_dration => 5)
              )
            )
          ))
        )
    );
    
    data.forwards_walk_steps := (case F is
      when Shambler =>
        new Move.Move_Step_Array'(0 => new Move.Move_Step'(frame_duration => 12, operations => new Move.Move_Sub_Step_Collection'(
          0 => new Move.Move_Sub_Step'(
            O => Move.Play_Animation,
            anim => new Animation_Data'(
              Animation_Frame'(x_start => 400.0, y_start => 0.0, frame_dration => 4),
              Animation_Frame'(x_start => 600.0, y_start => 0.0, frame_dration => 4),
              Animation_Frame'(x_start => 800.0, y_start => 0.0, frame_dration => 4)
            )
          )
        ))),
      when Test =>
        new Move.Move_Step_Array'(
          0 => new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
            0 => new Move.Move_Sub_Step'(
              O => Move.Play_Animation,
              anim => new Animation_Data'(
                Animation_Frame'(x_start => 0.0, y_start => 0.0, frame_dration => 5),
                Animation_Frame'(x_start => 400.0, y_start => 0.0, frame_dration => 5)
              )
            )
          ))
        )
    );
    
    data.backwards_walk_steps := (case F is
      when Shambler =>
        new Move.Move_Step_Array'(0 => new Move.Move_Step'(frame_duration => 12, operations => new Move.Move_Sub_Step_Collection'(
          0 => new Move.Move_Sub_Step'(
            O => Move.Play_Animation,
            anim => new Animation_Data'(
              Animation_Frame'(x_start => 0.0, y_start => 200.0, frame_dration => 4),
              Animation_Frame'(x_start => 200.0, y_start => 200.0, frame_dration => 4),
              Animation_Frame'(x_start => 400.0, y_start => 200.0, frame_dration => 4)
            )
          )
        ))),
      when Test =>
        new Move.Move_Step_Array'(
          0 => new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
            0 => new Move.Move_Sub_Step'(
              O => Move.Play_Animation,
              anim => new Animation_Data'(
                Animation_Frame'(x_start => 0.0, y_start => 0.0, frame_dration => 5),
                Animation_Frame'(x_start => 400.0, y_start => 0.0, frame_dration => 5)
              )
            )
          ))
        )
    );
    
    data.jump_sound := (case F is
      when others =>
        al_load_sample(New_String(jump_sound_path))
    );
    
    case F is
      when Shambler =>
        
        -- grab
        Fighter.Add_Move(data,
          Move.Move'(
            command => new Move.Move_Input_Sequence'(new Input_Tree_Node'(ID => atk_1), new Input_Tree_Node'(ID => atk_4)),
            doing => Move.Grab,
            steps => new Move.Move_Step_Array'(
              new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
                0 => new Move.Move_Sub_Step'(O => Move.Play_Animation, anim => new Animation_Data'(
                  0 => Animation_Frame'(x_start => 200.0, y_start => 400.0, frame_dration => 2)
                ))
              )),
              new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
                0 => new Move.Move_Sub_Step'(O => Move.Spawn_Hitbox, hb => Hitbox'(
                  effect => Grab,
                  grab_opponent_steps_index => 0,
                  identity => 1,
                  shape => Circle'(pos => Position'(100.0, 0.0), radius => 20.0),
                  hit => false,
                  damage => 0,
                  knockback_vertical => 0.0,
                  knockback_horizontal => 0.0,
                  knockback_duration => 0,
                  hitstun_duration => 0
                ))
              )),
              new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
                0 => new Move.Move_Sub_Step'(O => Move.Despawn_Hitbox, despawn_hitbox_id => 1)
              ))
            )
          ),
        0,
        Tree_End_Conditions'(
          works_standing => true,
          works_crouching => true,
          works_midair => false
        ));
        
        -- Brain-Famished Lunge
        Fighter.Add_Move(data,
          Move.Move'(command => new Move.Move_Input_Sequence'(new Input_Tree_Node'(ID => down), new Input_Tree_Node'(ID => right), new Input_Tree_Node'(ID => atk_2)),
          doing => Move.None,
          steps => new Move.Move_Step_Array'(
            0 => new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
              0 => new Move.Move_Sub_Step'(
                O => Move.Play_Animation,
                anim => new Animation_Data'(
                  0 => Animation_Frame'(x_start => 600.0, y_start => 400.0, frame_dration => 10)
                )
              )
            )),
            1 => new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
              new Move.Move_Sub_Step'(
                O => Move.Play_Animation,
                anim => new Animation_Data'(
                  0 => Animation_Frame'(x_start => 800.0, y_start => 400.0, frame_dration => 10)
                )
              ),
              new Move.Move_Sub_Step'(
                O => Move.Spawn_Hitbox,
                hb => Hitbox'(
                  effect => Attack,
                  grab_opponent_steps_index => 0,
                  identity => 0,
                  shape => Circle'(pos => Position'(X => 30.0, Y => -30.0), radius => 40.0),
                  hit => false,
                  damage => 22,
                  knockback_vertical => 30.0,
                  knockback_horizontal => 13.0,
                  knockback_duration => 2,
                  hitstun_duration => 11
                )
              ),
              new Move.Move_Sub_Step'(
                O => Move.Dash,
                dash_duration => 10,
                dash_vertical => 0.0,
                dash_horizontal => 23.0
              )
            )),
            2 => new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
              new Move.Move_Sub_Step'(
                O => Move.Play_Animation,
                anim => new Animation_Data'(
                  0 => Animation_Frame'(x_start => 0.0, y_start => 600.0, frame_dration => 10)
                )
              ),
              new Move.Move_Sub_Step'(
                O => Move.Despawn_Hitbox,
                despawn_hitbox_id => 0
              )
            ))
          )),
          1,
          Tree_End_Conditions'(
            works_standing => true,
            works_crouching => true,
            works_midair => false
          )
        );
        
        -- Coffin Dweller's Rollout
        Fighter.Add_Move(data,
          Move.Move'(command => new Move.Move_Input_Sequence'(new Input_Tree_Node'(ID => down), new Input_Tree_Node'(ID => right), new Input_Tree_Node'(ID => atk_5)),
          doing => Move.None,
          steps => new Move.Move_Step_Array'(
            0 => new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
              0 => new Move.Move_Sub_Step'(
                O => Move.Play_Animation,
                anim => new Animation_Data'(
                  0 => Animation_Frame'(x_start => 200.0, y_start => 600.0, frame_dration => 10)
                )
              )
            )),
            1 => new Move.Move_Step'(frame_duration => 40, operations => new Move.Move_Sub_Step_Collection'(
              new Move.Move_Sub_Step'(
                O => Move.Play_Animation,
                anim => new Animation_Data'(
                  Animation_Frame'(x_start => 400.0, y_start => 600.0, frame_dration => 4),
                  Animation_Frame'(x_start => 600.0, y_start => 600.0, frame_dration => 4),
                  Animation_Frame'(x_start => 800.0, y_start => 600.0, frame_dration => 4)
                )
              ),
              new Move.Move_Sub_Step'(
                O => Move.Spawn_Hitbox,
                hb => Hitbox'(
                  effect => Attack,
                  grab_opponent_steps_index => 0,
                  identity => 0,
                  shape => Circle'(pos => Position'(X => 0.0, Y => 50.0), radius => 40.0),
                  hit => false,
                  damage => 9,
                  knockback_vertical => 5.0,
                  knockback_horizontal => -22.0,
                  knockback_duration => 2,
                  hitstun_duration => 26
                )
              ),
              new Move.Move_Sub_Step'(
                O => Move.Dash,
                dash_duration => 40,
                dash_vertical => 0.0,
                dash_horizontal => 11.0
              ),
              new Move.Move_Sub_Step'(
                O => Move.Increment_Armor,
                increment_by => 1
              )
            )),
            2 => new Move.Move_Step'(frame_duration => 6, operations => new Move.Move_Sub_Step_Collection'(
              new Move.Move_Sub_Step'(
                O => Move.Play_Animation,
                anim => new Animation_Data'(
                  0 => Animation_Frame'(x_start => 0.0, y_start => 800.0, frame_dration => 6)
                )
              ),
              new Move.Move_Sub_Step'(
                O => Move.Despawn_Hitbox,
                despawn_hitbox_id => 0
              ),
              new Move.Move_Sub_Step'(
                O => Move.Decrement_Armor,
                decrement_by => 1
              )
            ))
          )),
          2,
          Tree_End_Conditions'(
            works_standing => true,
            works_crouching => true,
            works_midair => false
          )
        );
        
        -- Anti-Human Helicopter
        Fighter.Add_Move(data,
          Move.Move'(command => new Move.Move_Input_Sequence'(new Input_Tree_Node'(ID => left), new Input_Tree_Node'(ID => right), new Input_Tree_Node'(ID => atk_1)),
          doing => Move.None,
          steps => new Move.Move_Step_Array'(
            new Move.Move_Step'(frame_duration => 7, operations => new Move.Move_Sub_Step_Collection'(
              0 => new Move.Move_Sub_Step'(
                O => Move.Play_Animation,
                anim => new Animation_Data'(
                  0 => Animation_Frame'(x_start => 200.0, y_start => 800.0, frame_dration => 7)
                )
              )
            )),
            new Move.Move_Step'(frame_duration => 24, operations => new Move.Move_Sub_Step_Collection'(
              new Move.Move_Sub_Step'(
                O => Move.Play_Animation,
                anim => new Animation_Data'(
                  Animation_Frame'(x_start => 400.0, y_start => 800.0, frame_dration => 4),
                  Animation_Frame'(x_start => 600.0, y_start => 800.0, frame_dration => 4)
                )
              ),
              new Move.Move_Sub_Step'(
                O => Move.Dash,
                dash_duration => 24,
                dash_vertical => 8.0,
                dash_horizontal => 2.0
              ),
              new Move.Move_Sub_Step'(
                O => Move.Spawn_Hitbox,
                hb => Hitbox'(
                  effect => Attack,
                  grab_opponent_steps_index => 0,
                  identity => 0,
                  shape => Circle'(pos => Position'(X => 20.0, Y => -20.0), radius => 40.0),
                  hit => false,
                  damage => 20,
                  knockback_vertical => 8.0,
                  knockback_horizontal => 2.0,
                  knockback_duration => 4,
                  hitstun_duration => 18
                )
              )
            )),
            new Move.Move_Step'(frame_duration => 26, operations => new Move.Move_Sub_Step_Collection'(
              new Move.Move_Sub_Step'(
                O => Move.Play_Animation,
                anim => new Animation_Data'(
                  0 => Animation_Frame'(x_start => 800.0, y_start => 800.0, frame_dration => 26)
                )
              ),
              new Move.Move_Sub_Step'(
                O => Move.Despawn_Hitbox,
                despawn_hitbox_id => 0
              )
            ))
          )),
          3,
          Tree_End_Conditions'(
            works_standing => true,
            works_crouching => true,
            works_midair => true
          )
        );
        
      when Test =>
        
        Fighter.Add_Move(data,
          Move.Move'(
            command => new Move.Move_Input_Sequence'(new Input_Tree_Node'(ID => atk_1), new Input_Tree_Node'(ID => atk_4)),
            doing => Move.Grab,
            steps => new Move.Move_Step_Array'(
              new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
                0 => new Move.Move_Sub_Step'(O => Move.Play_Animation, anim => new Animation_Data'(
                  0 => Animation_Frame'(x_start => 0.0, y_start => 400.0, frame_dration => 2)
                ))
              )),
              new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
                0 => new Move.Move_Sub_Step'(O => Move.Spawn_Hitbox, hb => Hitbox'(
                  effect => Grab,
                  grab_opponent_steps_index => 0,
                  identity => 1,
                  shape => Circle'(pos => Position'(100.0, 0.0), radius => 20.0),
                  hit => false,
                  damage => 0,
                  knockback_vertical => 0.0,
                  knockback_horizontal => 0.0,
                  knockback_duration => 0,
                  hitstun_duration => 0
                ))
              )),
              new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
                0 => new Move.Move_Sub_Step'(O => Move.Despawn_Hitbox, despawn_hitbox_id => 1)
              ))
            )
          ),
        0,
        Tree_End_Conditions'(
          works_standing => true,
          works_crouching => true,
          works_midair => false
        ));
        
        Fighter.Add_Move(data,
          Move.Move'(
            command => new Move.Move_Input_Sequence'(new Input_Tree_Node'(ID => up), new Input_Tree_Node'(ID => atk_1)),
            doing => Move.None,
            steps => new Move.Move_Step_Array'(
              new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
                0 => new Move.Move_Sub_Step'(O => Move.Spawn_Hitbox, hb => Hitbox'(
                  effect => Attack,
                  grab_opponent_steps_index => 0,
                  identity => 1,
                  shape => Circle'(pos => Position'(100.0, 0.0), radius => 32.0),
                  hit => false,
                  damage => 20,
                  knockback_vertical => 40.0,
                  knockback_horizontal => 50.0,
                  knockback_duration => 2,
                  hitstun_duration => 10
                )),
                1 => new Move.Move_Sub_Step'(O => Move.Play_Sound,
                  sound_index => 0
                ),
                2 => new Move.Move_Sub_Step'(
                  O => Move.Show_Extended_Bitmap,
                  show_extended_ind => 0
                )
              )),
              new Move.Move_Step'(frame_duration => 10, operations => new Move.Move_Sub_Step_Collection'(
                0 => new Move.Move_Sub_Step'(O => Move.Spawn_Hitbox, hb => Hitbox'(
                  effect => Attack,
                  identity => 1,
                  grab_opponent_steps_index => 0,
                  shape => Circle'(pos => Position'(150.0, 0.0), radius => 32.0),
                  hit => false,
                  damage => 20,
                  knockback_vertical => 40.0,
                  knockback_horizontal => 50.0,
                  knockback_duration => 2,
                  hitstun_duration => 10
                )),
                1 => new Move.Move_Sub_Step'(
                  O => Move.Show_Extended_Bitmap,
                  show_extended_ind => 1
                ),
                2 => new Move.Move_Sub_Step'(
                  O => Move.Hide_Extended_Bitmap,
                  hide_extended_ind => 0
                )
              )),
              new Move.Move_Step'(frame_duration => 24, operations => new Move.Move_Sub_Step_Collection'(
                0 => new Move.Move_Sub_Step'(O => Move.Despawn_Hitbox, despawn_hitbox_id =>  1),
                1 => new Move.Move_Sub_Step'(
                  O => Move.Hide_Extended_Bitmap,
                  hide_extended_ind => 1
                )
              ))
            )
          ),
        1,
        Tree_End_Conditions'(
          works_standing => true,
          works_crouching => false,
          works_midair => true
        ));
        
        Fighter.Add_Move(data,
          Move.Move'(
            command => new Move.Move_Input_Sequence'(
              new Input_Tree_Node'(ID => left),
              new Input_Tree_Node'(ID => down),
              new Input_Tree_Node'(ID => right),
              new Input_Tree_Node'(ID => atk_4)
            ),
            doing => Move.None,
            steps => new Move.Move_Step_Array'(
              new Move.Move_Step'(
                frame_duration => 3,
                operations => new Move.Move_Sub_Step_Collection'(
                  0 => new Move.Move_Sub_Step'(
                    O => Move.Play_Animation,
                    anim => new Animation_Data'(
                      0 => Animation_Frame'(x_start => 0.0, y_start => 200.0, frame_dration => 2),
                      1 => Animation_Frame'(x_start => 200.0, y_start => 200.0, frame_dration => 1)
                    )
                  )
                )
              ),
              new Move.Move_Step'(
                frame_duration => 3,
                operations => new Move.Move_Sub_Step_Collection'(
                  0 => new Move.Move_Sub_Step'(
                    O => Move.Dash,
                    dash_duration => 3,
                    dash_vertical => 20.0,
                    dash_horizontal => 20.0
                  )
                )
              ),
              new Move.Move_Step'(
                frame_duration => 11,
                operations => new Move.Move_Sub_Step_Collection'(
                  0 => new Move.Move_Sub_Step'(
                    O => Move.Play_Animation,
                    anim => new Animation_Data'(
                      0 => Animation_Frame'(x_start => 200.0, y_start => 200.0, frame_dration => 6),
                      1 => Animation_Frame'(x_start => 0.0, y_start => 200.0, frame_dration => 5)
                    )
                  )
                )
              )
            )
          ),
        2,
        Tree_End_Conditions'(
          works_standing => true,
          works_crouching => true,
          works_midair => true
        ));
        
        Fighter.Add_Move(data,
          Move.Move'(
            command => new Move.Move_Input_Sequence'(
              new Input_Tree_Node'(ID => left),
              new Input_Tree_Node'(ID => right),
              new Input_Tree_Node'(ID => atk_6)
            ),
            doing => Move.None,
            steps => new Move.Move_Step_Array'(
              new Move.Move_Step'(
                frame_duration => 22,
                operations => new Move.Move_Sub_Step_Collection'(
                  0 => new Move.Move_Sub_Step'(
                    O => Move.Play_Animation,
                    anim => new Animation_Data'(
                      0 => Animation_Frame'(x_start => 200.0, y_start => 200.0, frame_dration => 22)
                    )
                  )
                )
              ),
              new Move.Move_Step'(
                frame_duration => 3,
                operations => new Move.Move_Sub_Step_Collection'(
                  0 => new Move.Move_Sub_Step'(
                    O => Move.Spawn_Projectile,
                    spawn_proj_ind => 0
                  )
                )
              ),
              new Move.Move_Step'(
                frame_duration => 18,
                operations => new Move.Move_Sub_Step_Collection'(
                  0 => new Move.Move_Sub_Step'(
                    O => Move.Play_Animation,
                    anim => new Animation_Data'(
                      0 => Animation_Frame'(x_start => 200.0, y_start => 200.0, frame_dration => 10),
                      1 => Animation_Frame'(x_start => 0.0, y_start => 200.0, frame_dration => 8)
                    )
                  )
                )
              )
            )
          ),
        3,
        Tree_End_Conditions'(
          works_standing => true,
          works_crouching => true,
          works_midair => true
        ));
    end case;
    
    Fighter.Execute_Move(data, data.idle_stand_steps, Idle);
    
    return data;
  end Load_Fighter;
  
  function Fighter_Name (F : Fighter_Options) return String is
  begin
    return F'Image;
  end Fighter_Name;
  
  function Fighter_Icon (F : Fighter_Options) return ALLEGRO_BITMAP_ACCESS is
    load_str : String := (
    case F is
      when Shambler =>
        "assets/shambler_icon.png",
      when Test =>
        "assets/test_fighter_icon.png"
    );
  begin
    return al_load_bitmap(New_String(load_str));
  end Fighter_Icon;
  
  function Fighter_Move_Names (F : Fighter_Options) return Fighter_Move_Name_Array is
  begin
    case F is
      when Shambler =>
        return Fighter_Move_Name_Array'(Fighter_Move_Name'(new String'("Brain-Famished Lunge")), Fighter_Move_Name'(new String'("Coffin Dweller's Rollout")), Fighter_Move_Name'(new String'("Anti-Human Helicopter")));
      when Test =>
        return Fighter_Move_Name_Array'(Fighter_Move_Name'(new String'("Beeeep")), Fighter_Move_Name'(new String'("Useless Hop")), Fighter_Move_Name'(new String'("Wha-?!")));
    end case;
  end Fighter_Move_Names;
  
  function Fighter_Move_Indexes (F : Fighter_Options) return Fighter_Move_Index_Array is
  begin
    case F is
      when Shambler =>
        return Fighter_Move_Index_Array'(1, 2, 3);
      when Test =>
        return Fighter_Move_Index_Array'(1, 2, 3);
    end case;
  end Fighter_Move_Indexes;
end Fighter_Data;
