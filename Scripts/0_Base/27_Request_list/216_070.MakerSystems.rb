# encoding: utf-8
# Name: 070.MakerSystems
# Size: 30757
%Q(
╔════╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═════╗
║ ╔══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╗ ║
╠─╣                               Speed Trail                                ╠─╣
╠─╣                           by RPG Maker Source.                           ╠─╣
╠─╣                          www.rpgmakersource.com                          ╠─╣
║ ╚══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╝ ║
╠════╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═╤═╩═════╣
║ ┌────┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴─────┐ ║
╠─┤ Version 1.0.3                   02/12/14                        DD/MM/YY ├─╣
║ └────┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬─────┘ ║
╠══════╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══════╣
║                                                                              ║
║               This work is protected by the following license:               ║
║     ╔══════════════════════════════════════════════════════════════════╗     ║
║     │                                                                  │     ║
║     │ Copyright © 2014 Maker Systems.                                  │     ║
║     │                                                                  │     ║
║     │ This software is provided 'as-is', without any kind of           │     ║
║     │ warranty. Under no circumstances will the author be held         │     ║
║     │ liable for any damages arising from the use of this software.    │     ║
║     │                                                                  │     ║
║     │ Permission is granted to anyone to use this software on their    │     ║
║     │ free or commercial games made with a legal copy of RPG Maker     │     ║
║     │ VX Ace, as long as Maker Systems - RPG Maker Source is           │     ║
║     │ credited within the game.                                        │     ║
║     │                                                                  │     ║
║     │ Selling this code or any portions of it 'as-is' or as part of    │     ║
║     │ another code, is not allowed.                                    │     ║
║     │                                                                  │     ║
║     │ The original header, which includes this copyright notice,       │     ║
║     │ must not be edited or removed from any verbatim copy of the      │     ║
║     │ sotware nor from any edited version.                             │     ║
║     │                                                                  │     ║
║     ╚══════════════════════════════════════════════════════════════════╝     ║
║                                                                              ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║ 1. VERSION HISTORY.                                                        ▼ ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║ • Version 1.0.0, 29/11/14 - (DD/MM/YY).                                      ║
║                                                                              ║
║ • Version 1.0.1, 29/11/14 - (DD/MM/YY).                                      ║
║                                                                              ║
║ • Version 1.0.2, 30/11/14 - (DD/MM/YY).                                      ║
║                                                                              ║
║ • Version 1.0.3, 02/12/14 - (DD/MM/YY).                                      ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
╠══════════════════════════════════════════════════════════════════════════════╣
║ 2. USER MANUAL.                                                            ▼ ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║ ┌──────────────────────────────────────────────────────────────────────────┐ ║
║ │ ■ Introduction.                                                          │ ║
║ └┬┬┬┬──────────────────────────────────────────────────────────────────┬┬┬┬┘ ║
║                                                                              ║
║  Hello there! This script is "plug and play", you can simply insert it       ║
║  into your project and it will perform flawlessly.                           ║
║                                                                              ║
║  This script can create awesome looking effects for characters in your       ║
║  game (both for Events and player characters). It can be used for many       ║
║  situations, to convey the idea of speed, power effects, skills, slow        ║
║  motion camera, ghosts, and even mitical beings. Your imagination is the     ║
║  limit.                                                                      ║
║                                                                              ║
║  There are a lot of different looking effects that are possible by just      ║
║  changing some parameter combinations when you call for the effect, so be    ║
║  sure to check the Feature Documentation section of this manual to           ║
║  experience the full power of the system.                                    ║
║                                                                              ║
║  We hope you enjoy it.                                                       ║
║                                                                              ║
║  Thanks for choosing our products.                                           ║
║                                                                              ║
║ ┌──────────────────────────────────────────────────────────────────────────┐ ║
║ │ ■ Configuration.                                                         │ ║
║ └┬┬┬┬──────────────────────────────────────────────────────────────────┬┬┬┬┘ ║
║                                                                              ║
║  The effect can be set to be performed automatically when the player         ║
║  dashes, and you can choose how it will look by changing the same            ║
║  parameters that you can use when you call for the effect to be performed    ║
║  on an event.                                                                ║
║                                                                              ║
║  The parameters are explained in the Feature Documentation section, to       ║
║  change certain parameter for the Player default (when dashing), click       ║
║  anywhere in the script editor and select "Find" or (CTRL + F), search       ║
║  for:                                                                        ║
║                                                                              ║
║  Player_Dash_ + parameter name. For example:                                 ║
║                                                                              ║
║  "PLAYER_DASH_RHYTHM" (without quotation marks)                              ║
║                                                                              ║
║  You will see something like "PLAYER_DASH_RHYTHM = 4"                        ║
║                                                                              ║
║  Change the number after the equality sign to any possible parameter         ║
║  value, the possible values are decribed in the next section (Feature        ║
║  Documentation).                                                             ║
║                                                                              ║
║ ┌──────────────────────────────────────────────────────────────────────────┐ ║
║ │ ■ Feature Documentation.                                                 │ ║
║ └┬┬┬┬──────────────────────────────────────────────────────────────────┬┬┬┬┘ ║
║                                                                              ║
║  There are two script calls documented in the following section, one is      ║
║  for starting the effect on a certain character and the other one is for     ║
║  ending the effect on a certain character.                                   ║
║                                                                              ║
║  ┌─────────────────────────────────────────────────────────────────────┐     ║
║  │ ms_start_speed_trail(id, rhythm, delay, blend_type, opacity, [...]) │     ║
║  ├─────────────────────────────────────────────────────────────────────┴──┐  ║
║  │ This command tells the system to start performing the effect on        │  ║
║  │ certain character.                                                     │  ║
║  │                                                                        │  ║
║  │ There are many properties that you can combine to make unique, cool    │  ║
║  │ effects for your scenes.                                               │  ║
║  │ There are 5 necessary parameters, this are "id", "rhythm", "delay",    │  ║
║  │ "blend_type" and "opacity". Any parameter after those is optional, but │  ║
║  │ should you include more, they need to be written in the following      │  ║
║  │ order:                                                                 │  ║
║  │                                                                        │  ║
║  │ ([...], color, wave_amp, wave_length, wave_speed, blur_level, limit)   │  ║
║  │                                                                        │  ║
║  │ If you want to include a parameter that comes after one that you       │  ║
║  │ don't, make 'nil' (without quotation marks) the value for those you    │  ║
║  │ don't want (to keep the order).                                        │  ║
║  │                                                                        │  ║
║  │ • What is "id"?                                                        │  ║
║  │ id is a number representing the character, 0 is for player, and 1 and  │  ║
║  │ up for event id.                                                       │  ║
║  │                                                                        │  ║
║  │ • What is "rhytm"?                                                     │  ║
║  │ Interval in frames of each Sprite appearance. Lower numbers result in  │  ║
║  │ a more continuous effect while bigger number makes each "blueprint"    │  ║
║  │ Sprite appear more far appart.                                         │  ║
║  │                                                                        │  ║
║  │ Use any number equal or greater than 0.                                │  ║
║  │                                                                        │  ║
║  │ • What is "delay"?                                                     │  ║
║  │ Number of frames that each Sprite will remain visible.                 │  ║
║  │                                                                        │  ║
║  │ Use any number equal or greater than 1.                                │  ║
║  │                                                                        │  ║
║  │ • What is "blendType"?                                                 │  ║
║  │ Blend mode for the Sprites used in the effect.                         │  ║
║  │                                                                        │  ║
║  │ Use 0 for normal, 1 for addition, and 2 for subtraction.               │  ║
║  │                                                                        │  ║
║  │ • What is "opacity"?                                                   │  ║
║  │ This represents the starting opacity for each Sprite.                  │  ║
║  │                                                                        │  ║
║  │ Use either a number between 0.0 and 1.0 to represent the percentage    │  ║
║  │ (0.9 being 90%, and so on), or a number from 0 to 255 (255 being 100%  │  ║
║  │ and so on).                                                            │  ║
║  │                                                                        │  ║
║  │ • What is "color"?                                                     │  ║
║  │ Color represents the color of the trail, in case you want the effect   │  ║
║  │ to have a different color than that of the normal character sprite.    │  ║
║  │                                                                        │  ║
║  │ Example: '0 255 0'                                                     │  ║
║  │                                                                        │  ║
║  │ You might be asking yourself "What is that supposed to mean?" but      │  ║
║  │ worry not, my friend, because it is actually very simple:              │  ║
║  │ The single quotes are used to encapsulate the color information. You   │  ║
║  │ can put either RGBA values in there or HEX values.                     │  ║
║  │ If you want to use RGBA colors, simple leave a space after each color  │  ║
║  │ value, like this:                                                      │  ║
║  │                                                                        │  ║
║  │ BACK_COLOR = 'RED GREEN BLUE ALPHA'                                    │  ║
║  │                                                                        │  ║
║  │ The values for RED, GREEN, BLUE, and ALPHA must be numbers between 0   │  ║
║  │ and 255.                                                               │  ║
║  │                                                                        │  ║
║  │ ALPHA is the opacity of the color.                                     │  ║
║  │                                                                        │  ║
║  │ On the other hand, if you want to use HEX codes, simply put a # (hash  │  ║
║  │ character) before it, like this:                                       │  ║
║  │                                                                        │  ║
║  │ BACK_COLOR = '#0000009B'                                               │  ║
║  │                                                                        │  ║
║  │ • What is "wave_amp"?                                                  │  ║
║  │ This represents the amplitude of the wave effect and it is not         │  ║
║  │ necessary for you to include it. It is deactivated by default. For     │  ║
║  │ more information, check RPG Maker Ace's help file, Sprite section.     │  ║
║  │                                                                        │  ║
║  │ • What is "wave_length"?                                               │  ║
║  │ This represents the wave frequency, it is not necessary for you to     │  ║
║  │ include it unless you want the system to perform a wave effect for     │  ║
║  │ this Speed Trail.                                                      │  ║
║  │                                                                        │  ║
║  │ • What is "wave_speed"?                                                │  ║
║  │ This represents the speed of the wave effect, it is not necessary for  │  ║
║  │ you to include it and the default is 360.                              │  ║
║  │                                                                        │  ║
║  │ • What is "blur_level"?                                                │  ║
║  │ This represents the strength of the blur effect in each Sprite, it is  │  ║
║  │ not necessary for you to include it and the default is nil             │  ║
║  │ (deactivated). Use either nil for no blur, or any number equal or      │  ║
║  │ greater than 1. Keep in mind that blur effects are CPU intensive, the  │  ║
║  │ bigger the strength (blur level), the more intensive.                  │  ║
║  │                                                                        │  ║
║  │ • What is "size_limit"?                                                │  ║
║  │ This represents the maximum number of Sprites that the effect can use  │  ║
║  │ for each character simultaneously.                                     │  ║
║  │ So for example, if you set the size limit of the Player to 22 and      │  ║
║  │ either the rhythm is too short or the spawn delay is too long, causing │  ║
║  │ many Sprites to appear on screen at the same time, the Sprite creation │  ║
║  │ will be capped at 22.                                                  │  ║
║  │ This is to ensure the good performance of your game.                   │  ║
║  │                                                                        │  ║
║  │ Any numer equal or greater than 1. If you don't include this           │  ║
║  │ parameter, the default SIZE_LIMIT will be used.                        │  ║
║  │                                                                        │  ║
║  └────────────────────────────────────────────────────────────────────────┘  ║
║  ┌─────────────────────────┐                                                 ║
║  │ ms_stop_speed_trail(id) │                                                 ║
║  ├─────────────────────────┴──────────────────────────────────────────────┐  ║
║  │ This command tells the system to stop performing the effect on certain │  ║
║  │ character.                                                             │  ║
║  │                                                                        │  ║
║  │ • What is "id"?                                                        │  ║
║  │ id is a number representing the character, 0 is for player, and 1 and  │  ║
║  │ up for event id.                                                       │  ║
║  │                                                                        │  ║
║  └────────────────────────────────────────────────────────────────────────┘  ║
║                                                                              ║
║  TL;DR:                                                                      ║
║  • The effect can be automatic each time the player dashes by pressing       ║
║    SHIFT. To customize the look of that effect, go to the configuration      ║
║    part of the script.                                                       ║
║    To turn the automatic effect off, set PLAYER_DASH_AUTOST to false.        ║
║  • You can activate the effect, and deactivate it for any character by       ║
║    using ms_start_speed_trail(the arguments) and ms_stop_speed_trail(id)     ║
║  • You're awesome.                                                           ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
╠══════════════════════════════════════════════════════════════════════════════╣
║ 3. NOTES.                                                                  ▼ ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  Have fun and enjoy!                                                         ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
╠══════════════════════════════════════════════════════════════════════════════╣
║ 4. CONTACT.                                                                ▼ ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  Keep in touch with us and be the first to know about new releases:          ║
║                                                                              ║
║  www.rpgmakersource.com                                                      ║
║  www.facebook.com/RPGMakerSource                                             ║
║  www.twitter.com/RPGMakerSource                                              ║
║  www.youtube.com/user/RPGMakerSource                                         ║
║                                                                              ║
║  Get involved! Have an idea for a system? Let us know.                       ║
║                                                                              ║
║  Spread the word and help us reach more people so we can continue creating   ║
║  awesome resources for you!                                                  ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝)

