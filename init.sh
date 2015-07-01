#!/bin/bash

export PYBASE=${PWD}/pybase
export PATH=${PYBASE}:${PATH}
VENV=venv
VIRTUALENV_DIR=${PWD}/${VENV}

update() {
    # Rename extension
    # Filepath -> Fileprefix -> Fileprefix -> IO()
    cp ${1} $(dirname ${1})/_${2}.$(basename ${1}) &&
    mv $(dirname ${1})/_${3}.$(basename ${1}) ${1}
    diff -u $(dirname ${1})/_${2}.$(basename ${1}) ${1}
}

relocate() { 
    # Rename 
    # Dirpath -> Filepath ->  Dirpath -> IO ()
    cat ${2} | sed -e "s#^\( *\(set.* \)\{0,\}VIRTUAL_ENV[= ]\)\".*/${VENV}\"#\1\"${3}/${VENV}\"#" > $(dirname ${2})/_new.$(basename ${2})
    update ${2} org new
}

if ! [ -d ${VIRTUALENV_DIR} ]; then
    virtualenv.py --no-site-packages --distribute ${VIRTUALENV_DIR}
    virtualenv.py --relocatable ${VIRTUALENV_DIR}
fi


for vdir in $(ls -d ${VIRTUALENV_DIR})
do
    for file in $(ls ${vdir}/bin/activate* )
    do
        echo ${vdir} ${file} ${PWD}
        relocate ${vdir} ${file} ${PWD}
    done
done

rm -f ${PWD}/{.envrc,00_dot}

ln -s ${PYBASE}/envrc_smpl ${PWD}/.envrc
echo 'export PATH=${PWD}/pybase:${PATH}' > ${PWD}/00_dot
echo 'eval "$(direnv hook bash)"' >> ${PWD}/00_dot


echo if you want to fallback exec below commands
ls  ${VIRTUALENV_DIR}/bin/activate* | sed -e 's#\(\(.*\)/\([^/]*\)\)#cp \2/_org.\3 \1#' | xargs -i echo {}

