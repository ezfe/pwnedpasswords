#!/bin/bash
docker build --tag pwnedpasswords .
docker run --rm pwnedpasswords
