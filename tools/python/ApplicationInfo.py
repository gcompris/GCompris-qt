#!/usr/bin/python3
# -*- coding: utf-8 -*-
# GCompris - ApplicationInfo.py
#
# SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

from PySide6.QtCore import QObject, Property, Signal

class ApplicationInfo(QObject):
    box2DInstalledChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)

        # Initialise the value of the properties.
        self._isBox2DInstalled = True
        self._isMobile = False

    @Property(bool, notify=box2DInstalledChanged)
    def isBox2DInstalled(self):
        return self._isBox2DInstalled

    @isBox2DInstalled.setter
    def isBox2DInstalled(self, isBox2DInstalled):
        self._isBox2DInstalled = isBox2DInstalled

    def createSingleton(self):
        return ApplicationInfo(self)
