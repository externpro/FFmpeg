# FFmpeg dependencies

|project|license [^_l]|description [dependencies]|version|source|diff [^_d]|
|-------|-------------|--------------------------|-------|------|----------|
|<a id='FFmpeg' />[FFmpeg](https://www.ffmpeg.org/)|[LGPL-2.1-or-later](https://www.ffmpeg.org/legal.html 'LGPL version 2.1 or later')|complete, cross-platform solution to record, convert and stream audio and video [deps: _openh264_] [pvt deps: _yasm_]| |[upstream](https://github.com/FFmpeg/FFmpeg 'github.com/FFmpeg/FFmpeg')|  [bin[msw], native[unix]]|
|<a id='openh264' />[openh264](http://www.openh264.org/)|[BSD-2-Clause](http://www.openh264.org/faq.html 'BSD 2-Clause Simplified License')|a codec library which supports H.264 encoding and decoding [deps: _Threads_] [pvt deps: _yasm_]|[xpv1.4.0.4](https://github.com/externpro/openh264/releases/tag/xpv1.4.0.4 'release')|[repo](https://github.com/externpro/openh264 'github.com/externpro/openh264') [upstream](https://github.com/cisco/openh264 'github.com/cisco/openh264')|[diff](https://github.com/externpro/openh264/compare/v1.4.0...xpv1.4.0.4 'github.com/externpro/openh264/compare/v1.4.0...xpv1.4.0.4') [intro]|
|<a id='yasm' />[yasm](http://yasm.tortall.net/)|[BSD-2-Clause](https://github.com/yasm/yasm/blob/v1.3.0/COPYING 'BSD 2-Clause Simplified License')|assembler and disassembler for the Intel x86 architecture|[xpv1.3.0.4](https://github.com/externpro/yasm/releases/tag/xpv1.3.0.4 'release')|[repo](https://github.com/externpro/yasm 'github.com/externpro/yasm') [upstream](https://github.com/yasm/yasm 'github.com/yasm/yasm')|[diff](https://github.com/externpro/yasm/compare/v1.3.0...xpv1.3.0.4 'github.com/externpro/yasm/compare/v1.3.0...xpv1.3.0.4') [patch]|
|<a id='Threads' />[Threads](https://cmake.org/cmake/help/latest/module/FindThreads.html)|[LGPL-2.1-or-later](https://spdx.org/licenses/LGPL-2.1-or-later.html 'GNU Lesser General Public License v2.1 or later')|Finds and determines the thread library of the system for multithreading support|[xpv1.0.4](https://github.com/externpro/Threads/releases/tag/xpv1.0.4 'release')|[repo](https://github.com/externpro/Threads 'github.com/externpro/Threads')|[diff](https://github.com/externpro/Threads/compare/v0...xpv1.0.4 'github.com/externpro/Threads/compare/v0...xpv1.0.4') [bin]|

![deps](xprodeps.svg 'dependencies')

Dependency version check: all 4 parent-manifest versions match pinned versions.

|diff  |description|
|------|-----------|
|patch |diff modifies/patches existing cmake|
|intro |diff introduces cmake|
|auto  |diff adds cmake to replace autotools/configure/make|
|native|diff adds cmake but uses existing build system|
|bin   |diff adds cmake to repackage binaries built elsewhere|
|fetch |diff adds cmake and utilizes FetchContent|

[^_l]: see [SPDX License List](https://spdx.org/licenses/ '') for a list of commonly found licenses
[^_d]: see table above with description of diff
