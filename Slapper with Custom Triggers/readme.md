# Slapper 2.0 Script

## Overview
Slapper 2.0 is a scripted animation system designed to trigger right or left slap animations in response to specific commands issued on a private chat channel. It includes improvements from previous versions, ensuring that the slap animations are triggered smoothly without delays once a trigger command is received. The script listens for the `/69` command and based on the direction (`slapright` or `slapleft`), it activates the appropriate animation.

## Features
- **Right and Left Slap Animations**: Trigger `slapRight` or `slapLeft` animations based on user input.
- **Distance Triggering**: The script only triggers the slap if the triggering avatar is within 2.8 meters of the object.
- **Smooth Transition**: Fixes delay issues in previous versions, ensuring a seamless slap animation once triggered.
- **Permissions Handling**: Automatically requests animation-triggering permissions from the object's owner.
- **Slap Sound**: Plays a sound effect when a slap is triggered.

## Usage
### Commands:
- `/69 slapright`: Triggers the `slapRight` animation from the object inventory.
- `/69 slapleft`: Triggers the `slapLeft` animation from the object inventory.

### Conditions:
- **Maximum Distance**: The avatar must be within 2.8 meters of the object for the slap animation to trigger.
- **Permissions**: The script will request permission to trigger animations when it's started or when the owner changes.

### Slap Sound:
The script plays a predefined sound file (`69cb141a-805b-2cb2-503e-f6dbac9f68a1`) when a slap animation is triggered.

## Script Breakdown
### Main Variables:
- `ON`: Keeps track of the script's state (0 = idle, 1 = active).
- `maxDistance`: Defines the maximum distance (2.8 meters) within which the slap can be triggered.
- `slapRightAnim` and `slapLeftAnim`: Names of the slap animations in the object's inventory.
- `anim`: Stores the current animation name.

### Main Functions:
- `TriggerSlapAnimation(integer slap)`: Triggers either the right or left slap animation based on the input (`1` for right, `2` for left).

### Event Listeners:
- `state_entry()`: Preloads the slap sound and requests animation permissions.
- `listen()`: Listens for commands on the `/69` channel and triggers the appropriate slap animation if the avatar is within range.

## Installation
1. Copy the provided script into the object’s content in-world.
2. Ensure the `slapRight` and `slapLeft` animations are in the object’s inventory.
3. Add the sound file `69cb141a-805b-2cb2-503e-f6dbac9f68a1` to the object’s inventory.
4. Save the script and reset it if needed.

## Known Issues
- None reported for this version.

## Future Improvements
- **Customization**: Add support for user-defined distances or custom animations.
- **Enhanced Error Handling**: Provide feedback if permissions aren't granted or animations are missing.
  
## License
This script is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Author
- **Hillary Davi**
  - Created on: 10/7/2024
