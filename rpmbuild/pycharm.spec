Name:     pycharm
Version:  %{pkgver}.%{buildid}
Release:  1.net%{?dist}
Summary:  The only Python IDE you need.
URL:      http://www.jetbrains.com/pycharm
Group: Development/Tools
License: Apache-2.0
Source0:
BuildArch: x86_64
Provides: %{name}

%global debug_package %{nil}

%description
  PyCharm is an integrated development environment (IDE) used for programming in Python.
  It provides code analysis, a graphical debugger, an integrated unit tester, integration 
  with version control systems, and supports web development with Django.

%prep
%setup -q

%build
# Fix python version
find . -type f -name "*.py" -exec sed -e 's@/usr/bin/env python.*@%{__python3}@g' -i "{}" \;

%install
# Set the install directory
install -d %{buildroot}/opt/%{name}

# Extract the files into the destination directory
cp -r * %{buildroot}/opt/%{name}/

# Install the icons
install -d %{buildroot}%{_datadir}/pixmaps
install -m 0644 -p bin/%{name}.png %{buildroot}%{_datadir}/pixmaps/%{name}.png
install -d %{buildroot}%{_datadir}/icons/hicolor/scalable/apps
install -m 0644 -p bin/%{name}.svg %{buildroot}%{_datadir}/icons/hicolor/scalable/apps/%{name}.svg

# Install launcher
install -d %{buildroot}%{_datadir}/applications
install -m 0644 -p %{name}.desktop %{buildroot}%{_datadir}/applications/%{name}.desktop

# Create link to /usr/bin
install -d %{buildroot}%{_bindir}
ln -s /opt/%{name}/bin/%{name} %{buildroot}%{_bindir}/%{name}

%files
%license license/*
/opt/%{name}/
%{_bindir}/%{name}
%{_datadir}/pixmaps/%{name}.png
%{_datadir}/icons/hicolor/scalable/apps/%{name}.svg
%{_datadir}/applications/%{name}.desktop

%changelog
* Tue May 20 2025 cturner - %{version}.%{release}
- Initial build.
