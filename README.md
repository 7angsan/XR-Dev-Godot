# Educational VR Content for UP Students (Capstone Project - Spring 2025)

This documentation was written by the Capstone Team in Spring 2025. The information below may be outdated due to hardware/software capabilities. We recommend updating the documentation when necessary for future capstone teams handling this project.

## Project Overview

### Description:
This application is intended to produce educational content in VR for UP students in intermediate to advanced courses. The idea was inspired when Shaz Vijlee, the vice-dean of the engineering department, saw how students struggled in some courses moreso than others due to complexity of explaining high level topics that is hard to visualize. He envisioned a way to reproduce abstract concepts in an interactive and immersive manner through the usage of VR. The codebase is led by a capstone team: the XR Development Team. Through this project, we hope to enrich the student's learning experience.

### Features:

#### Player Controls (Left/Right controller works the same):
- **Movement:** Use the thumbstick of the Meta Quest 3 controller to change the direction of the player.
- **Object Interaction:** Press the trigger buttons on the controllers to interact with objects within the modules.
- **Game Movement:** To move in the game, the player needs to use both the triggers and the thumbstick on the Meta Quest 3 controller simultaneously.

#### Modules:
Currently, the application features three implemented educational modules, each covering a different concept in Computer Science (CS):

1. **Trees** (Topic in Data Structures)
   - The user can interact with buttons to visualize binary trees in 3D and dynamically modify values to demonstrate how it works.
2. **Selection Sort** (Algorithms and Data Structures)
   - **Demo Mode (Tutorial Phase):** The user walks through a tutorial that explains the concept of Selection Sort and solves statically generated problems.
   - **Interactive Mode (Problem Solving Phase):** The user must solve problems independently. To select boxes, the user must face the box, click the triggers, and move it to the intended direction.
3. **Turing Machines** (Theory of Computation)
   - The user needs to input data (via a keyboard, not yet implemented in VR) for the Turing Machine to generate and execute results.

Each module includes unique settings tailored to the content, though some features may overlap between modules when appropriate from a design standpoint.

Upon running the game (see Installation Instructions for details), the player will spawn at a hub, from which teleporters connect to the respective modules.

### Screenshots or Demo:
Visual aids such as screenshots or gameplay videos (e.g., on YouTube) are recommended to help users understand what the app looks like and how it works.

## Installation Instructions

### Prerequisites:
- **Godot 4.3** or higher
- **Meta Quest 3** with controllers
- **Keyboard** (required for the Turing Machine module)
- **Meta Quest Link** (to connect the headset)

### Setup:
1. Install **Meta Quest Link** and connect your VR headset to your computer.
2. Install **Godot Engine 4.3** or higher from [Godot Engine's website](https://godotengine.org/).
3. Clone the repository to your local machine.
4. Open **Godot Engine** and import the cloned repository.
5. Edit the repository folder as needed.
6. Run the game. If you encounter any popups (e.g., "OpenXR not found"), ensure the headset is properly connected to the Oculus App.

## Contributing

This project will not be actively maintained by external contributors. We advise developers and future capstone teams to **fork** the repository for any modifications instead of submitting pull requests or creating issues in this repository.