module MakerSystems
  module SpeedTrail
    #------------------------------------------------------------------------
    # * 플레이어 대시의 기본 속도 추적.
    #------------------------------------------------------------------------
    PLAYER_DASH_AUTOST      = false
    #------------------------------------------------------------------------
    # * 플레이어 대쉬를 위한 리듬.
    #------------------------------------------------------------------------
    PLAYER_DASH_RHYTHM      = 2
    #------------------------------------------------------------------------
    # * 플레이어 대쉬 지연.
    #------------------------------------------------------------------------
    PLAYER_DASH_SPAWNDELAY  = 15
    #------------------------------------------------------------------------
    # * Player Dashing의 블렌드 유형.
    #------------------------------------------------------------------------
    PLAYER_DASH_BLENDTYPE   = 0
    #------------------------------------------------------------------------
    # * Player Dashing의 불투명도.
    #------------------------------------------------------------------------
    PLAYER_DASH_OPACITY     = 0.9
    #------------------------------------------------------------------------
    # * Player Dashing의 색상.
    #------------------------------------------------------------------------
    PLAYER_DASH_COLOR       = nil
    #------------------------------------------------------------------------
    # * 플레이어 대시용 웨이브 앰프.
    #------------------------------------------------------------------------
    PLAYER_DASH_WAVE_AMP    = nil
    #------------------------------------------------------------------------
    # * 플레이어 대시의 파장.
    #------------------------------------------------------------------------
    PLAYER_DASH_WAVE_LENGTH = nil
    #------------------------------------------------------------------------
    # * 플레이어 대시의 파동 속도.
    #------------------------------------------------------------------------
    PLAYER_DASH_WAVE_SPEED  = nil
    #------------------------------------------------------------------------
    # * Player Dashing의 흐림 수준.
    #------------------------------------------------------------------------
    PLAYER_DASH_BLUR_LEVEL  = 1
    #------------------------------------------------------------------------
    # * Player Dashing의 트레일 크기 제한.
    #------------------------------------------------------------------------
    PLAYER_DASH_SIZE_LIMIT  = 22
    #------------------------------------------------------------------------
    # * 각 캐릭터에 대한 속도 트레일(스프라이트)의 기본 제한.
    #------------------------------------------------------------------------
    SIZE_LIMIT              = 10
  end
end