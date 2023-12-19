find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

add_library(MainScreen
    STATIC
    MainScreen.cpp
)

target_link_libraries(MainScreen PRIVATE Qt6::Quick)
target_include_directories(MainScreen INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})


target_link_directories(MainScreen PUBLIC ../Controller)
target_link_libraries(MainScreen PUBLIC GenerateController)
