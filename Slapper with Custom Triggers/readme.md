# Slapper 2.4 Script

## Overview

This script is designed to trigger slap animations in a virtual environment. When avatars approach the object within a specified distance (0.5 meters), the script detects their position relative to the object and plays either a front or rear slap animation, with separate left and right slap animations for each.

## Features

- Detects avatars within 0.5 meters of the object.
- Plays right or left slap animations based on the avatar's relative position (front or rear).
- Plays a slap sound when triggered.
- Supports both front-facing and rear-facing slap animations.

## Script Details

- **Front Animations**: 
  - `slapRightAnim` triggers when the avatar is in front and to the right.
  - `slapLeftAnim` triggers when the avatar is in front and to the left.
  
- **Back Animations**:
  - `slapBackRightAnim` triggers when the avatar is behind and to the right.
  - `slapBackLeftAnim` triggers when the avatar is behind and to the left.

- **Sound**: The script preloads and plays a slap sound (`69cb141a-805b-2cb2-503e-f6dbac9f68a1`) whenever a slap is triggered.

## Key Functions

### `TriggerSlapAnimation(integer slap)`
- Triggers the appropriate slap animation based on the avatar's position. 
- Animation is chosen according to the slap type (front-right, front-left, back-right, back-left).

### `SensorSlap()`
- Creates a sensor to detect avatars within the maximum distance of 0.5 meters in a 360-degree range.

### `listen(integer channel, string name, key id, string message)`
- Listens for messages from avatars.
- Checks the distance between the object and the avatar.
- If within the distance, calls `SensorSlap()` to trigger the appropriate slap.

### `sensor(integer detected)`
- Processes the avatar's position relative to the object and determines if the avatar is in front or behind the object.
- Calls `TriggerSlapAnimation()` based on the calculated angle and side of the avatar.

## Usage

1. **Permissions**: 
   - The script requests permission to trigger animations (`PERMISSION_TRIGGER_ANIMATION`).

2. **Trigger**: 
   - The slap animations are triggered by an avatar approaching the object and sending a message.
   
3. **Reset**: 
   - The script resets automatically if the owner or region changes.

## How It Works

- When an avatar comes within the detection range, the script determines whether the avatar is in front or behind the object.
- Based on the side (left or right), it plays the appropriate animation and sound.
- Slaps are animated based on predefined slap animations (`slapRight`, `slapLeft`, `slapBackRight`, `slapBackLeft`).

## Configuration

- **maxDistance**: The distance in meters to detect avatars and trigger the slap is set to `0.5`. You can modify this to adjust the detection range.
- **Animations**: The script uses default animation names (`slapRight`, `slapLeft`, `slapBackRight`, `slapBackLeft`). These can be modified in the script if needed.

## Changelog

### Version 2.4 - 10/7/2024
- Updated to trigger separate front and rear slap animations.
- Added support for distinct right and left animations for both front and rear positions.
