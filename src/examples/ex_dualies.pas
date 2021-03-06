PROGRAM ex_dualies;
(* Shows how to manage two adapters/monitors. *)
(*
  Copyright (c) 2012-2019 Guillermo Martínez J.

  This software is provided 'as-is', without any express or implied
  warranty. In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
 *)

{$IFDEF FPC}
  {$IFDEF WINDOWS}{$R 'manifest.rc'}{$ENDIF}
{$ENDIF}

USES
  Common,
  allegro5, al5image;

  PROCEDURE Go;
  VAR
    d1, d2: ALLEGRO_DISPLAYptr;
    b1, b2: ALLEGRO_BITMAPptr;
    Queue: ALLEGRO_EVENT_QUEUEptr;
    Event: ALLEGRO_EVENT;
  BEGIN
    al_set_new_display_flags (ALLEGRO_FULLSCREEN);

    al_set_new_display_adapter (0);
    d1 := al_create_display (640, 480);
    IF d1 = NIL THEN AbortExample ('Error creating first display.');
    b1 := al_load_bitmap ('data/mysha.pcx');
    IF b1 = NIL THEN AbortExample ('Error loading mysha.pcx.');

    al_set_new_display_adapter (1);
    d2 := al_create_display (640, 480);
    IF d2 = NIL THEN AbortExample ('Error creating second display.');
    b2 := al_load_bitmap ('data/allegro.pcx');
    IF b2 = NIL THEN AbortExample ('Error loading allegro.pcx.');

    Queue := al_create_event_queue;
    al_register_event_source (Queue, al_get_keyboard_event_source);

    WHILE TRUE DO
    BEGIN
      IF NOT al_is_event_queue_empty (Queue) THEN
      BEGIN
	al_get_next_event (Queue, Event);
	IF Event.ftype = ALLEGRO_EVENT_KEY_DOWN THEN
	  IF Event.keyboard.keycode = ALLEGRO_KEY_ESCAPE THEN
	  BEGIN
	    al_destroy_bitmap (b1);
	    al_destroy_bitmap (b2);
	    al_destroy_display (d1);
	    al_destroy_display (d2);
	    EXIT
	  END
      END;

      al_set_target_backbuffer (d1);
      al_draw_scaled_bitmap (b1, 0, 0, 320, 200, 0, 0, 640, 480, 0);
      al_flip_display;

      al_set_target_backbuffer (d2);
      al_draw_scaled_bitmap (b2, 0, 0, 320, 200, 0, 0, 640, 480, 0);
      al_flip_display;

      al_rest (0.1)
    END
  END;

BEGIN
  IF NOT al_init THEN AbortExample ('Could not init Allegro.');

  al_install_keyboard;

  al_init_image_addon;

  IF al_get_num_video_adapters < 2 THEN
    AbortExample ('You need 2 or more adapters/monitors for this example.');

  Go
END.
