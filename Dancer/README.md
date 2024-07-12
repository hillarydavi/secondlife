# DancerScript 9.1

This script is created by another person in Second Life and modified by Hillary Davi. It controls a dancer animation and a series of sound clips. By typing "start" or "on," it will start the dancer. Typing "stop" or "off" will shut off the dancer.

## Script Overview

### Main Features:
- **ResetToDefault()**: Resets all variables and stops any running animations or sounds.
- **RequestionPerms()**: Requests necessary permissions and resets the script to its default state.
- **MusicResync()**: (Under development) Aims to handle changes in synchronization by listening for sync changes and executing the latest change to the `SoundClipNumber` integer.
- **particlestrigger()**: Toggles the particle system on and off.
  - To toggle: set `particles_switch = 1` (on) or `particles_switch = 0` (off).
  - Call `particlestrigger(particles_switch)` to update the particle system.
- **PreloadAllSounds()**: Preloads all sound files in the inventory to ensure smooth playback.

### Variables:
- `integer ON`: State of the script (0: off, 1: starting, 2: running).
- `string animation`: Name of the animation to play.
- `integer MaxSoundClips`: Total number of sound clips.
- `integer SoundLength`: Duration of each sound clip.
- `integer LastSoundLength`: Duration of the last sound clip, if shorter.
- `integer SoundClipNumber`: Tracks the current sound clip number.
- `integer particles_switch`: Controls the particle system (0: off, 1: on).

### Particle System:
- The particle system can be triggered by calling `particlestrigger(particles_switch)`.
- The system uses various settings like `PSYS_PART_FLAGS`, `PSYS_SRC_PATTERN`, `PSYS_SRC_BURST_SPEED_MIN`, `PSYS_SRC_BURST_SPEED_MAX`, and more to create visual effects.

## Script Functions

### ResetToDefault
Resets the script to its initial state by:
- Stopping sounds and animations.
- Resetting timers and variables.
- Disabling the particle system.

### RequestionPerms
Requests necessary permissions from the owner and calls `ResetToDefault()`.

### PreloadAllSounds
Preloads all sounds in the inventory to ensure they play without delay.

## Script States and Events

### State: default
- **state_entry()**: Preloads all sounds, requests permissions, and sets up a listener for chat commands.
- **attach(key id)**: Handles attachment events, requests permissions, and preloads sounds.
- **changed(integer change)**: Resets the script if the owner or inventory changes.
- **timer()**: Manages the playback of sound clips, setting timers, and preloading the next sound.
- **listen(integer channel, string name, key id, string message)**: Listens for chat commands to start or stop the dancer.

## Usage Instructions
- **Start the Dancer**: Type "start" or "on".
- **Stop the Dancer**: Type "stop" or "off".

This script combines animation, sound playback, and particle effects to create a dynamic dancer experience in Second Life.
