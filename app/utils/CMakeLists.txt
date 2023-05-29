cmake_minimum_required(VERSION 3.26.4)

project(utils)

set(SRC_LIST
  ResourceLoader.mm
  ../interface/mrbp/Utils.hpp
)

add_library(${PROJECT_NAME} ${SRC_LIST})

target_link_libraries(${PROJECT_NAME}
  "-framework Foundation"
  "-framework Metal"
  "-framework MetalKit"
)
