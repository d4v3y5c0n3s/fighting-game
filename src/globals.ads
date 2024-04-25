with Ada.Containers.Multiway_Trees;
with Interfaces.C; use Interfaces.C;
with allegro5_color_h;
with allegro5_events_h; use allegro5_events_h;
with Cool_Math; use Cool_Math;
with Global_Start_Def;

package Globals is
  
  type Controls is (Joystick, Keyboard);
  type Controls_Joystick is (Axis, Button);
  type Controls_Joystick_Data (J : Controls_Joystick) is record
    case J is
      when Axis =>
        axis_num : int;
        stick_num : int;
        min : Float;
        max : Float;
      when Button =>
        button : int;
    end case;
  end record;
  type Controls_Keyboard_Data is record
    key : int;
  end record;
  type Event_Input (C : Controls) is record
    case C is
      when Joystick =>
        joy_data : access Controls_Joystick_Data;
      when Keyboard =>
        key_data : Controls_Keyboard_Data;
    end case;
  end record;
  
  type Opt_Joy is (No_Joy, Joy);
  type Opt_Joy_Handle (J : Opt_Joy) is record
    case J is
      when No_Joy =>
        null;
      when Joy =>
        handle : access ALLEGRO_JOYSTICK;
    end case;
  end record;
  type Opt_Joy_Handle_Access is access Opt_Joy_Handle;
  
  max_stick : constant Natural := 16;
  max_axis : constant Natural := 3;
  
  type Stick_Axis_Values is array(0 .. max_stick, 0 .. max_axis) of Float;
  
  type Game_Input is (Up_Press, Down_Press, Left_Press, Right_Press, Attack_1_Press, Attack_2_Press, Attack_3_Press, Attack_4_Press, Attack_5_Press, Attack_6_Press, Start_Press, Up_Release, Down_Release, Left_Release, Right_Release, Attack_1_Release, Attack_2_Release, Attack_3_Release, Attack_4_Release, Attack_5_Release, Attack_6_Release, Start_Release);
  subtype GI_Press is Game_Input range Up_Press .. Start_Press;
  subtype GI_Release is Game_Input range Up_Release .. Start_Release;
  
  type Input_Translation is record
    ev : access Event_Input;
    gi : GI_Press;
  end record;
  type Game_Input_Translations is array(Natural range <>) of Input_Translation;
  type StickDirUpDown is (Neither, Up, Down);
  type StickDirLeftRight is (Neither, Left, Right);
  type Game_Input_State is record
    last : Stick_Axis_Values := (others => (others => 0.0));
    cur : Stick_Axis_Values := (others => (others => 0.0));
    translations : access Game_Input_Translations;
    optional_joystick_handle : Opt_Joy_Handle_Access;
  end record;
  
  default_joystick_axis_min : constant Float := 0.4;
  default_joystick_axis_max : constant Float := 1.0;
  
  default_trigger_axis_min : constant Float := -0.2;
  default_trigger_axis_max : constant Float := 1.0;
  
  type input_tree_id is (tree_end, up, down, left, right, atk_1, atk_2, atk_3, atk_4, atk_5, atk_6);
  subtype input_ids is input_tree_id range up .. atk_6;
  
  frame_duration : constant Duration := 1.0 / 60.0;
  input_buffer_frames : constant Natural := 70;
  input_buffer_max_button_delay : constant Natural := 12;
  
  universal_blockstun : constant Natural := 5;
  
  counter_grab_pushback : constant Scalar := 20.0;
  counter_grab_push_duration : constant Natural := 2;
  
  type Tree_End_Conditions is record
    works_standing : Boolean := true;
    works_crouching : Boolean := true;
    works_midair : Boolean := true;
  end record;
  
  type Input_Tree_Node(ID : input_tree_id) is record
    case ID is
      when tree_end =>
        key : Natural;
        condition : Tree_End_Conditions;
      when others =>
        null;
    end case;
  end record;
  
  type Input_Tree_Node_Access is access Input_Tree_Node;
  
  package Input_Tree is new Ada.Containers.Multiway_Trees(Input_Tree_Node_Access);
  
  type Animation_Frame is record
    x_start : Float := 0.0;
    y_start : Float := 0.0;
    frame_dration : Natural := 0;
  end record;
  type Animation_Data is array(Natural range <>) of Animation_Frame;
  type Animation_Data_Access is access Animation_Data;
  
  type Hitbox_Effect is (Attack, Grab);
  type Hitbox is record
    effect : Hitbox_Effect := Attack;
    grab_opponent_steps_index : Natural := 0;
    identity : Integer := 0;
    shape : Circle := Circle'(pos => Position'(X => 0.0, Y => 0.0), radius => 10.0);
    hit : Boolean := false;
    damage : Integer := 0;
    knockback_vertical, knockback_horizontal : Scalar := 0.0;
    knockback_duration : Natural := 0;
    hitstun_duration : Natural := 0;
    hit_pushback : Scalar := 0.0;
    hit_pushback_duration : Natural := 0;
  end record;
  
  type What_Doing is (
    Normal_Move,
    Idle,
    Start_Crouch,
    Start_Uncrouch,
    Crouched,
    Grabbing,
    Grabbed,
    Walk,
    Jump,
    Blocked_Attack,
    Hit_By_Attack
  );
  
  debug_upper_hitbox_color : allegro5_color_h.ALLEGRO_COLOR;
  debug_lower_hitbox_color : allegro5_color_h.ALLEGRO_COLOR;
  debug_attack_hitbox_color : allegro5_color_h.ALLEGRO_COLOR;
  debug_chunkbox_color : allegro5_color_h.ALLEGRO_COLOR;
  
  controller_start_id : constant int := Global_Start_Def.start;
  
end Globals;
