cmake_minimum_required(VERSION 3.26.4)

# Be sure that you have installed XCode command line tools 
# $ xcode-select --install

project(${MRBP_CUSTOM_RENDERER_APP_NAME} LANGUAGES Swift)

add_subdirectory(renderer)
add_subdirectory(utils)

set(SRC_LIST
  App.swift
  AppDelegate.swift
  AppDelegateIOS.swift
  ContentView.swift
  RendererViewRepresentable.swift
  SceneDelegateIOS.swift
)

if(MRBP_RESOURCE_FOLDER)
  set_source_files_properties(${MRBP_RESOURCE_FOLDER} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
endif()
add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${SRC_LIST} ${MRBP_RESOURCE_FOLDER})

set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE_INFO_PLIST "${MRBP_PATH_TO_BOILERPLATE}/Info.plist.in")
set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE_GUI_IDENTIFIER ${MRBP_BUNDLE_ID})
set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE_BUNDLE_VERSION 1)
set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0")
set_target_properties(${PROJECT_NAME} PROPERTIES RESOURCE MRBP_RESOURCE_FILES)

set_target_properties(${PROJECT_NAME} PROPERTIES XCODE_ATTRIBUTE_COPY_PHASE_STRIP "NO")
set_target_properties(${PROJECT_NAME} PROPERTIES XCODE_ATTRIBUTE_CURRENT_PROJECT_VERSION 1)
set_target_properties(${PROJECT_NAME} PROPERTIES XCODE_ATTRIBUTE_MARKETING_VERSION "1.0")
set_target_properties(${PROJECT_NAME} PROPERTIES XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER ${MRBP_BUNDLE_ID})
target_link_libraries(${PROJECT_NAME} renderer)
