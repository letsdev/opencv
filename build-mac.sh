#!/usr/bin/env bash
#
# Baut OpenCV als macOS-Shared-Libraries (dylib) zum Linken in CMake-/GoogleTest-Projekten.
# Kein Framework-Wrapper, kein xcframework; Gegenstueck zu lib-openssl/build-mac.sh.
#
# Jede Architektur wird einzeln gebaut (OpenCV unterstuetzt keinen Universal-Build in einem
# Durchgang, NEON-Assembler wuerde sonst auch fuer x86_64 kompiliert) und per lipo zusammengefuegt.
#
# Ergebnis: ./output/macos/install  (lib/*.dylib, include/opencv4, lib/cmake/opencv4/OpenCVConfig.cmake)
#           ./output/opencv-mac.zip  (Inhalt von install/, ohne Symlinks)
#
# Konfiguration ueber Umgebungsvariablen:
#   OPENCV_MAC_ARCHS          Leerzeichen-getrennt, Default "arm64 x86_64"
#   MACOSX_DEPLOYMENT_TARGET  Default 12.0
#   OPENCV_MAC_MODULES        BUILD_LIST, Default "core,imgproc,imgcodecs" (wie der Android-Build)
#   JOBS                      Default: Anzahl CPU-Kerne
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCV_SRC="${SCRIPT_DIR}"
OUT_DIR="${SCRIPT_DIR}/output"
MAC_DIR="${OUT_DIR}/macos"
INSTALL_DIR="${MAC_DIR}/install"
ZIP_FILE="${OUT_DIR}/opencv-mac.zip"

OPENCV_MAC_ARCHS="${OPENCV_MAC_ARCHS:-arm64 x86_64}"
MACOSX_DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET:-12.0}"
OPENCV_MAC_MODULES="${OPENCV_MAC_MODULES:-core,imgproc,imgcodecs}"
JOBS="${JOBS:-$(sysctl -n hw.ncpu)}"

echo "Xcode:             $(xcode-select -p)"
echo "Archs:             ${OPENCV_MAC_ARCHS}"
echo "Deployment target: ${MACOSX_DEPLOYMENT_TARGET}"
echo "Module:            ${OPENCV_MAC_MODULES}"

rm -rf "${MAC_DIR}" "${ZIP_FILE}"
mkdir -p "${MAC_DIR}"

#######
# 1. Pro Architektur konfigurieren, bauen, installieren
#######
ARCH_INSTALL_DIRS=()
for arch in ${OPENCV_MAC_ARCHS}; do
  build_dir="${MAC_DIR}/build-${arch}"
  arch_install_dir="${MAC_DIR}/install-${arch}"
  ARCH_INSTALL_DIRS+=("${arch_install_dir}")

  # OpenCV leitet die Ziel-CPU aus CMAKE_SYSTEM_PROCESSOR ab, und das ist auf macOS immer die
  # Host-CPU (bzw. x86_64, wenn cmake unter Rosetta laeuft). Daher explizit vorgeben, sonst
  # fehlt der arm64-Slice die NEON-Baseline bzw. der x86_64-Slice bekommt NEON-Code.
  case "${arch}" in
    arm64)  cpu_flags=(-DOPENCV_SKIP_SYSTEM_PROCESSOR_DETECTION=ON -DAARCH64=ON) ;;
    x86_64) cpu_flags=(-DOPENCV_SKIP_SYSTEM_PROCESSOR_DETECTION=ON -DX86_64=ON) ;;
    *) echo "Unbekannte Architektur: ${arch}" >&2; exit 1 ;;
  esac

  echo
  echo "################ Building ${arch} ################"
  cmake -S "${OPENCV_SRC}" -B "${build_dir}" -G "Unix Makefiles" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_OSX_ARCHITECTURES="${arch}" \
    "${cpu_flags[@]}" \
    -DCMAKE_OSX_DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET}" \
    -DCMAKE_INSTALL_PREFIX="${arch_install_dir}" \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_LIST="${OPENCV_MAC_MODULES}" \
    -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_DOCS=OFF -DBUILD_opencv_apps=OFF \
    -DBUILD_JPEG_TURBO_DISABLE=ON -DBUILD_ZLIB=ON \
    -DWITH_TIFF=OFF -DWITH_WEBP=OFF -DWITH_FFMPEG=OFF -DWITH_OPENEXR=OFF -DWITH_IPP=OFF \
    -DWITH_OPENCL=OFF -DWITH_LAPACK=OFF -DWITH_EIGEN=OFF \
    -DWITH_OBSENSOR=OFF \
    -DOPENCV_GENERATE_PKGCONFIG=OFF

  cmake --build "${build_dir}" -- -j"${JOBS}"
  cmake --install "${build_dir}"
