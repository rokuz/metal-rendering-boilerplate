cmake_minimum_required(VERSION 3.26.4)

project(utils)

set(SRC_LIST
  ResourceLoader.mm
  ../interface/mrbp/Utils.hpp
)

add_library(${PROJECT_NAME} ${SRC_LIST})

set_target_properties(${PROJECT_NAME} PROPERTIES XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++20")

target_link_libraries(${PROJECT_NAME}
  "-framework Foundation"
  "-framework Metal"
  "-framework MetalKit"
)
