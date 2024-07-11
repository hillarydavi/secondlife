<h1>DancerScript9</h1>
This script was initially created by another person in Second Life and has been modified by Hillary Davi. It is designed to control a dancer animation and associated particle effects in Second Life.

<h1>Features</h1>
Animation Control: Start and stop a specified dance animation with simple text commands.
Sound Looping: Play a series of sound clips in a loop, with preloading to minimize delays.
Particle Effects: Trigger particle effects when the dance animation starts.
Permission Handling: Automatically request necessary permissions to trigger animations.
Reset Functionality: Reset all variables and stop all effects with a single function call.

<h1>Usage</h1>
<h2>Commands</h2>
start or on: Start the dancer animation and associated effects.
stop or off: Stop the dancer animation and reset all effects.
Setup
Edit the Script Variables:

animation: Name of the dance animation.
MaxSoundClips: Number of sound clips in the inventory, named sequentially (1, 2, 3, etc.).
SoundLength: Duration of each sound clip.
LastSoundLength: Duration of the last sound clip if it differs from the others.
Add Sounds:

Ensure sound clips are added to the object's inventory and named sequentially (1, 2, 3, etc.).
Attach the Script:

Attach the script to the object in Second Life.

<h2>Functions</h2>
ResetToDefault()
Resets all variables and stops all animations and sounds. Can be called in any state of the script.
RequestionPerms()
Quickly requests permissions to trigger animations. Intended to be used with ResetToDefault().
MusicResync() (Under Development)
Intended to handle resynchronization changes. Not yet fully implemented.
particlestrigger()
Activates the particle system. Calls ResetToDefault() at the end.
PreloadAllSounds()
Preloads all sound files in the object's inventory. Run during the state entry to ensure smooth playback.
