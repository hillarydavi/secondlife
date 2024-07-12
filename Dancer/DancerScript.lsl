/* DancerScript9.1
This script is created by another person in Second Life, and modified by Hillary Davi.
By typing start or on it should start the dancer, if you type stop or off it will shut off the dancer. 
*/

/* 
The following functions have been enhanced to provide additional functionalities:
- ResetToDefault(): Can be called in any state of the script. It resets all variables properly, preparing for future state changes.
- RequestionPerms(): Quickly requests permissions and is intended to be used with ResetToDefault().
- MusicResync(): Currently undergoing logic testing and not yet implemented. This function aims to handle changes upon resynchronization.
    The goal is to create a listener event that detects sync changes and executes the most recent change to the SoundClipNumber integer.
    The SoundClipNumber integer controls the currently playing sound.
- particlestrigger(): Activates the particle system. This function can toggle particles on and off without explicitly calling the variable.
    - To use it as a toggle: set particles_switch = 1 (on) or particles_switch = 0 (off).
    - Call particlestrigger(particles_switch) to update the particle system.
- PreloadAllSounds(): Called during a preload event.
    - This function runs in the state entry to get a list of all sounds in the inventory and preload them.
*/

integer curSourceOpt = PSYS_PART_BF_ONE_MINUS_DEST_COLOR;
integer curDestOpt = PSYS_PART_BF_ONE_MINUS_DEST_COLOR;
integer particles_switch = 0;

integer ON = 0;                    //STATE OF SCRIPT
//YOU EDIT THESE PARTS FOR NEW ANIMATIONS, SOUND CLIPS ETC. DO NOT TOUCH THE SCRIPT
string animation = "dance";     //ANIMATION NAME
integer MaxSoundClips = 8;         //AMOUNT OF SONG CLIPS, NAME THEM 1,2,3,4,ETC 
integer SoundLength = 30;           //FIRST SERIES OF SOUND LENGTHS
integer LastSoundLength = 2;       //INCASE LAST SOUND CLIP IS SHORTER
integer SoundClipNumber = 0;       //FOR SOUND LOOP
key id;

particlestrigger(integer particles_switch) {
    //particles_switch = !particles_switch; 
    if (particles_switch == 1) {
        llParticleSystem([
            PSYS_PART_FLAGS,
            PSYS_PART_INTERP_SCALE_MASK |
            PSYS_PART_INTERP_COLOR_MASK |
            PSYS_PART_EMISSIVE_MASK,
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
            PSYS_PART_BLEND_FUNC_SOURCE, PSYS_PART_BF_SOURCE_ALPHA,
            PSYS_PART_BLEND_FUNC_DEST, PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
            PSYS_SRC_BURST_SPEED_MIN, 0.5,
            PSYS_SRC_BURST_SPEED_MAX, 0.5,
            PSYS_SRC_BURST_RATE, 2,
            PSYS_PART_MAX_AGE, 2,
            PSYS_SRC_BURST_PART_COUNT, 4,
            PSYS_SRC_ACCEL, <0.0, 0.0, 0.0>,
            PSYS_PART_START_GLOW, 0.5,
            PSYS_PART_START_GLOW, 0.0,
            PSYS_PART_END_GLOW, 0.0, 
            PSYS_PART_START_SCALE, <1.1, 1.1, 1.1>,
            PSYS_PART_END_SCALE, <0, 0, 0>, 
            PSYS_SRC_TEXTURE, "NULL_KEY",
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE
        ]);
    } else {
        llParticleSystem([]);
    }
}

//End Particles - Start Dancer Instructions

ResetToDefault() {
    llStopSound();
    llSetTimerEvent(0.00);
    llStopAnimation(animation);
    ON = 0;
    SoundClipNumber = 0;
    particles_switch = 0;
    particlestrigger(particles_switch);
}

RequestionPerms() {
    id = llGetOwner();
    llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
    ResetToDefault();
}

PreloadAllSounds() {  
    integer totalInventory = llGetInventoryNumber(INVENTORY_SOUND);
    integer i;
    for (i = 0; i < totalInventory; i++) {
        string soundName = llGetInventoryName(INVENTORY_SOUND, i);
        llPreloadSound(soundName);
    }
}  

default {
    state_entry() {   
        PreloadAllSounds(); //Preloading all sound files to play normal.
        RequestionPerms();
        llParticleSystem([]);
        llListen(0, "", "", "");
    }
    
    attach(key id) {
        if (id) {
            llOwnerSay(" Commands 'on' or 'off'");
            llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
            PreloadAllSounds();
        } else {
            ResetToDefault();
        }
    }
    
    changed(integer change) {
        if (change & CHANGED_OWNER) { //note that it's & and not &&... it's bitwise!
            llResetScript();
        }
        if (change & CHANGED_INVENTORY) { //note that it's & and not &&... it's bitwise!
            llResetScript();
        }
    }
    
    timer() {
        llPlaySound((string)(++SoundClipNumber), 1.0);
        if (ON == 1) {
            llSetTimerEvent(SoundLength);
            ON = 2;
        }
        if (SoundClipNumber == MaxSoundClips) {
            llSetTimerEvent(LastSoundLength);
            ON = 1;
            SoundClipNumber = 0;
        }
        llPreloadSound((string)(SoundClipNumber + 1)); //This seems to create a preload, the function seems to replace this.
    }
    
    listen(integer channel, string name, key id, string message) {
        message = llToLower(message);
        if (ON == 0 && (message == "on" || message == "start")) {
            particles_switch = 1;
            particlestrigger(particles_switch);
            ON = 1;
            llStartAnimation(animation);
            llSetTimerEvent(0.01);
        } else if (message == "off" || message == "stop") {
            ResetToDefault();
        }
    }
}
