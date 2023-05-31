# Metal Rendering Boilerplate

Boilerplate code for creating rendering demos using Apple Metal in Objective-C++.

It contains:
- MacOS/iOS window and lifecycle management (SwiftUI is used for frontend, MTKView for Metal lifecycle);
- Simple input (Touch/Mouse + Keyboard for MacOS);
- cmake helpers and utilities;
- boilerplate dependencies ([GLM](https://github.com/g-truc/glm)).

Compatibility:
- MacOS 13+
- iOS 14+
- C++ 20

## How to use:
1. Add `metal-rendering-boilerplate` as submodule. E.g. `git submodule add https://github.com/rokuz/metal-rendering-boilerplate 3party/metal-rendering-boilerplate`
2. `git submodule update --init --recursive`
3. Use the following template in your CMake
```cmake
cmake_minimum_required(VERSION 3.26.4)

project(<NAME_OF_YOUR_PROJECT>)

# Include dependencies
include("<PATH_TO_METAL_RENDERING_BOILEPLATE>/dependencies.cmake")

# Enable Metal Rendering Boilerplate
mrbp_enable("<PATH_TO_METAL_RENDERING_BOILEPLATE>")

# Get source code files
mrbp_get_sources_from_folder(SRC_LIST src)

# [Optional] Define resource folder
set(RESOURCE_FOLDER assets)

# Create library (do not pass RESOURCE_FOLDER if you don't have resources)
add_library(<NAME_OF_YOUR_CUSTOM_RENDERER> ${SRC_LIST} ${RESOURCE_FOLDER})

# Set library as custom renderer (do not pass RESOURCE_FOLDER if you don't have resources)
mrbp_set_custom_renderer(<NAME_OF_YOUR_CUSTOM_RENDERER> ${RESOURCE_FOLDER})
```

4. Create a class derived from [`mrbp::MetalRenderer`](https://github.com/rokuz/metal-rendering-boilerplate/blob/main/app/interface/mrbp/MetalRenderer.hpp) class. 
> Tip: Use template files [`TemplateRenderer.hpp`](https://github.com/rokuz/metal-rendering-boilerplate/blob/main/TemplateRenderer.hpp) and [`TemplateRenderer.mm`](https://github.com/rokuz/metal-rendering-boilerplate/blob/main/TemplateRenderer.mm) for the quick start.

In a mm-file, `createMetalDevice`, `createMetalRenderer` and `getLaunchParams` functions must be implemented.
```cpp
// It must create and return Metal Device.
std::shared_ptr<mrbp::MetalDevice> createMetalDevice();

// It must create the `mrbp::MetalRenderer` class's successor instance.
std::unique_ptr<mrbp::MetalRenderer> createMetalRenderer(std::shared_ptr<mrbp::MetalDevice> device,
                                                         glm::uvec2 size,
                                                         MTLPixelFormat colorPixelFormat);
// It must return launch parameters.
mrbp::LaunchParams getLaunchParams();
```

List of launch parameters can be found [here](https://github.com/rokuz/metal-rendering-boilerplate/blob/main/app/interface/mrbp/LaunchParams.hpp).

5. Generate XCode project

MacOS:
```bash
$ cmake -G Xcode -H. -Bbuild
```

iOS:
```bash
$ cmake -G Xcode -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE=<PATH_TO_METAL_RENDERING_BOILEPLATE>/3party/ios-cmake/ios.toolchain.cmake -DPLATFORM=OS64COMBINED -DDEPLOYMENT_TARGET=14.0
```

Happy coding!
