# Define custom utilities for deploying on travis

function deploy {
    # Config pypirc
    echo "[distutils]" > ~/.pypirc
    echo "index-servers=" >> ~/.pypirc
    echo "    test" >> ~/.pypirc
    echo "" >> ~/.pypirc
    echo "[test]" >> ~/.pypirc
    echo "repository = https://test.pypi.org/legacy/" >> ~/.pypirc
    echo "username = $WHEELHOUSE_UPLOADER_USERNAME" >> ~/.pypirc
    echo "password = $WHEELHOUSE_UPLOADER_SECRET" >> ~/.pypirc

    # Upload
    twine upload -r test $TRAVIS_BUILD_DIR/wheelhouse/*
}
