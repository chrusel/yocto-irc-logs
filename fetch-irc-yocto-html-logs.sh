#!/bin/bash

#
# This script fetches the #yocto IRC html logs from www.yoctoproject.org server.
# Having logs on your local disk enables searching and finding solutions for your
# individual problem which was already discussed in IRC. 
#
# Feel free to use and improve that script.
# It hopefully helps, cheers, chrusel
#

# first available logfile:
d_start="2013-03-07"
targetdir="html"

d="${d_start}"
d_end=$(date +%Y-%m-%d)

y_act=$(date -d ${d} +%Y)
mkdir -p "${targetdir}/${y_act}"
cd "${targetdir}/${y_act}" || { echo "error: directory ${targetdir}/${y_act} doesn't exists!"; exit 1; }

while [ "${d}" != "${d_end}" ]; do
  y=$(date -d ${d} +%Y)
  if [ "${y}" != "${y_act}" ]; then
    cd ..
    mkdir -p "${y}"
    cd "${y}" || { echo "error: directory ${y} doesn't exists!"; exit 2; }
    y_act=$y
  fi
  
  filename="%23yocto.${d}.log.html"
  of="${d}.yocto.irc.log.html"
  
  [[ -f ${of} ]] && { d=$(date -I -d "$d + 1 day"); continue; }

  # fetch log
  wget https://www.yoctoproject.org/irc/"${filename}" -O ${of}

  # strip what doesn't interest:
  sed -i '/has joined /d' ./${of}
  sed -i '/has quit IRC/d' ./${of}
  
  # inc date
  d=$(date -I -d "$d + 1 day")
done

