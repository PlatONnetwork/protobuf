setlocal

dir %MINGW%
pip install wheel

REM Checkout release commit
cd %REPO_DIR%
git checkout %BUILD_COMMIT%

REM Build protobuf library
mkdir src\.libs
pushd src\.libs
cmake -G "%generator%" -Dprotobuf_BUILD_SHARED_LIBS=%BUILD_DLL% -Dprotobuf_UNICODE=%UNICODE% -DZLIB_ROOT=%ZLIB_ROOT% -Dprotobuf_BUILD_TESTS=OFF -D"CMAKE_MAKE_PROGRAM:PATH=%MINGW%/mingw32-make.exe" ../../cmake
mingw32-make
popd

REM Build python library
cd python
sed -i '/Wno-sign-compare/a \ \ \ \ extra_compile_args.append(\'-D_hypot=hypot\')' setup.py
sed -i 's/\'-DPYTHON_PROTO2_CPP_IMPL_V2\'/\'-DPYTHON_PROTO2_CPP_IMPL_V2\',\'-D_hypot=hypot\'/g' setup.py

IF NOT %PYTHON_ARCH%==64 GOTO no_win64_change
sed -i '/Wno-sign-compare/a \ \ \ \ extra_compile_args.append(\'-DMS_WIN64\')' setup.py
sed -i 's/\'-DPYTHON_PROTO2_CPP_IMPL_V2\'/\'-DPYTHON_PROTO2_CPP_IMPL_V2\',\'-DMS_WIN64\'/g' setup.py
:no_win64_change

cat setup.py
python setup.py bdist_wheel --cpp_implementation --compile_static_extension
cd ..\..
