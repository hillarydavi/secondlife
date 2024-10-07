/*
Created by Hillary Davi on 10/7/2024
Slapper 2.0: This version fixes the issue where the slap animation continues without delays once triggered.
This script triggers the slapRight or slapLeft animation using the /69 command.
*/

integer ON = 0; // Script's state: 0 for idle, 1 for active
float maxDistance = 2.8; // Maximum distance (in meters) to trigger the slap

vector avatarPos; // Position of the avatar that triggers the slap
vector objectPos; // Current position of the object when triggered

string slapRightAnim = "slapRight"; // Name of the right slap animation in the object's inventory
string slapLeftAnim = "slapLeft"; // Name of the left slap animation in the object's inventory
string anim = ""; // Holds the animation name to be triggered
integer slap; // 1 for right slap, 2 for left slap (used in TriggerSlapAnimation)

// Function to trigger the appropriate slap animation
TriggerSlapAnimation(integer slap)
{
    if(ON == 0) 
    {
        ON = 1;
        // Set the appropriate animation based on input
        if(slap == 1) { anim = slapRightAnim; } 
        else if (slap == 2) { anim = slapLeftAnim; };
        
        llStartAnimation(anim); // Start the chosen animation
    }
    else 
    {
        llStopAnimation(anim); // Stop the current animation
        ON = 0;
    }
}

default
{
    state_entry()
    {   
        llPreloadSound("69cb141a-805b-2cb2-503e-f6dbac9f68a1"); // Preload slap sound
        llListen(69, "", NULL_KEY, ""); // Listen for /69 command
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION); // Request permission to trigger animations
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER || change & CHANGED_REGION)
        {
            llResetScript(); // Reset script if the owner or region changes
        }
    }

    run_time_permissions(integer perm)
    {
        if(!(perm & PERMISSION_TRIGGER_ANIMATION))
        {
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION); // Re-request permission if not granted
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        if (id != llGetOwner()) // Only process messages from non-owners
        {
            avatarPos = llList2Vector(llGetObjectDetails(id, [OBJECT_POS]), 0); // Get avatar's position
            objectPos = llGetPos(); // Get the object's position

            // Check if the avatar is within range (2.8 meters)
            if (llVecDist(objectPos, avatarPos) <= maxDistance)
            {
                message = llToLower(message); // Normalize message to lowercase
                
                // Trigger appropriate slap animation based on the message
                if (message == "slapright")
                {
                    TriggerSlapAnimation(1); // Right slap
                }
                else if (message == "slapleft")
                {   
                    TriggerSlapAnimation(2); // Left slap
                }
                llPlaySound("69cb141a-805b-2cb2-503e-f6dbac9f68a1", 1.0); // Play slap sound
            }
        }
    }
}
