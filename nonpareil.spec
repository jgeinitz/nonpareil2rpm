# RPM spec file for Nonpareil
# Copyright 2005 Eric L. Smith <eric@brouhaha.com>
# $Id$

Name: nonpareil
Summary: Microcode-level calculator simulator
Version: 0.79
Release: 50
%define debug_package %{nil}
License: GPL
Group: Applications/Productivity
URL: http://nonpareil.brouhaha.com/
Source0: %{name}-%{version}.tar.gz
Patch0: wasm.patch
#BuildPrereq: scons, flex, bison, gcc
#BuildPrereq: python

%description
Nonpareil simulates many HP calculator models introduced between
1972 and 1982, including the HP-35, HP-25, HP-34C, HP-38C, HP-41CX,
HP-11C, HP-12C, HP-15C, HP-16C, and other models.
 
%prep
%setup -q
%patch -P 0 -p1

%build
scons prefix=/usr

%install
scons prefix=/usr destdir=%{buildroot} install
mkdir -p %{buildroot}/usr/share/icons/nonpareil
for icon in nui/nut/41c/41c.png nui/classic/55/55.png nui/classic/67/67.png
do
    j=$(basename $icon)
    cp $icon %{buildroot}/usr/share/icons/nonpareil/hp${j}
done
mkdir -p %{buildroot}/usr/share/applications
for i in 10c 11c 12c 15c 15c-192 16c 19c 21 22 25 27 29c 31e 32e 33c 33e 34c 35-early 35 37e 38c 38e 45-early 45 55 65 67 70 80 91 92 97
do
    D="%{buildroot}/usr/share/applications/hp_${i}.desktop"
    echo "#!/usr/bin/env xdg-open" > ${D}
    echo '[Desktop Entry]' >>$D
    echo "Name=HP $i calculator" >>$D
    echo "GenericName=HP $i calculator" >>$D
    echo "Exec=nonpareil $i " >>$D
    echo 'Icon=hp55' >>$D
    echo 'Terminal=false' >>$D
    echo 'Type=Application' >>$D
    echo 'Categories=Utility;Calculator;' >>$D
done
for i in 41c 41cv 41cx
do
    cat > %{buildroot}/usr/share/applications/hp_${i}.desktop << eOf3
#!/usr/bin/env xdg-open
[Desktop Entry]
Name=hp${i}
GenericName=HP $i calculator
Exec=nonpareil $i 
Icon=hp41c
Terminal=false
Type=Application
Categories=Utility;Calculator;
eOf3
done
%clean
rm -rf %{buildroot}


%files
%defattr(-,root,root,-)
/usr/lib/nonpareil/*
/usr/bin/*
/usr/share/applications/*
/usr/share/icons/nonpareil/*
%doc


%changelog
* Sat Sep 06 2025 Jurgen Geinitz <jgeinitz@gmx.de> -
- run
* Sat May 28 2005 Eric Smith <eric@brouhaha.com> - 
- Initial build.

