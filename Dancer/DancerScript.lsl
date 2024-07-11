/* DancerScript9 
This script is created by another person in secondlife, and modified by Hillary Davi.
By typing start or on it should start the dancer, if you type stop or off it will shut off the dancer. 
*/

/* 
The following functions have been enhanced to provide additional functionalities:
 - ResetToDefault(): Can be called in any state of the script. It resets all variables properly, anticipating future state creations.
 - RequestionPerms(): Quickly requests permissions and is intended to be used with ResetToDefault().

 MusicResync(): Currently undergoing logic testing and not yet implemented. This function aims to handle changes upon resynchronization.
 The goal is to create a listener event that detects sync changes and executes the most recent change to the SoundClipNumber integer.
 The SoundClipNumber integer is believed to control the currently playing sound.

 particlestrigger(): Used to activate the particle system. This function also calls ResetToDefault() at the end.

PreloadAllSounds(): A new function to be called during a preload event.
This function is run in the state entry to get a list of all sounds in the inventory and preload them.
*/

integer curSourceOpt = PSYS_PART_BF_ONE_MINUS_DEST_COLOR;
integer curDestOpt = PSYS_PART_BF_ONE_MINUS_DEST_COLOR;
integer particles_switch;

integer ON = 0;                    //STATE OF SCRIPT
//YOU EDIT THESE PARTS FOR NEW ANIMATIONS, SOUND CLIPS ETC. DO NOT TOUCH THE SCRIPT
string animation = "dance";     //ANIMATION NAME
integer MaxSoundClips = 16;         //AMOUNT OF SONG CLIPS, NAME THEM 1,2,3,4,ETC 
integer SoundLength = 10;           //FIRST SERIES OF SOUND LENGTHS
integer LastSoundLength = 3;       //INCASE LAST SOUND CLIP IS SHORTER
integer SoundClipNumber = 0;       //FOR SOUND LOOP
key id;

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
         
         PSYS_SRC_TEXTURE, "NULL_KEY",
         PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE
         //PSYS_PART_BLEND_FUNC_SOURCE, curSourceOpt,
         //PSYS_PART_BLEND_FUNC_DEST, curDestOpt
         ]);
         
       } else {
           ResetToDefault();
           };
    }
    
//End Particles - Start Dancer Instructions

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
 PreloadAllSounds()
{  
    integer totalInventory = llGetInventoryNumber(INVENTORY_SOUND);
    integer i;
    for(i = 0; i < totalInventory; i++)
    {
        string soundName = llGetInventoryName(INVENTORY_SOUND, i);
        llPreloadSound(soundName);
    }
}  

default
{
    state_entry()
    {   
        PreloadAllSounds(); //Preloading all sound files to play normal.
        RequestionPerms();
        llParticleSystem([]);
        llListen(0, "", "", "");
    }
    
    attach(key id)
    {
        if(id)
        {
            llOwnerSay(" Commands 'on' or 'off'");
            llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
            PreloadAllSounds();
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
        if (particles_switch = 1) { //particlestrigger(); 
            } else {
            //particlestrigger();
            particles_switch = 0; // This is to make sure when you say off it will turn off and not leave it on. 
            llParticleSystem([]); // This is a second check to make sure the particle system is off. 
            //Function should take care of this.
            };
    }
    
    listen(integer channel, string name, key id, string message)
    {
        message = llToLower(message);
        if (ON == 0 && message == "on" | message == "start")
        {
            ON = 1;
            llStartAnimation(animation);
            particles_switch = 1;
            llSetTimerEvent(0.01);
            
        }
        else if(message == "off" | message == "stop"){ResetToDefault();}
    }
}
