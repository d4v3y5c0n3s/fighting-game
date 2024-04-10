with Cool_Math; use Cool_Math;
with Move;
with Globals; use Globals;
with Projectile; use Projectile;
with Extended_Bitmap;
with allegro5_bitmap_h;
with Ada.Containers.Doubly_Linked_Lists;
with allegro_audio_h;

package Fighter is

  type Moves_Collection is array(Natural range <>) of Move.Move;
  type Moves_Collection_Access is access Moves_Collection;
  
  type Frame_And_Input is record
    frame : Natural;
    input : input_ids;
  end record;
  
  type Single_Sound is record
    value : access allegro_audio_h.ALLEGRO_SAMPLE;
  end record;
  type Fighter_Sounds is array(Natural range <>) of Single_Sound;
  type Fighter_Sounds_Access is access Fighter_Sounds;
  
  package Inputs_List is new Ada.Containers.Doubly_Linked_Lists(Frame_And_Input);
  
  package Active_Hitboxes is new Ada.Containers.Doubly_Linked_Lists(Hitbox);
  
  Hitbox_To_Despawn_Not_Found : exception;
  
  type Move_Steps_Collection is array(Natural range <>) of Move.Move_Step_Array_Access;
  
  type Projectile_Array is array(Natural range <>) of Projectile.Projectile;
  type Projectile_Array_Access is access Projectile_Array;
  
  package Active_Projectiles_List is new Ada.Containers.Doubly_Linked_Lists(Projectile.Projectile);
  
  type Extended_Bitmap_Array is array(Natural range <>) of Extended_Bitmap.Extended_Bitmap;
  type Extended_Bitmap_Array_Access is access Extended_Bitmap_Array;

  type Fighter is record
    inputs : Inputs_List.List;
    tree_of_move_inputs : Input_Tree.Tree;
    moves : Moves_Collection_Access := new Moves_Collection(0 .. 32);
    blocking : Boolean := false;
    crouching : Boolean := false;
    on_ground : Boolean := true;
    hitstun_duration : Natural := 0;
    blockstun_duration : Natural := 0;
    doing : What_Doing := Idle;
    facing_right : Boolean := true;
    holding_right : Boolean := false;
    holding_left : Boolean := false;
    holding_down : Boolean := false;
    strafing_left : Boolean := false;
    strafing_right : Boolean := false;
    grabbed : Boolean := false;
    grabbing : Boolean := false;
    gravity : Scalar := 1.0;
    walk_speed : Scalar := 7.0;
    air_strafe_speed : Scalar := 5.0;
    jump_speed : Scalar := -20.0;
    velocity_vertical, velocity_horizontal : Scalar := 0.0;
    knockback_velocity_vertical, knockback_velocity_horizontal : Scalar := 0.0;
    knockback_duration : Natural := 0;
    dash_velocity_vertical, dash_velocity_horizontal : Scalar := 0.0;
    dash_duration : Natural := 0;
    hitpoints : Integer := 100;
    pos : Position := Position'(0.0, 0.0);
    upper_hitbox : Circle := Circle'(pos => Position'(X => 0.0, Y => -50.0), radius => 50.0);
    lower_hitbox : Circle := Circle'(pos => Position'(X => 0.0, Y => 50.0), radius => 50.0);
    upper_hitbox_temp_offset : Position;
    lower_hitbox_temp_offset : Position;
    chunkbox : Circle := Circle'(pos => Position'(X => 0.0, Y => 0.0), radius => 40.0);
    bottom_of_feet : Position := Position'(0.0, 100.0);-- used for detecting the floor
    sprite_data : allegro5_bitmap_h.ALLEGRO_BITMAP_ACCESS;
    frame_width : Integer := 200;
    frame_height : Integer := 200;
    sprite_offset : Position := Position'(-100.0, -100.0);
    attack_hitboxes : Active_Hitboxes.List;
    active_move_steps : Move.Move_Step_Array_Access := new Move.Move_Step_Array(1 .. 20);
    move_step_index : Natural := 0;
    move_frame_progression : Natural := 0;
    active_animation : Animation_Data_Access := new Animation_Data'(
      0 => Animation_Frame'(x_start => 0.0, y_start => 0.0, frame_dration => 1)
    );
    active_anim_index : Natural := 0;
    animation_progression : Natural := 0;
    show_hitboxes : Boolean := false;
    armor : Natural := 0;
    sounds : access Fighter_Sounds;
    projectiles : Projectile_Array_Access;
    active_projectiles : Active_Projectiles_List.List;
    extended_bitmaps : Extended_Bitmap_Array_Access;
    on_hit_steps : Move.Move_Step_Array_Access;
    start_crouch_steps : Move.Move_Step_Array_Access;
    start_uncrouch_steps : Move.Move_Step_Array_Access;
    idle_crouch_steps : Move.Move_Step_Array_Access;
    idle_stand_steps : Move.Move_Step_Array_Access;
    grab_actions_steps : access Move_Steps_Collection;
    grabbed_opponent_reactions_steps : access Move_Steps_Collection;
    standing_block_steps : Move.Move_Step_Array_Access;
    crouching_block_steps : Move.Move_Step_Array_Access;
    on_jump_steps : Move.Move_Step_Array_Access;
    forwards_walk_steps : Move.Move_Step_Array_Access;
    backwards_walk_steps : Move.Move_Step_Array_Access;
    jump_sound : access allegro_audio_h.ALLEGRO_SAMPLE;
  end record;
  
  procedure Press_Input (F : in out Fighter; given_input : input_ids; frame : Natural);
  
  procedure Release_Input (F : in out Fighter; given_input : input_ids; frame : Natural);
  
  procedure Add_Move (F : in out Fighter; M : Move.Move; Index : Natural; Cond : Tree_End_Conditions);
  
  procedure Draw (F : Fighter);
  
  procedure Update (F : in out Fighter; Current_Frame : Natural);
  
  procedure Execute_Move (F : in out Fighter; ThisMove : Move.Move_Step_Array_Access; Doing : What_Doing);
  
  function Stunned (F : in Fighter) return Boolean is ((F.hitstun_duration > 0) or (F.blockstun_duration > 0) or F.grabbed);
  
private

  procedure Queue_Input (F : in out Fighter; input_on_frame : Frame_And_Input);

end Fighter;
