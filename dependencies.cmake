set(CMAKE_Swift_LANGUAGE_VERSION 5)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(PLATFORM_MAC TRUE)
  message("Setting PLATFORM_MAC to true")
elseif (${CMAKE_SYSTEM_NAME} MATCHES "iOS")
  set(PLATFORM_IOS TRUE)
  message("Setting PLATFORM_IOS to true")
endif()

# Enable metal rendering boilerplate to the project.
function(mrbp_enable path_to_boilerplate)
  set(MRBP_PATH_TO_BOILERPLATE "${CMAKE_CURRENT_SOURCE_DIR}/${path_to_boilerplate}" PARENT_SCOPE)

  include_directories(${path_to_boilerplate})
  include_directories(${PROJECT_BINARY_DIR})
  include_directories(${path_to_boilerplate}/app/interface)
  include_directories(${path_to_boilerplate}/3party/glm)

  add_definitions(-DGLM_ENABLE_EXPERIMENTAL -DGLM_FORCE_CTOR_INIT -DGLM_FORCE_RADIANS)
  add_subdirectory(${path_to_boilerplate}/3party/glm glm)

  configure_file(
    "${path_to_boilerplate}/mrbp_config.hpp.in"
    "${PROJECT_BINARY_DIR}/mrbp/Config.hpp"
  )
endfunction()

# Get sources from the folder.
function(mrbp_get_sources_from_folder out_sources_list sources_folder)
  file(GLOB_RECURSE _SOURCES_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${sources_folder}/*)
  source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES ${_SOURCES_FILES})
  list(FILTER _SOURCES_FILES EXCLUDE REGEX ".DS_Store")
  foreach(source IN LISTS _SOURCES_FILES)
    if(source MATCHES \\.\(metal\)$)
      set_source_files_properties(${source} PROPERTIES LANGUAGE METAL)
    endif()
  endforeach()
  set(${out_sources_list} ${_SOURCES_FILES} PARENT_SCOPE)
endfunction()

# Set custom renderer to the project.
function(mrbp_set_custom_renderer custom_renderer_target)
  set(MRBP_BUNDLE_ID "${custom_renderer_target}.app")
  set(MRBP_CUSTOM_RENDERER_APP_NAME "${custom_renderer_target}_app")

  set(resource_folder ${ARGN})
  if(resource_folder)
    set(MRBP_RESOURCE_FOLDER "${CMAKE_CURRENT_SOURCE_DIR}/${resource_folder}")
  endif()

  # Add mrbp targets
  add_subdirectory(${MRBP_PATH_TO_BOILERPLATE}/app app)

  # Copy default.metallib (if it exists) to the app bundle
  if (PLATFORM_MAC)
    set(_RESOURCES_FOLDER "$<TARGET_FILE_DIR:${MRBP_CUSTOM_RENDERER_APP_NAME}>/../Resources")
  elseif(PLATFORM_IOS)
    set(_RESOURCES_FOLDER "$<TARGET_FILE_DIR:${MRBP_CUSTOM_RENDERER_APP_NAME}>")
  endif()
  add_custom_command(
    TARGET
      ${custom_renderer_target}
    WORKING_DIRECTORY
      "${CMAKE_CURRENT_SOURCE_DIR}"
    DEPENDS
      "$<TARGET_FILE_DIR:${custom_renderer_target}>/default.metallib"
    COMMAND
      [ -f "$<TARGET_FILE_DIR:${custom_renderer_target}>/default.metallib" ] && 
      mkdir -p "${_RESOURCES_FOLDER}" &&
      cp -r "$<TARGET_FILE_DIR:${custom_renderer_target}>/default.metallib" "${_RESOURCES_FOLDER}/default.metallib"
    COMMENT "Copy default.metallib to the app bundle ..."
  )

  # Link custom renderer to renderer.framework
  target_link_libraries(renderer
    ${custom_renderer_target}
  )

  # Link utils to custom render target
  target_link_libraries(${custom_renderer_target}
    utils
  )

  # Enable shader debugging
  set_target_properties(${custom_renderer_target} PROPERTIES 
                        XCODE_ATTRIBUTE_MTL_ENABLE_DEBUG_INFO[variant=Debug] "INCLUDE_SOURCE")
endfunction()
