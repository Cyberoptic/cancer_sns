#!/usr/bin/env bash
docker-machine start default
eval "$(docker-machine env default)"
docker-compose up -d