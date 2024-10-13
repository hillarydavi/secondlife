/*
Created by Hillary Davi on 10/7/2024
Slapper 2.4: Updated to trigger front and rear slaps. 
When in front, right and left slap animations trigger. 
When behind, separate right and left rear animations trigger.
*/

integer ON = 0; // Script's state: 0 for idle, 1 for active
float maxDistance = 0.5; // Maximum distance (in meters) to trigger the slap

vector avatarPos; // Position of the avatar that triggers the slap
vector objectPos; // Current position of the object when triggered

// Front animations
string slapRightAnim = "slapRight"; // Right slap (front) animation
string slapLeftAnim = "slapLeft"; // Left slap (front) animation

// Back animations
string slapBackRightAnim = "slapBackRight"; // Right slap (rear) animation
string slapBackLeftAnim = "slapBackLeft"; // Left slap (rear) animation

string anim = ""; // Holds the animation name to be triggered
integer slap; // 1 for right slap, 2 for left slap, 3 for back right, 4 for back left

// Function to trigger the appropriate slap animation
TriggerSlapAnimation(integer slap)
{
    if (ON == 0) 
    {
        ON = 1;
        // Set the appropriate animation based on input
        if (slap == 1) { anim = slapRightAnim; } 
        else if (slap == 2) { anim = slapLeftAnim; }
        else if (slap == 3) { anim = slapBackRightAnim; }
        else if (slap == 4) { anim = slapBackLeftAnim; }
        
        llStartAnimation(anim); // Start the chosen animation
    }
    else 
    {
        llStopAnimation(anim); // Stop the current animation if already playing
        ON = 0;
    }
}

// Function to create a sensor that detects the avatar's relative position
SensorSlap()
{
    llSensor("", NULL_KEY, AGENT, maxDistance, PI); // Detect any avatar within maxDistance and 360 degrees
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
        if (!(perm & PERMISSION_TRIGGER_ANIMATION))
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

            // Check if the avatar is within maxDistance (0.5 meters)
            if (llVecDist(objectPos, avatarPos) <= maxDistance)
            {
                message = llToLower(message); // Normalize message to lowercase

                // Start sensor to check relative position and trigger animations accordingly
                SensorSlap(); // Call sensor function to detect avatar's position
            }
            else
            {
                llOwnerSay("Target is too far away to slap.");
            }
        }
    }

    sensor(integer detected)
    {
        if (detected > 0) // If the sensor detects an avatar
        {
            vector avatarPos = llDetectedPos(0); // Get detected avatar position
            vector objectPos = llGetPos(); // Get object position
            vector forwardDir = llRot2Fwd(llGetRot()); // Get the forward direction of the object

            vector diff = avatarPos - objectPos; // Difference vector between object and avatar
            float angle = llAcos(llVecNorm(diff) * forwardDir); // Calculate the angle between object front and avatar

            // Determine if the avatar is in front or back, and on which side
            if (angle < PI_BY_TWO) // Front
            {
                if (llVecNorm(diff) * llRot2Left(llGetRot()) > 0) 
                {
                    TriggerSlapAnimation(1); // Right slap (front)
                }
                else 
                {
                    TriggerSlapAnimation(2); // Left slap (front)
                }
            }
            else // Back
            {
                if (llVecNorm(diff) * llRot2Left(llGetRot()) > 0) 
                {
                    TriggerSlapAnimation(3); // Right slap (rear)
                }
                else 
                {
                    TriggerSlapAnimation(4); // Left slap (rear)
                }
            }
            llPlaySound("69cb141a-805b-2cb2-503e-f6dbac9f68a1", 1.0); // Play slap sound
        }
    }
}
