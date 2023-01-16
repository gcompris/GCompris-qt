#!/usr/bin/python3
# -*- coding: utf-8 -*-
# GCompris - ActivityInfo.py
#
# SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

from PyQt5.QtCore import pyqtProperty, QObject

class ActivityInfo(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)

        # Initialise the value of the properties.
        self._section = ''
        self._credit = ''
        self._manual = ''
        self._prerequisite = ''
        self._author = ''
        self._goal = ''
        self._description = ''
        self._name = ''
        self._title = ''
        self._icon = ''
        self._createdInVersion = 0
        self._difficulty = 0
        self._levels = 0
        self._enabled = True

    @pyqtProperty('QString')
    def section(self):
        return self._section

    @section.setter
    def section(self, section):
        self._section = section

    @pyqtProperty('QString')
    def author(self):
        return self._author

    @author.setter
    def author(self, author):
        self._author = author

    @pyqtProperty('QString')
    def icon(self):
        return self._icon

    @icon.setter
    def icon(self, icon):
        self._icon = icon

    @pyqtProperty('QString')
    def description(self):
        return self._description

    @description.setter
    def description(self, description):
        self._description = description

    @pyqtProperty('QString')
    def name(self):
        return self._name

    @name.setter
    def name(self, name):
        self._name = name

    @pyqtProperty('QString')
    def goal(self):
        return self._goal

    @goal.setter
    def goal(self, goal):
        self._goal = goal

    @pyqtProperty('QString')
    def prerequisite(self):
        return self._prerequisite

    @prerequisite.setter
    def prerequisite(self, prerequisite):
        self._prerequisite = prerequisite

    @pyqtProperty('QString')
    def manual(self):
        return self._manual

    @manual.setter
    def manual(self, manual):
        self._manual = manual

    @pyqtProperty('QString')
    def credit(self):
        return self._credit

    @credit.setter
    def credit(self, credit):
        self._credit = credit

    @pyqtProperty('QString')
    def title(self):
        return self._title

    @title.setter
    def title(self, title):
        self._title = title

    @pyqtProperty(int)
    def difficulty(self):
        return self._difficulty

    @difficulty.setter
    def difficulty(self, difficulty):
        self._difficulty = difficulty

    @pyqtProperty(int)
    def createdInVersion(self):
        return self._createdInVersion

    @createdInVersion.setter
    def createdInVersion(self, createdInVersion):
        self._createdInVersion = createdInVersion

    @pyqtProperty('QString')
    def levels(self):
        return self._levels

    @levels.setter
    def levels(self, levels):
        self._levels = levels

    @pyqtProperty(bool)
    def enabled(self):
        return self._enabled

    @enabled.setter
    def enabled(self, enabled):
        self._enabled = enabled
