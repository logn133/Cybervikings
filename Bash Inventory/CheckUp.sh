#!/bin/bash

./baseInv.sh >> check.txt

diff ./baseOut.txt ./check.txt >> checked.txt