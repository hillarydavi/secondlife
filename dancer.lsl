//This script is created by another person in secondlife, and modified by Hillary Davi.

// DancerScript7 - Addition of a new function, MusicResync(), not yet in use.

// ResetToDefault() and RequestionPerms() now allow two functionalities that the old and original functions did not.

// ResetToDefault() - Can be called in any state of the script. This function's purpose is to reset all variables properly, anticipating the creation of future states.
// RequestionPerms() - A quick function call to request permissions, intended for use with ResetToDefault().

// MusicResync() - Currently undergoing logic testing; not yet implemented. The aim is to create a function to handle changes upon resynchronization.
// The goal is to set up a listener event to detect sync changes and execute the most recent change to the SoundClipNumber integer.
// This integer is believed to control the currently playing sound.

integer curSourceOpt = PSYS_PART_BF_ONE_MINUS_DEST_COLOR;
integer curDestOpt = PSYS_PART_BF_ONE_MINUS_DEST_COLOR;
integer particles_switch;

particlestrigger() {
        if (particles_switch = 1)
          {
        llParticleSystem([
PSYS_PART_FLAGS,
PSYS_PART_INTERP_SCALE_MASK|
PSYS_PART_INTERP_COLOR_MASK|
PSYS_PART_EMISSIVE_MASK,
PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
PSYS_PART_BLEND_FUNC_SOURCE, PSYS_PART_BF_SOURCE_ALPHA,
PSYS_PART_BLEND_FUNC_DEST, PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
PSYS_SRC_BURST_SPEED_MIN,0.5,
PSYS_SRC_BURST_SPEED_MAX,0.5,
PSYS_SRC_BURST_RATE, 2,
PSYS_PART_MAX_AGE,2,
PSYS_SRC_BURST_PART_COUNT,4,
PSYS_SRC_ACCEL,<0.0,0.0,0.0>,
PSYS_PART_START_GLOW,0.5,
     PSYS_PART_START_GLOW, 0.0,
     PSYS_PART_END_GLOW, 0.0, 
                        PSYS_PART_START_SCALE,<1.1,1.1,1.1>,
                        PSYS_PART_END_SCALE,<0,0,0>, 
        // PSYS_SRC_TEXTURE, "5521c74f-bd37-e88e-1180-e94b0dd22db2",
         //PSYS_SRC_TEXTURE, "0ab43703-ba7d-05f8-0fb8-ebfa4e523bc5",
        // PSYS_SRC_TEXTURE, "73c480bd-e009-a913-51c4-571055a2d02f",
         
         PSYS_SRC_TEXTURE, "ff8accf8-7154-55e9-854d-37b570b88e4c",
         PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE
         //PSYS_PART_BLEND_FUNC_SOURCE, curSourceOpt,
         //PSYS_PART_BLEND_FUNC_DEST, curDestOpt
         ]);
         
       } else {
           ResetToDefault();
           };
    }
    
//End Particles - Start Dancer Instructions

integer ON = 0;                    //STATE OF SCRIPT
//YOU EDIT THESE PARTS FOR NEW ANIMATIONS, SOUND CLIPS ETC. DO NOT TOUCH THE SCRIPT
string animation = "dance";     //ANIMATION NAME
integer MaxSoundClips = 16;         //AMOUNT OF SONG CLIPS, NAME THEM 1,2,3,4,ETC 
integer SoundLength = 10;           //FIRST SERIES OF SOUND LENGTHS
integer LastSoundLength = 3;       //INCASE LAST SOUND CLIP IS SHORTER
integer SoundClipNumber = 0;       //FOR SOUND LOOP
key id;
ResetToDefault()
{
    llStopSound();
    llSetTimerEvent(0.00);
    llStopAnimation(animation);
    ON = 0;
    SoundClipNumber = 0;
    particles_switch = 0;
    llParticleSystem([]);
}
RequestionPerms() {
    id = llGetOwner();
    llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
    ResetToDefault();
    }
    
default
{
    state_entry()
    {   RequestionPerms();
        llParticleSystem([]);
        ResetToDefault();
        llListen(0, "", "", "");
    }
    
    attach(key id)
    {
        if(id)
        {
            llOwnerSay(" Commands 'on' or 'off'");
            llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
        }
        else ResetToDefault();
    }
    changed(integer change)
    {
        if (change & CHANGED_OWNER) //note that it's & and not &&... it's bitwise!
        {
            llResetScript();
        }
        if (change & CHANGED_INVENTORY) //note that it's & and not &&... it's bitwise!
        {
           llResetScript();
        }        

    }
    timer()
    {
        llPlaySound((string)(++SoundClipNumber),1.0);
        if(ON == 1){llSetTimerEvent(SoundLength); ON = 2;}
        if(SoundClipNumber == MaxSoundClips){llSetTimerEvent(LastSoundLength); ON = 1; SoundClipNumber = 0;}
        llPreloadSound((string)(SoundClipNumber+1));
        if (particles_switch = 1) { particlestrigger(); } else {
            particlestrigger();
            particles_switch = 0; // This is to make sure when you say off it will turn off and not leave it on. 
            llParticleSystem([]); // This is a second check to make sure the particle system is off. 
            //Function should take care of this.
            };
    }
    
    listen(integer channel, string name, key id, string message)
    {
        message = llToLower(message);
        if (ON == 0 && message == "on" | message == "Breakfast Burrito"  | message == "breakfast" | message == "burrito" )
        {
            ON = 1;
            llStartAnimation(animation);
            particles_switch = 1;
            llSetTimerEvent(0.01);
            
        }
        else if(message == "off" | message == "stop"){ResetToDefault();}
    }
}
