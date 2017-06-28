#/bin/bash

# Run this script from the src directory of ZeldaOLB.

sed -i 's/^\( *\)\([^)]*)\);\( *[a-zA-Z ]\)/\1\2;\n\1\3/g' Monde.cpp
sed -i 's/^.*,\([0-9][0-9]*\)\*16.*,\([0-9][0-9]*\)\*16.*$/\0  \/\/ \1,\2/' Monde.cpp
sed -i 's/^.*,16\*\([0-9][0-9]*\).*,16\*\([0-9][0-9]*\).*$/\0  \/\/ \1,\2/' Monde.cpp

