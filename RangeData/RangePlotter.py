# -*- coding: utf-8 -*-
"""
Created on Tue Feb 24 13:20:19 2015

@author: Kingpin
"""

from os import listdir
from os.path import isfile, join

if __name__ == "__main__":
    mypath = './Data'
    rangeFiles = [ f for f in listdir(mypath) if isfile(join(mypath,f)) ]