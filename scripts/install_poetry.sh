#!/bin/bash

if ! command -v pipx ; then
    echo "pipx was not found!"
    exit 1
fi

pipx install poetry
