sudo xcode-select -s /Applications/Xcode-13.app
xcode-select -p
python3 platforms/apple/build_xcframework.py --disable-bitcode --build_only_specified_archs --iphoneos_archs=arm64,armv7 --iphonesimulator_archs=x86_64,arm64 --without=video --out ./output
