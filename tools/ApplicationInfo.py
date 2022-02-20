#!/usr/bin/python3
# -*- coding: utf-8 -*-

from PyQt5.QtCore import pyqtProperty, QObject, pyqtSignal, pyqtSlot

class ApplicationInfo(QObject):
    box2DInstalledChanged = pyqtSignal()
    localeShortChanged = pyqtSignal()

    def __init__(self, parent=None):
        super().__init__(parent)

        # Initialise the value of the properties.
        self._localeShort = "fr"
        self._isBox2DInstalled = True
        self._isMobile = False

    @pyqtProperty(bool, notify=box2DInstalledChanged)
    def isBox2DInstalled(self):
        return self._isBox2DInstalled

    @isBox2DInstalled.setter
    def isBox2DInstalled(self, isBox2DInstalled):
        self._isBox2DInstalled = isBox2DInstalled

    @pyqtProperty('QString')
    def localeShort(self, notify=localeShortChanged):
        return self._localeShort

    @localeShort.setter
    def setLocaleShort(self, localeShort):
        self._localeShort = localeShort

    def createSingleton(self, engine):
        return ApplicationInfo(self)

    @pyqtSlot()
    def getAudioFilePath(self):
        return ""

    @pyqtSlot()
    def sensorIsSupported(self, string):
        return True
