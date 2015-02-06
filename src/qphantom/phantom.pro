TEMPLATE = lib
TARGET = qphantom
DESTDIR = ../../bin

CONFIG += plugin
CONFIG += qpa/genericunixfontdatabase

PLUGIN_TYPE = platforms
PLUGIN_CLASS_NAME = PhantomIntegrationPlugin

QT += core-private gui-private platformsupport-private

SOURCES =   main.cpp \
            phantomintegration.cpp \
            phantombackingstore.cpp
HEADERS =   phantomintegration.h \
            phantombackingstore.h

OTHER_FILES += phantom.json
