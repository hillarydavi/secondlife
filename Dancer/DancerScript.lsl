/*
 * DancerScript 9.2/9.3/9.4
 * Originally created by another person in Second Life, modified by Hillary Davi.
 * 
 * Commands:
 * - "start" or "on" to start the dancer
 * - "stop" or "off" to stop the dancer
 */

/* Enhanced Functions:
 * - ResetToDefault(): Resets all variables, preparing for future state changes. Can be called in any script state.
 * - RequestionPerms(): Quickly requests permissions and is intended to be used with ResetToDefault().
 * - MusicResync(): (In development) Aims to handle synchronization changes by detecting sync changes and executing the most recent change to the SoundClipNumber integer. The SoundClipNumber integer controls the currently playing sound.
 *   - Version 9.3: Shouts the current track on the private channelsync channel.
 *   - Temporarily removed and added directly to the timer event.
 * - particlestrigger(): Toggles the particle system on and off.
 *   - To use as a toggle: Set particles_switch = 1 (on) or particles_switch = 0 (off).
 *   - Call particlestrigger(particles_switch) to update the particle system.
 * - PreloadAllSounds(): Preloads all sounds in the inventory during a preload event. Runs in the state entry to get a list of all sounds and preload them.
 * - PreloadAllSoundswithStatus(): Similar to PreloadAllSounds, but tracks the percentage of sounds preloaded. Soon to be replaced with the main preload.
 * - isInt(): Checks if a string is an integer. Added from https://community.secondlife.com/forums/topic/108716-check-if-integer/ by ellestones.
 */



//Maybe a issue: Script trying to trigger animations but PERMISSION_TRIGGER_ANIMATION permission not set needs to reset on owner change.
integer curSourceOpt = PSYS_PART_BF_ONE_MINUS_DEST_COLOR;
integer curDestOpt = PSYS_PART_BF_ONE_MINUS_DEST_COLOR;
integer particles_switch = 0;

integer ON = 0;                    //STATE OF SCRIPT
//YOU EDIT THESE PARTS FOR NEW ANIMATIONS, SOUND CLIPS ETC. DO NOT TOUCH THE SCRIPT
string animation = "dance";     //ANIMATION NAME
integer MaxSoundClips = 6;         //AMOUNT OF SONG CLIPS, NAME THEM 1,2,3,4,ETC 
integer SoundLength = 30;           //FIRST SERIES OF SOUND LENGTHS
integer LastSoundLength = 5;       //INCASE LAST SOUND CLIP IS SHORTER
integer SoundClipNumber = 0;       //FOR SOUND LOOP
integer MusicSyncCH;     //for the channel to send the sync too, this must be changed depending on the creator.
//Change the MusicSyncCH integer to something unique to you. Or might conflict with other dancers. 
key id;

ResetToDefault()
{
    MusicSyncCH = 1234; //change this to something unque must be a integer
    llStopSound();
    llSetTimerEvent(0.00);
    llStopAnimation(animation);
    ON = 0;
    SoundClipNumber = 0;
    particles_switch = 0;
    llParticleSystem([]);
}

integer isInt(string s) 
{
    s = llStringTrim(s, STRING_TRIM);
    if (llGetSubString(s, 0, 0) == "+")
       s = llDeleteSubString(s, 0, 0);
    return ((string)((integer)s) == s);
} 

particlestrigger(integer particles_switch) {
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
           llParticleSystem([]);
           };
    }
    
//End Particles - Start Dancer Instructions

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
PreloadAllSoundswithStatus() {
    integer totalInventory = llGetInventoryNumber(INVENTORY_SOUND);
    integer i;
    for (i = 0; i < totalInventory; i++) {
        string soundName = llGetInventoryName(INVENTORY_SOUND, i);
        llPreloadSound(soundName);
        
        // Calculate percentage done
        float percentDone = (float)(i + 1) / (float)totalInventory * 100.0;
        float floatValue = (float)percentDone;
        // Use llRound to round the float to the nearest 100, 
        // this is to make sure percentDone is not formated as 100.00000000000
        // needed to remove the extra zeros from the float pram.
        integer roundedValue = llRound(floatValue / 100.0) * 100;
        string percentText = (string)roundedValue;
        
        //string percentText = (string)percentInt;


        llSetText("Preloading Music: " + percentText + "%", <1.0, 1.0, 1.0>, 1.0);
    }
    
    // Clear the text once preloading is complete
    llSetText("", <1.0, 1.0, 1.0>, 1.0);
    llOwnerSay("Ready to activate!");
}

MusicResync() {

        
        llPlaySound((string)(++SoundClipNumber),1.0); //Was in the timer event during the songs. Moved here so it can be included in the function.
        if(ON == 1){llSetTimerEvent(SoundLength); ON = 2;}
        if(SoundClipNumber == MaxSoundClips){
            llSetTimerEvent(LastSoundLength); 
            ON = 1; 
            SoundClipNumber = 0;
        }
        //llPreloadSound((string)(SoundClipNumber+1)); //This seems to create a preload, the function seems to replace this.
        if (particles_switch = 1) { //particlestrigger(particles_switch); 
            } else {
            //particlestrigger(particles_switch);
            particles_switch = 0; // This is to make sure when you say off it will turn off and not leave it on. 
            llParticleSystem([]); // This is a second check to make sure the particle system is off. 
            //Function should take care of this.
            };
            //MusicResync(); //Excute Music Resync Feature according to the timer. 9817 
            llRegionSay((integer)MusicSyncCH,(string)SoundClipNumber); //This is so it can be read on anywhere on the region.

}

default
{
    state_entry()
    {   particles_switch = 0;
        RequestionPerms();
        ResetToDefault();
        llListen(0, "", "", "");
    }
    
    attach(key id)
    {
        if(id)
        {
            llOwnerSay(" Commands 'on' or 'off'");
            llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
            PreloadAllSoundswithStatus(); //Preloading all sound files to play normal.
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
         MusicResync();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (MusicSyncCH == channel) { //Reversed Since it was not picking up the channel and picking up the else
              (integer)SoundClipNumber == isInt(message); //Set the SoundClip Number to match what is sent on the channel.
        } 

        message = llToLower(message);
        if (ON == 0 && message == "on" | message == "start")
        {
            ON = 1;
            llStartAnimation(animation);
            //particles_switch = 0; // 1 is on or 0 is off
            //particlestrigger(particles_switch);
            llSetTimerEvent(0.01);
            
        }
        else if(message == "off" | message == "stop"){ResetToDefault();}
    }
}
