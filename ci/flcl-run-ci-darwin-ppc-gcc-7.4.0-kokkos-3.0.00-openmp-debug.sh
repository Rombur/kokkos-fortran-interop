#!/bin/tcsh
setenv CI_SEP -
setenv CI_BUILD_TYPE debug
setenv CI_BUILD_SUFFIX build
setenv CI_INSTALL_SUFFIX install
setenv CI_MACHINE_ARCH ppc
setenv CI_COMPILER_FAMILY gcc
setenv CI_COMPILER_VER 7.4.0
setenv CI_COMPILER_NAME $CI_COMPILER_FAMILY$CI_SEP$CI_COMPILER_VER$CI_SEP
setenv CI_CUDA_PREFIX cuda
setenv CI_CUDA_VER 
setenv CI_CUDA_NAME 
setenv CI_KOKKOS_PREFIX kokkos
setenv CI_KOKKOS_VER 3.0.00
setenv CI_KOKKOS_BACKEND openmp
setenv CI_KOKKOS_NAME $CI_KOKKOS_PREFIX$CI_SEP$CI_KOKKOS_VER$CI_SEP$CI_KOKKOS_BACKEND$CI_SEP$CI_BUILD_TYPE
setenv CI_KOKKOS_PATH_PREFIX /home/$USER/kt
setenv CI_KOKKOS_INSTALL_DIR $CI_KOKKOS_PATH_PREFIX/$CI_MACHINE_ARCH$CI_SEP$CI_COMPILER_NAME$CI_CUDA_NAME$CI_KOKKOS_NAME
setenv CI_KOKKOS_BUILD_DIR $CI_KOKKOS_INSTALL_DIR$CI_SEP$CI_BUILD_SUFFIX
setenv CI_FLCL_PREFIX flcl
setenv CI_FLCL_PATH_PREFIX /home/$USER/kokkos-fortran-interop
setenv CI_FLCL_CI_PATH_PREFIX $CI_FLCL_PATH_PREFIX/ci
setenv CI_FLCL_KOKKOS_PATH $CI_KOKKOS_INSTALL_DIR/lib64/cmake/Kokkos
setenv CI_FLCL_BUILD_DIR $CI_FLCL_CI_PATH_PREFIX/$CI_FLCL_PREFIX$CI_SEP$CI_MACHINE_ARCH$CI_SEP$CI_COMPILER_NAME$CI_CUDA_NAME$CI_KOKKOS_NAME$CI_SEP$CI_BUILD_SUFFIX
setenv CI_FLCL_INSTALL_DIR $CI_FLCL_CI_PATH_PREFIX/$CI_FLCL_PREFIX$CI_SEP$CI_MACHINE_ARCH$CI_SEP$CI_COMPILER_NAME$CI_CUDA_NAME$CI_KOKKOS_NAME$CI_SEP$CI_INSTALL_SUFFIX
rm -rf $CI_FLCL_INSTALL_DIR
rm -rf $CI_FLCL_BUILD_DIR
mkdir -p $CI_FLCL_INSTALL_DIR
mkdir -p $CI_FLCL_BUILD_DIR
module load cmake/3.17.3
module load gcc/7.4.0
setenv OMP_PROC_BIND spread
setenv OMP_PLACES threads
cd $CI_FLCL_BUILD_DIR
cmake $CI_FLCL_PATH_PREFIX\
    -DKokkos_DIR=$CI_FLCL_KOKKOS_PATH \
    -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON -DBUILD_EXAMPLES=ON \
    -DCMAKE_INSTALL_PREFIX=$CI_FLCL_INSTALL_DIR 
cmake --build $CI_FLCL_BUILD_DIR --parallel
cmake --install $CI_FLCL_BUILD_DIR
ctest
module purge
#rm -rf $CI_FLCL_BUILD_DIR