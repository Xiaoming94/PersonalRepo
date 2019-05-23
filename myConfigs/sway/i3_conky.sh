#!/bin/bash

echo '{"version":1}'

echo '[[]'

exec conky -c ~/.config/conky/i3conky.conf
