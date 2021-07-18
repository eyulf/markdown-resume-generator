SHELL=/bin/bash

AUTHOR = YourName
DATE= $(shell date +"%Y-%m-%d")
PYTHON_VERSION = 3.8.0
PYTHON_INSTALLED = $(shell echo "" > .python-version && pyenv versions | grep ${PYTHON_VERSION} | wc -l)
PYTHON_VENV_NAME = $(shell basename "${PWD}")
PYTHON_VENV_EXISTS = $(shell echo "" > .python-version && pyenv virtualenvs | grep ${PYTHON_VERSION}/envs/${PYTHON_VENV_NAME} | wc -l)
PYTHON_VENV_DIR = $(shell pyenv root)/versions/${PYTHON_VENV_NAME}
PYTHON_VENV_PYTHON = ${PYTHON_VENV_DIR}/bin/python

## Make sure you have `pyenv` and `pyenv-virtualenv` installed beforehand
##
## https://github.com/pyenv/pyenv
## https://github.com/pyenv/pyenv-virtualenv
##
## Configure your shell with $ eval "$(pyenv virtualenv-init -)"

help:
	@echo "Makefile for document generation"
	@echo ""
	@echo "Usage:"
	@echo "   make clean        Remove the python environment"
	@echo "   make setup        Setup the python environment"
	@echo "   make resume       Generate a resume PDF"

clean:
	@if [[ ${PYTHON_VENV_EXISTS} != 0 ]]; then \
		echo "Removing virtualenv";\
		pyenv virtualenv-delete --force ${PYTHON_VENV_NAME};\
	fi

	@if [[ -f ".python-version" ]]; then \
		rm .python-version;\
	fi

setup:
	@if [[ ${PYTHON_INSTALLED} == 0 ]]; then \
		pyenv install ${PYTHON_VERSION}; \
	fi

	@if [[ ${PYTHON_VENV_EXISTS} == 0 ]]; then \
		pyenv virtualenv ${PYTHON_VERSION} ${PYTHON_VENV_NAME}; \
	fi

	@echo ${PYTHON_VENV_NAME} > .python-version
	@${PYTHON_VENV_PYTHON} -m pip install --upgrade pip
	@${PYTHON_VENV_PYTHON} -m pip install -r requirements.txt
	@pyenv rehash

resume:
	nohup mkdocs serve &>/dev/null & jobs -p %1
	weasyprint -v http://127.0.0.1:8000 ${DATE}-resume-${AUTHOR}.pdf
	killall mkdocs
