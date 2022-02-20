#!/usr/bin/python3
# -*- coding: utf-8 -*-

from PyQt5.QtCore import pyqtProperty, QObject

class Dataset(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)

        # Initialise the value of the properties.
        self._objective = ''
        self._difficulty = 0
        self._data = ''
        self._enabled = True

    @pyqtProperty('QString')
    def objective(self):
        return self._objective

    @objective.setter
    def objective(self, objective):
        self._objective = objective

    @pyqtProperty(int)
    def difficulty(self):
        return self._difficulty

    @difficulty.setter
    def difficulty(self, difficulty):
        self._difficulty = difficulty

    @pyqtProperty('QVariant')
    def data(self):
        return self._data

    @data.setter
    def data(self, data):
        self._data = data

    @pyqtProperty(bool)
    def enabled(self):
        return self._enabled

    @enabled.setter
    def enabled(self, enabled):
        self._enabled = enabled
