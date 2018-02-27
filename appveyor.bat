setlocal

pip install wheel

cd %REPO_DIR%
git checkout %BUILD_COMMIT%

REM Build protobuf library
mkdir src\.libs
pushd src\.libs
cmake -G "%generator%" -Dprotobuf_BUILD_SHARED_LIBS=%BUILD_DLL% -Dprotobuf_UNICODE=%UNICODE% -DZLIB_ROOT=%ZLIB_ROOT% -Dprotobuf_BUILD_TESTS=OFF -D"CMAKE_MAKE_PROGRAM:PATH=%MINGW%/mingw32-make.exe" ../../cmake
mingw32-make
dir
popd

REM Build python library
cd python

sed -i '/Wno-sign-compare/a \ \ \ \ extra_compile_args.append(\'-D_hypot=hypot\')' setup.py
sed -i 's/\'-DPYTHON_PROTO2_CPP_IMPL_V2\'/\'-DPYTHON_PROTO2_CPP_IMPL_V2\',\'-D_hypot=hypot\'/g' setup.py

cat setup.py

REM sed -i 's/\[\'-Wno-write-strings\',/\[\]/g' setup.py
REM sed -i '/Wno-invalid-offsetof/d' setup.py
REM sed -i '/Wno-sign-compare/d' setup.py

dir %MINGW%
set path
gcc
%MINGW%\gcc
python setup.py bdist_wheel --cpp_implementation --compile_static_extension
dir dist
cd ..\..
