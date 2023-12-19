find_package(Qt6 6.2 COMPONENTS Core REQUIRED)

add_library(GenerateController
    STATIC
    GenerateController.cpp
)
target_link_libraries(GenerateController PRIVATE Qt6::Core)
target_include_directories(GenerateController INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})

target_link_directories(GenerateController PUBLIC ../Model)
target_link_libraries(GenerateController PUBLIC GenerateModel)
