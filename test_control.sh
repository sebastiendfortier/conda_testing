#!/bin/bash

. activate tester
python kernel_tester.py --notebooks control.ipynb --kernels domcmc-39
