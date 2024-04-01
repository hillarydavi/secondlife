// Acquired this script from a dancer, reportedly created by Weedman Placebo - secondlife:///app/agent/f9bb6b68-4310-412d-9802-ab2f4a76c5a3/about.
// However, I've been making modifications to this script, intending it to function as a backtrack to the original version. Stay tuned for updates.
integer ON = 0;                    //STATE OF SCRIPT
//YOU EDIT THESE PARTS FOR NEW ANIMATIONS, SOUND CLIPS ETC. DO NOT TOUCH THE SCRIPT
string animation = "Guitar Dance";     //ANIMATION NAME
integer MaxSoundClips = 26;         //AMOUNT OF SONG CLIPS, NAME THEM 1,2,3,4,ETC 
integer SoundLength = 10;           //FIRST SERIES OF SOUND LENGTHS
integer LastSoundLength = 10;       //INCASE LAST SOUND CLIP IS SHORTER
integer SoundClipNumber = 0;       //FOR SOUND LOOP

ResetToDefault()
{
    llStopSound();
    llSetTimerEvent(0.00);
    llStopAnimation(animation);
    ON = 0;
    SoundClipNumber = 0;
}

    
default
{
    state_entry()
    {
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

    timer()
    {
        llPlaySound((string)(++SoundClipNumber),1.0);
        if(ON == 1){llSetTimerEvent(SoundLength); ON = 2;}
        if(SoundClipNumber == MaxSoundClips){llSetTimerEvent(LastSoundLength); ON = 1; SoundClipNumber = 0;}
        llPreloadSound((string)(SoundClipNumber+1));
    }
    
    listen(integer channel, string name, key id, string message)
    {
        message = llToLower(message);
        if (ON == 0 && message == "on")
        {
            ON = 1;
            llStartAnimation(animation);
            llSetTimerEvent(0.01);
        }
        else if(message == "off"){ResetToDefault();}
    }
}
