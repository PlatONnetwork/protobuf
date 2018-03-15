# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    pushd protobuf

    # Build protoc
    ./autogen.sh
    ./configure

    CXXFLAGS="-fPIC -g -O2" ./configure
    make -j8

    # Generate python dependencies.
    pushd python
    python setup.py build_py
    popd

    popd
}

function bdist_wheel_cmd {
    # Builds wheel with bdist_wheel, puts into wheelhouse
    #
    # It may sometimes be useful to use bdist_wheel for the wheel building
    # process.  For example, versioneer has problems with versions which are
    # fixed with bdist_wheel:
    # https://github.com/warner/python-versioneer/issues/121
    local abs_wheelhouse=$1

    # Modify build version
    pwd
    ls
    echo $abs_wheelhouse
    echo $BUILD_VERSION
    if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
        sed -i.bu "s/^__version__.*/__version__ = '$BUILD_VERSION'/" google/protobuf/__init__.py
    else
        sed -i "s/^__version__.*/__version__ = '3.5.2'/" google/protobuf/__init__.py
    fi
    cat google/protobuf/__init__.py
    
    python setup.py bdist_wheel --cpp_implementation --compile_static_extension
    cp dist/*.whl $abs_wheelhouse
}

function build_wheel {
    build_wheel_cmd "bdist_wheel_cmd" $@
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    python -c "from google.protobuf.pyext import _message;"
}
