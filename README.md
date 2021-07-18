# Markdown Resume Generator
Generate a PDF resume file from Markdown.

## Why

Using Markdown as the base of the resume allows it to play nice with version control such as Git, as well as CLI based text parsing tools such as diff and grep. Splitting up the sections into individual files gives flexibility to mix and match them as required.

This specific example is mostly just my current resume layout and design converted into Markdown. [MkDocs](https://www.mkdocs.org/) and [WeasyPrint](https://weasyprint.org/) were selected to allow this to fit into a self contained Python environment with no other dependencies.

## Overview

A PDF resume is generated based on the steps below.

1. Markdown files that make up the resume are stored in the `docs` directory.
1. [MkDocs](https://www.mkdocs.org/) is used to build these files into HTML, the theme is located in the `resume_theme` directory.
1. [WeasyPrint](https://weasyprint.org/) is used to build the PDF based on the HTML being served by [MkDocs](https://www.mkdocs.org/).

An example of the output PDF is included in this repo as `2021-07-18-resume-YourName.pdf`.

## Setup

To setup the environment, run `make setup` to have the included Makefile do all that is described below.

### Python Environment

[Pyenv](https://github.com/pyenv/pyenv) and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) is recommended for ease of usage, and the Makefile assumes that this has been installed and initialised.

To setup the python environment, run the following commands.

```
pyenv install 3.8.0
pyenv virtualenv 3.8.0 [Env-Name]
echo "[Env-Name]" > .python-version
pip install --upgrade pip
pip install -r requirements.txt
pyenv rehash
```

## Customisation

The layout and design of this resume is based simply what I have been using. If this does not work for you, feel free to change it to suit your needs.

The Theme used by [MkDocs](https://www.mkdocs.org/) is based on an [example theme](https://github.com/mkdocs/mkdocs-basic-theme) provided by [MkDocs](https://www.mkdocs.org/).

The layout is mostly driven by CSS located in `resume_theme/css/theme.css`, with the main structure of the HTML located in `docs/index.md`. Edit these first if you want to change the appearance of the resume.

### YourName

The placeholder of `YourName` or `Your Name` is located in the following files:

- `MakeFile`
- `mkdocs.yml`
- `docs/name.md`

## PDF Generation

To generate a PDF, run `make resume` to have the included Makefile run the following commands.

```
nohup mkdocs serve &>/dev/null & jobs -p %1
weasyprint -v http://127.0.0.1:8000 $(date +"%Y-%m-%d")-resume-YourName.pdf
killall mkdocs
```
