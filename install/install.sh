#! /bin/bash
conda env create --name decona -f decona/bin/decona.yml

if [ -d ~/miniconda3/envs/decona ] ;
    then
        cp decona/bin/decona ~/miniconda3/envs/decona/bin ;
elif [ -d ~/miniconda2/envs/decona ] ;
     then
        cp decona/bin/decona ~/miniconda2/envs/decona/bin ;
else echo "It seems like you have a different version of Conda, please let Saskia know so it can be added!" ;
fi
