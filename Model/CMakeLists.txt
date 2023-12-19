find_package(Qt6 6.2 COMPONENTS Core REQUIRED)
find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

add_library(GenerateModel
    STATIC
    GenerateModel.cpp
)
target_link_libraries(GenerateModel PRIVATE Qt6::Core)
target_include_directories(GenerateModel INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})

add_library(TableModel
    STATIC
    TableModel.cpp
)
target_link_libraries(TableModel PRIVATE Qt6::Core)
target_link_libraries(TableModel PRIVATE Qt6::Quick)
target_include_directories(TableModel INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