done

#######
# 2. Erste Architektur als Basis (Header, CMake-Config), dylibs per lipo zusammenfuehren
#######
cp -R "${ARCH_INSTALL_DIRS[0]}" "${INSTALL_DIR}"
# Nicht benoetigt: Setup-Skript, Haar-/LBP-Cascades, valgrind-Suppressions. Lizenzen bleiben.
rm -rf "${INSTALL_DIR}/bin" "${INSTALL_DIR}/share/opencv4"
LIB_DIR="${INSTALL_DIR}/lib"
pushd "${LIB_DIR}" >/dev/null

for real in libopencv_*.*.*.*.dylib; do
  [[ -L "${real}" ]] && continue
  inputs=()
  for d in "${ARCH_INSTALL_DIRS[@]}"; do inputs+=("${d}/lib/${real}"); done
  lipo -create "${inputs[@]}" -output "${real}"
done

#######
# 3. Symlinks entfernen und Install-Names umbiegen
#######
# CMake erzeugt libopencv_x.dylib -> libopencv_x.410.dylib -> libopencv_x.4.10.0.dylib.
# Symlinks ueberleben Maven/Java-Unzip nicht, daher bleibt nur die unversionierte echte Datei uebrig.
# Install-Names und Abhaengigkeiten werden entsprechend auf @rpath/libopencv_x.dylib umgebogen.
declare -a RENAMES=()
for real in libopencv_*.*.*.*.dylib; do
  [[ -L "${real}" ]] && continue
  base="${real%%.*}"                 # libopencv_core
  find . -maxdepth 1 -type l -name "${base}.*dylib" -delete
  mv "${real}" "${base}.dylib"
  RENAMES+=("${real}" "${base}.dylib")
done

for lib in libopencv_*.dylib; do
  install_name_tool -id "@rpath/${lib}" "${lib}"
  for dep in $(otool -L "${lib}" | awk 'NR>1 && /@rpath\/libopencv_/ {print $1}'); do
    depbase="$(basename "${dep}")"
    depbase="${depbase%%.*}.dylib"
    install_name_tool -change "${dep}" "@rpath/${depbase}" "${lib}"
  done
  codesign --force --sign - "${lib}"
done

# OpenCVModules-release.cmake auf die unversionierten Dateinamen umschreiben
CMAKE_MODULES_FILE="$(find "${LIB_DIR}/cmake" -name 'OpenCVModules-release.cmake')"
for ((i = 0; i < ${#RENAMES[@]}; i += 2)); do
  old="${RENAMES[i]}"
  new="${RENAMES[i + 1]}"
  base="${old%%.*}"
  sed -i '' \
    -e "s#${old}#${new}#g" \
    -e "s#${base}\.[0-9]*\.dylib#${new}#g" \
    "${CMAKE_MODULES_FILE}"
done
popd >/dev/null

echo
echo "Ergebnis in ${LIB_DIR}:"
ls -l "${LIB_DIR}"/*.dylib
for lib in "${LIB_DIR}"/*.dylib; do
  echo "--- $(basename "${lib}")"
  lipo -info "${lib}"
  otool -L "${lib}" | sed -n '1,6p'
done

#######
# 4. Zip (ohne Symlinks, die gibt es jetzt nicht mehr)
#######
pushd "${INSTALL_DIR}" >/dev/null
zip -qr "${ZIP_FILE}" .
popd >/dev/null
echo
echo "Zip: ${ZIP_FILE} ($(du -h "${ZIP_FILE}" | cut -f1))"
