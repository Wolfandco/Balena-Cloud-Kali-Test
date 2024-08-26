# Balena Cloud Kali Image
The Balena Cloud platform allows for the remote management of IOT devices. This service can be used along with the Kali Docker image to create a simple "drop box" for penetration testing. After provisioning, devices in the Kali fleet can be dropped into a target network allowing penetration testing to continue remotely with all the tools included in a basic kali installation.

## Installation
### Single Click Deploy
[![balena deploy button](https://www.balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/Wolfandco/Balena-Cloud-Kali-Image)

### Balena CLI Install
1. Get project files `git clone https://github.com/T3ch404`
2. In the Dockerfile, Change default arguments (UNAME, UPASS, etc.) & uncomment any Optional Metapackages you might want to include in your build
3. Deploy with Balena CLI `balena push {YOUR BALENA USERNAME}/{YOUR BALENA FLEET NAME}`

## Legal
**Important: Please read this disclaimer before using or distributing this tool.**
This project is intended for educational and legal purposes only, including penetration testing and security research. It should only be used in a legal and responsible manner. Any unauthorized or malicious use of this tool is strictly prohibited.

This project is in no way affiliated, endorsed or associated with Offensive Security, Kali Linux, or Balena inc.

This tool is provided "as is" without any warranty or guarantee. The authors and contributors of this project are not responsible for any damage or consequences resulting from the use of this tool.

## Credit
This project is loosly based on onemarcfifty/kali-linux
