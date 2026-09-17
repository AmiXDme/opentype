cmake_minimum_required(VERSION 3.16)
project(OpenType VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Qml Svg Multimedia)
find_package(KF6 COMPONENTS CoreAddons I18n Config ConfigWidgets QUIET)

set(SOURCES
    src/main.cpp
    src/backend/TypingEngine.cpp
    src/backend/TextSource.cpp
    src/backend/StatsStore.cpp
    src/backend/ProfileManager.cpp
    src/backend/ThemeCatalog.cpp
    src/backend/KeyboardLayout.cpp
    src/backend/ContentCatalog.cpp
    src/backend/SoundMixer.cpp
    src/backend/LicenseController.cpp
    src/backend/TranslationManager.cpp
)

set(HEADERS
    src/backend/TypingEngine.h
    src/backend/TextSource.h
    src/backend/StatsStore.h
    src/backend/ProfileManager.h
    src/backend/ThemeCatalog.h
    src/backend/KeyboardLayout.h
    src/backend/ContentCatalog.h
    src/backend/SoundMixer.h
    src/backend/LicenseController.h
    src/backend/TranslationManager.h
    src/backend/AppGlobals.h
)

set(RESOURCES
    resources.qrc
)

add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS} ${RESOURCES})

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Qml
    Qt6::Svg
    Qt6::Multimedia
)

if(KF6_FOUND)
    target_link_libraries(${PROJECT_NAME} PRIVATE
        KF6::CoreAddons
        KF6::I18n
        KF6::Config
        KF6::ConfigWidgets
    )
    target_compile_definitions(${PROJECT_NAME} PRIVATE HAS_KF6)
endif()

install(TARGETS ${PROJECT_NAME} DESTINATION bin)
