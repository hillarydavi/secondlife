/*
* Created by Hillary Davi 
* Resources
* http://wiki.secondlife.com/wiki/LlAgentInExperience
* https://wiki.secondlife.com/wiki/LlRequestExperiencePermissions
* https://wiki.secondlife.com/wiki/LlGetExperienceErrorMessage
* https://community.secondlife.com/forums/topic/411603-lsl-experience-teleporter/ 
*/

vector teleportme = <212,150,1000>;
string MyObjectName;
string textdefault = "Teleport to platform!";
//Begin code
string theerror;
integer error;
key agent;
integer type;
default
{
    state_entry()
    {
        MyObjectName = llGetObjectName();
        llVolumeDetect(TRUE);
        llSetText(textdefault, <1.0, 1.0, 1.0>, 1.0);
    }
    collision_start(integer num)
    { 
       agent = llDetectedKey(0); type = llDetectedType(0);
       if (type == (AGENT | ACTIVE) ) // 1 + 2
        {
            llRequestExperiencePermissions(agent, "");
        }   
    } 
    experience_permissions(key agent) {
            llSetText(llKey2Name(agent) + " is using the teleporter please wait...", <1.0, 1.0, 1.0>, 1.0);
            llTeleportAgent(agent, "", teleportme, teleportme);
            llSleep(1);
             llSetText(textdefault, <1.0, 1.0, 1.0>, 1.0);   
    }
    
    experience_permissions_denied(key agent, integer reason){
        string theerror = llGetExperienceErrorMessage((integer)reason);
        if(reason = XP_ERROR_THROTTLED) {
         llSleep(2);
        } else if (reason = XP_ERROR_REQUEST_PERM_TIMEOUT || reason = XP_ERROR_NOT_PERMITTED || reason = XP_ERROR_NOT_FOUND) {
             llInstantMessage(agent, "Please accept the experience or bad things may happen!"); 
            } 
        if(!llAgentInExperience(agent)) {
         llRequestExperiencePermissions(agent, "");  
         //llRequestExperiencePermissions(llDetectedKey(0), "");
        }
       
    }
    
    touch_start(integer total_number)
    {
     agent = llDetectedKey(0);  type = llDetectedType(0);
       if (type == (AGENT | ACTIVE) ) // 1 + 2
        {
            llRequestExperiencePermissions(agent, "");
        } 
    }
     
}
