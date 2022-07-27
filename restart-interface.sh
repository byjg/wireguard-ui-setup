#!/bin/bash

/usr/bin/wg syncconf ${WG_INTERFACE} <(/usr/bin/wg-quick strip ${WG_INTERFACE})
