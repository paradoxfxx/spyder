#!/bin/bash -ex

# -- Installl dependencies
if [ "$USE_CONDA" = "yes" ]; then
    # Avoid problems with invalid SSL certificates
    if [ "$PYTHON_VERSION" = "2.7" ]; then
        conda install -q -y python=2.7.16=h97142e2_0
    fi

    # Install nomkl to avoid installing Intel MKL libraries
    conda install -q -y nomkl

    # Install main dependencies
    conda install -q -y -c spyder-ide --file requirements/conda.txt

    # Install test ones
    conda install -q -y -c spyder-ide --file requirements/tests.txt

    # Github backend tests are failing with 1.1.1d
    conda install -q -y openssl=1.1.1c

    # Remove spyder-kernels to be sure that we use its subrepo
    conda remove -q -y --force spyder-kernels

    # Install python-language-server from Github with no deps
    pip install -q --no-deps git+https://github.com/palantir/python-language-server
else
    # Github backend tests are failing with 1.1.1d
    conda install -q -y openssl=1.1.1c

    # Update pip and setuptools
    pip install -U pip setuptools

    # Install Spyder and its dependencies from our setup.py
    pip install -e .[test]

    # Remove pytest-xvfb because it causes hangs
    pip uninstall -q -y pytest-xvfb

    # Install qtpy from Github
    pip install git+https://github.com/spyder-ide/qtpy.git

    # Install qtconsole from Github
    pip install git+https://github.com/jupyter/qtconsole.git

    # Remove spyder-kernels to be sure that we use its subrepo
    pip uinstall -q -y spyder-kernels

    # Install python-language-server from Github
    pip install -q git+https://github.com/palantir/python-language-server
fi

# Create environment for Jedi environments testsTest for Jedi environments
conda create -n jedi-test-env -q -y python=3.6 flask spyder-kernels
conda list -n jedi-test-env

# Create environment to test conda activation before launching a spyder kernel
conda create -n spytest-ž -q -y python=3.6 spyder-kernels
conda list -n spytest-ž
