# DancerScript 9.2/9.3/9.4
 
This script is created by another person in Second Life and modified by Hillary Davi. The script allows avatars to perform dance animations and play synchronized music with various enhanced functionalities.

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Usage](#usage)
- [Functions](#functions)
- [Known Issues](#known-issues)
- [License](#license)

## Introduction
The DancerScript 9.2/9.3/9.4 is designed to enhance the dance experience in Second Life by synchronizing animations and sound clips, along with additional features like particle effects and sound preloading. 

## Features
- **Start and Stop Commands:** Control the dancer with simple text commands ("start" or "on" to start, "stop" or "off" to stop).
- **Enhanced Functions:** Includes multiple utility functions for better control and customization.
- **Particle Effects:** Toggle particle effects on and off during the dance performance.
- **Sound Preloading:** Preloads all sounds in the inventory to ensure smooth playback.
- **Synchronization:** Synchronizes music and animations seamlessly.

## Usage
1. **Attach the Script:** Attach the script to an object in Second Life.
2. **Grant Permissions:** The script will request permissions to trigger animations.
3. **Commands:** Use the following commands in local chat:
   - `on` or `start`: Start the dancer.
   - `off` or `stop`: Stop the dancer.

## Functions
### ResetToDefault()
Resets all variables and prepares the script for future state changes. This function can be called in any state of the script.

### RequestionPerms()
Requests necessary permissions from the owner and resets the script using `ResetToDefault()`.

### MusicResync()
Handles changes upon resynchronization. This function is still undergoing logic testing and is not yet implemented.

### particlestrigger(particles_switch)
Activates or deactivates the particle system based on the `particles_switch` parameter.

### PreloadAllSounds()
Preloads all sound files in the inventory to ensure smooth playback.

### PreloadAllSoundswithStatus()
Similar to `PreloadAllSounds()`, but provides a status update on the preloading progress.

### isInt(string s)
Checks if a string is an integer. Adapted from [Second Life Community Forum](https://community.secondlife.com/forums/topic/108716-check-if-integer/).

## Known Issues
- **Permission Issues:** The script may attempt to trigger animations without the necessary permissions. This can be resolved by resetting the script upon owner change.
- **MusicResync:** The `MusicResync()` function is still in development and not fully functional.

## License
This script is provided as-is with no warranty. Use at your own risk. Modifications and enhancements are welcome.

---

For more information or to report issues, please contact Hillary Davi in Second Life.

