#!/bin/bash

pwd

bundle exec rake debug:build
bundle exec rake debug:test
