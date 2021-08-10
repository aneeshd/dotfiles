#!/bin/bash

set -e

PYVER=3.9.6

which pyenv || brew install pyenv
pyenv install -s $PYVER
[ -d $(brew --cellar python) ] || mkdir -p $(brew --cellar python)
ln -s ~/.pyenv/versions/$PYVER $(brew --cellar python)/$PYVER
brew link python3

which pipenv || pip install pipenv

