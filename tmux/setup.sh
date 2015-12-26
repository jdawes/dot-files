#!/bin/bash
curdir=`pwd`

ln -s "${curdir}/tmux.conf" ~/.tmux.conf
tmux source-file tmux.conf
