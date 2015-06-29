# Usage

```
git clone https://github.com/git/aminamid/pybase.git

export PATH=${PWD}/pybase:${PATH}
init.sh
```

init.sh does

- create ${PWD}/venv dir for virtualenv
- link ${PWD}/.envrc to pybase/envrc_smpl
- create ${PWD}/00_dot file that contain below

```
export PATH=${PWD}/pybase:${PATH}
eval "$(direnv hook bash)"
```
