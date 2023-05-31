cmake_minimum_required(VERSION 3.26.4)

project(renderer)

set(SRC_LIST
  ${PROJECT_NAME}.h
  ${PROJECT_NAME}.modulemap
  LaunchParams.h
  LaunchParams.mm
  RendererView.h
  RendererView.mm
  RendererViewDelegate.h
  RendererViewDelegate.mm
  ../interface/mrbp/Input.hpp
  ../interface/mrbp/LaunchParams.hpp
  ../interface/mrbp/MetalRenderer.hpp
)

add_library(${PROJECT_NAME} SHARED ${SRC_LIST})

set(PUBLIC_HEADER_LIST
  ${PROJECT_NAME}.h # public header for the framework
  LaunchParams.h
  RendererView.h
)
set_target_properties(${PROJECT_NAME} PROPERTIES
  FRAMEWORK TRUE
  MACOSX_FRAMEWORK_IDENTIFIER "${MRBP_BUNDLE_ID}.renderer"
  PUBLIC_HEADER "${PUBLIC_HEADER_LIST}"
)

#set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_FRAMEWORK_GUI_IDENTIFIER "${MRBP_BUNDLE_ID}.renderer")
#set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_FRAMEWORK_BUNDLE_VERSION 1)
#set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_FRAMEWORK_SHORT_VERSION_STRING "1.0")

set_target_properties(${PROJECT_NAME} PROPERTIES XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "${MRBP_BUNDLE_ID}.renderer")
set_target_properties(${PROJECT_NAME} PROPERTIES XCODE_ATTRIBUTE_DEFINES_MODULE "YES")
set_target_properties(${PROJECT_NAME} PROPERTIES XCODE_ATTRIBUTE_MODULEMAP_FILE "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}.modulemap")

set_target_properties(${PROJECT_NAME} PROPERTIES XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++20")

if(PLATFORM_MAC)
  set(UI_FRAMEWORK AppKit)
elseif(PLATFORM_IOS)
  set(UI_FRAMEWORK UIKit)
endif()

target_link_libraries(${PROJECT_NAME}
  "-framework ${UI_FRAMEWORK}"
  "-framework Metal"
  "-framework MetalKit"
  "-framework CoreGraphics"
  "-framework CoreVideo"
  "-framework QuartzCore"
)
