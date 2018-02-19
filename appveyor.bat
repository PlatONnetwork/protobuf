setlocal

pip install wheel
cd %REPO_DIR%\python
git checkout %BUILD_COMMIT%
sed -i 's/\[\'-Wno-write-strings\',/\[\]/g' setup.py
sed -i '/Wno-invalid-offsetof/d' setup.py
sed -i '/Wno-sign-compare/d' setup.py
cat setup.py
python setup.py bdist_wheel --cpp_implementation --compile_static_extension
