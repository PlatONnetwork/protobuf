setlocal

echo %PATH%
pip install wheel

cd %REPO_DIR%
git checkout %BUILD_COMMIT%
mingw-get
sh autogen.sh

REM cd python
REM sed -i '/Wno-sign-compare/a \ \ \ \ extra_compile_args.append(\'-D_hypot=hypot\')' setup.py
REM cat setup.py
REM 
REM REM sed -i 's/\[\'-Wno-write-strings\',/\[\]/g' setup.py
REM REM sed -i '/Wno-invalid-offsetof/d' setup.py
REM REM sed -i '/Wno-sign-compare/d' setup.py
REM 
REM dir %MINGW%
REM set path
REM gcc
REM %MINGW%\gcc
REM python setup.py bdist_wheel --cpp_implementation --compile_static_extension
