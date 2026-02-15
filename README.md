# Custom 3D Rendering Pipeline in Processing

This project implements a simplified 3D graphics pipeline from scratch in Processing. Instead of using built-in OpenGL transformation functions, all matrix operations and projections are implemented manually.

## Overview

The system maintains a 4×4 homogeneous matrix stack to support hierarchical transformations. Each vertex is transformed using the current transformation matrix (CTM), followed by either orthographic or perspective projection. The final coordinates are mapped directly to screen space.

## Features

- 4×4 homogeneous matrix representation  
- Matrix stack with push and pop operations  
- Manual matrix multiplication  
- Translation, scaling, and rotation (X, Y, Z)  
- Orthographic projection  
- Perspective projection using field-of-view  
- Explicit world-to-screen coordinate mapping  

## Core Concepts Implemented

- Transformation composition via matrix multiplication  
- Homogeneous coordinates  
- Camera and projection geometry  
- Normalized device coordinate mapping  
- Line-based rendering from projected vertices  

## What This Project Demonstrates

This project focuses on understanding the mathematical foundations behind 3D rendering. By implementing transformations and projections manually, it reinforces key ideas from linear algebra and geometry that underlie modern graphics engines.
