#!/bin/bash


#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

usage() {
    echo "Usage: offline [OPTIONS] $#"
    echo "Options:"
    echo " -h, --help   Display this help message"
    echo " -r, --root   Run as root without the use of: su $USER -c $#"
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

if ! [ -e /var/run/netns/offline ]
then
    echo "netns offline does not exist"
    read -p "create netns offline? [Y/n] " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        sudo ip netns add offline
    fi
fi

while [ "$1" != "" ]; do
    case $1 in
    -r | --root)
        shift
        sudo ip netns exec offline "$1"
        exit 1
        ;;
    -h | --help)
        usage # run usage function
        ;;
    *)\
        sudo ip netns exec offline su "$USER" -c "$1"
        exit 1
        ;;
    esac
    shift
done
