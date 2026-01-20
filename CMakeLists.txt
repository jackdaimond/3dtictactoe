cmake_minimum_required(VERSION 3.16)

project(Q3DTicTacToe VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Core)

set(SOURCES
    Board.hpp       Board.cpp
    BoardModel.hpp  BoardModel.cpp
    main.cpp
    stdincludes.hpp
)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appQ3DTicTacToe
    ${SOURCES}
)

qt_add_qml_module(appQ3DTicTacToe
    URI Q3DTicTacToe
    QML_FILES
        Main.qml
        ui/TicTacToeBoard.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQ3DTicTacToe PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQ3DTicTacToe
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE

    OUTPUT_NAME "3DTicTacToe"
)

target_link_libraries(appQ3DTicTacToe
    PRIVATE Qt6::Quick
)
target_link_libraries(appQ3DTicTacToe PRIVATE Qt6::Core)

target_precompile_headers(appQ3DTicTacToe PUBLIC stdincludes.hpp)

include(GNUInstallDirs)
install(TARGETS appQ3DTicTacToe
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
