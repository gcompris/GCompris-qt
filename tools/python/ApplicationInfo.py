#!/usr/bin/python3
# -*- coding: utf-8 -*-
# GCompris - ApplicationInfo.py
#
# SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

from PyQt5.QtCore import pyqtProperty, QObject, pyqtSignal

class ApplicationInfo(QObject):
    box2DInstalledChanged = pyqtSignal()

    def __init__(self, parent=None):
        super().__init__(parent)

        # Initialise the value of the properties.
        self._isBox2DInstalled = True
        self._isMobile = False

    @pyqtProperty(bool, notify=box2DInstalledChanged)
    def isBox2DInstalled(self):
        return self._isBox2DInstalled

    @isBox2DInstalled.setter
    def isBox2DInstalled(self, isBox2DInstalled):
        self._isBox2DInstalled = isBox2DInstalled

    def createSingleton(self, engine):
        return ApplicationInfo(self)
