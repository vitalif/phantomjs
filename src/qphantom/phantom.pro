TEMPLATE = lib
TARGET = qphantom
DESTDIR = ../../bin

CONFIG += plugin static

PLUGIN_TYPE = platforms
PLUGIN_CLASS_NAME = PhantomIntegrationPlugin

QT += platformsupport-private

SOURCES +=  main.cpp \
            phantomintegration.cpp \
            phantombackingstore.cpp
HEADERS +=  phantomintegration.h \
            phantombackingstore.h
