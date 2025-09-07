#
FROM fedora:latest

# Default to UTF-8 file.encoding
ENV LANG=C.UTF-8


COPY wasm.patch /
COPY nonpareil.spec /
# 
RUN dnf -y -q update &&\
	dnf install -y -q \
		python3-scons \
		git \
		procps-ng \
		flex \
		bison \
		gcc \
		patch \
		gtk2-devel gtk2 \
		libgsf libgsf-devel \
		sdl12-compat-devel \
		rpmdevtools rpmlint
#
# ************************************************************************
# Runtime worker
#ENV DBGMODE=on
RUN cat > /startup.sh <<STARTSCRIPT
#!/bin/bash
cd \$HOME
rpmdev-setuptree
cd \${HOME}/rpmbuild/SOURCES
git clone https://github.com/brouhaha/nonpareil.git nonpareil-0.79
tar cpzf \${HOME}/rpmbuild/SOURCES/nonpareil-0.79.tar.gz nonpareil-0.79/
cp /nonpareil.spec \$HOME/rpmbuild/SPECS
cp /wasm.patch  \$HOME/rpmbuild/SOURCES
cd \$HOME/rpmbuild/SPECS
rpmbuild -bb  nonpareil.spec
find \$HOME/rpmbuild -name '*rpm' -exec cp {} /app \;
#set -x
if [ "x\${DBGMODE}" != "x" ]
then
	echo "*************************"
	echo "entering debug shell"
	/bin/bash
fi
STARTSCRIPT
RUN chmod 755 /startup.sh
# ************************************************************************

CMD [ "/startup.sh" ]
