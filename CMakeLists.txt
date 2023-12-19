cmake_minimum_required(VERSION 3.16)

project(RGZ_TAP VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)
add_subdirectory(Model)
add_subdirectory(View)
add_subdirectory(Controller)

qt_add_executable(appRGZ_TAP
    main.cpp
)

qt_add_qml_module(appRGZ_TAP
    URI RGZ_TAP
    VERSION 1.0
    QML_FILES main.qml View/MainScreen.qml View/DialogWindow.qml
)

set_target_properties(appRGZ_TAP PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)
target_link_libraries(appRGZ_TAP
    PRIVATE Qt6::Quick)
target_link_libraries(appRGZ_TAP PRIVATE MainScreen)
target_link_libraries(appRGZ_TAP PUBLIC TableModel)
#target_link_libraries(appLab_1TAP PRIVATE GenerateController)
#target_link_libraries(appLab_1TAP PRIVATE GenerateModel)
install(TARGETS appRGZ_TAP
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
