#####   script--dropinanew_Bandit_50/_v1.1
#####   note this script is a list of different face ids, to guide where to set the texture for each part. 
#####   You can get this boat at the mesh shop. http://maps.secondlife.com/secondlife/Dutch%20Harbor/130/154/21
#####   Created by Hillary Davi on 11/10/2023
/*
* When you see the KEY in quotes this is the UUID of the texture that belongs to that part. 
* The number ie 79 this is the texture face when the boat was created. 
* llSetLinkTexture(79, "KEY", 1); 
*/

default
{
    state_entry()
    {
    llSay(0, "Setting Textures, Please wait...");
     //Main Deck
    llSetLinkTexture(79, "KEY", 1); 
    //503_CABIN OUTSIDE-circles
    llSetLinkTexture(27, "KEY", 3);
    llSleep(1);
    //Hull
     llSetLinkTexture(28, "KEY", 0);
      llSleep(1);
    //Pink Doger
     llSetLinkTexture(61, "KEY", 3);
      llSleep(1);
    //Bimini Pink
     llSetLinkTexture(69, "KEY", 0);
     llSleep(1);
    //Cockpit Seating
     llSetLinkTexture(54, "KEY", 0);
     llSleep(1);
    //Frabic Seating Inside
     llSetLinkTexture(98, "KEY", 0);
      llSleep(1);
     //Cabin Outside
     llSetLinkTexture(27, "KEY", 3);
     llSleep(1);
     
     //Fenders Deployed - Yellow
          llSetLinkTexture(68, "KEY", 0);
     llSetLinkTexture(68, "KEY", 1);
     llSleep(1);
     //Fenders Stowed - Yellow
          llSetLinkTexture(67, "KEY", 1);
     llSetLinkTexture(67, "KEY", 2);
      llSleep(1);
     //Hilliebops Flag
          llSetLinkTexture(64, "KEY", 1);
     llSetLinkTexture(64, "KEY", 3);

     llSay(0, "Finished Setting Textures");
     llRemoveInventory(llGetScriptName());
    }
}
