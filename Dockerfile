# This Dockerfile can be used to create a Kali Linux service on 
# devices within a Balena Cloud fleet. 

# INSTALLATION
# Change arguments to match your preferences (UNAME, UPASS, KALI_PACKAGE)
# Uncomment any Optional Metapackages you might want to include in your build
# Run `balena push {YOUR BALENA USERNAME}/{YOUR BALENA FLEET NAME}`
#
# Build times vary depending on what package you use and how many tools are included in that package:
# headless ~30 minutes
# arm ~3 minutes
# core ~2 minutes
#

FROM kalilinux/kali-rolling

# ========== Setup Variables ==========
ARG KALI_PACKAGE="arm"          # Default Kali Package (core, headless, default, arm, nethunter) https://www.kali.org/docs/general-use/metapackages/
ARG SSH_PORT="20022"            # Default SSH port (Update port)
ARG BUILD_ENV="arm64"           # Arcitecture (amd64, arm64, armhf, armel, i386)
ARG UNAME="user"                # Non-root username
ARG UPASS="password123"         # Non-root password
ARG network="static"            # If DHCP, change to DHCP
ARG client_address="192.168.1.2" # Change based on client address
ARG client_netmask="255.255.255.0" # Changed based on client netmask
ARG client_gateway="192.168.1.1" # Change based on client gateway

# ========== Required Updates & Packages ==========

RUN apt update -q --fix-missing  
RUN apt upgrade -y
RUN apt -y install --no-install-recommends sudo wget curl dbus-x11 xinit openssh-server
RUN apt -y install locales
RUN sed -i s/^#\ en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/ /etc/locale.gen
RUN locale-gen
RUN apt -y install --no-install-recommends kali-linux-${KALI_PACKAGE}

# ========== Optional Metapackages ==========
#
# These packages were pulled straight from https://www.kali.org/docs/general-use/metapackages/
# Any of these packages can be installed after deployment on an as-needed basis.

# TOOLS
# RUN apt install -y kali-tools-gpu
# RUN apt install -y kali-tools-hardware
# RUN apt install -y kali-tools-crypto-stego
# RUN apt install -y kali-tools-fuzzing
# RUN apt install -y kali-tools-802-11
# RUN apt install -y kali-tools-bluetooth
# RUN apt install -y kali-tools-rfid
# RUN apt install -y kali-tools-sdr
# RUN apt install -y kali-tools-voip
# RUN apt install -y kali-tools-windows-resources
# RUN apt install -y kali-linux-labs

# MENU
# RUN apt install -y kali-tools-information-gathering
# RUN apt install -y kali-tools-vulnerability
# RUN apt install -y kali-tools-web
# RUN apt install -y kali-tools-database
# RUN apt install -y kali-tools-passwords
# RUN apt install -y kali-tools-wireless
# RUN apt install -y kali-tools-reverse-engineering
# RUN apt install -y kali-tools-exploitation
# RUN apt install -y kali-tools-social-engineering
# RUN apt install -y kali-tools-sniffing-spoofing
# RUN apt install -y kali-tools-post-exploitation
# RUN apt install -y kali-tools-forensics
# RUN apt install -y kali-tools-reporting

# OTHERS
# RUN apt install -y kali-linux-large
# RUN apt install -y kali-linux-everything
RUN curl -fsSL "https://get.docker.com/" | sh
RUN apt install -y pipx
RUN pipx ensurepath
RUN pipx install exegol
RUN source ~/.bashrc
RUN exegol install ad


# ========= Start Script Creation ==========

RUN echo "#!/bin/bash" > /startkali.sh
RUN echo "/etc/init.d/ssh start" >> /startkali.sh
RUN echo "/bin/bash" >> /startkali.sh
RUN chmod 755 /startkali.sh

# ========== Non-Root User Creation ==========

RUN useradd -m -s /bin/bash -G sudo ${UNAME}
RUN echo "${UNAME}:${UPASS}" | chpasswd

# ========== SSH Port Change ==========

RUN echo "Port $SSH_PORT" >>/etc/ssh/sshd_config

# ========== Docker Setup & Start Command ==========

EXPOSE ${SSH_PORT}
WORKDIR "/root"
ENTRYPOINT ["/bin/bash"]
CMD ["/startkali.sh"]
