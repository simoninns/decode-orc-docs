# Fedora Linux 43 (Workstation Edition)

Clone the repo:

```
git clone https://github.com/simoninns/decode-orc
cd decode-orc/
mkdir build && cd build
```

Install the basic development tools:

```
sudo dnf install -y @development-tools
sudo dnf install -y cmake   gcc-c++ spdlog-devel yaml-cpp-devel sqlite-devel libpng-devel qt6-qtbase-devel
```

Install the FFT library:

```
sudo dnf install -y fftw-devel
```

For optional ffmpeg support you will need the libraries from RPM fusion.  Install RPM fusion with the following command:

```
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

Then swap to the fusion version of ffmpeg

```
sudo dnf swap \
  ffmpeg-free \
  ffmpeg \
  --allowerasing
```

Now install the ffmpeg development libraries:

```
sudo dnf install -y ffmpeg-devel
```

Now you can configure and make:

```
cmake ..
make -j"$(nproc)"
```

If required, you can also install to your system with:

```
sudo make install
```