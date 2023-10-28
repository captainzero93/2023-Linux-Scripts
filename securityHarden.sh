#!/bin/bash

# Update System
echo "Updating System..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Uncomplicated Firewall
echo "Installing Firewall..."
sudo apt-get install ufw -y

# Configure Firewall
echo "Configuring Firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

# Install Fail2Ban
echo "Installing Fail2Ban..."
sudo apt-get install fail2ban -y

# Install ClamAV
echo "Installing ClamAV..."
sudo apt-get install clamav -y

# Update ClamAV Database
echo "Updating ClamAV Database..."
sudo freshclam

# Disable root login
echo "Disabling root login..."
sudo passwd -l root

# Remove unnecessary packages
echo "Removing unnecessary packages..."
sudo apt-get remove telnetd nis yp-tools rsh-client rsh-redone-client xinetd -y

# Configure audit rules
echo "Configuring audit rules..."
sudo apt-get install auditd -y
echo "-w /etc/passwd -p wa -k identity" | sudo tee /etc/audit/rules.d/identity.rules
echo "-w /etc/group -p wa -k identity" | sudo tee -a /etc/audit/rules.d/identity.rules
sudo systemctl enable auditd

# Disable Unused Filesystems
echo "Disabling Unused Filesystems..."
sudo bash -c 'cat << EOF > /etc/modprobe.d/CIS.conf
install cramfs /bin/true
install freevxfs /bin/true
install jffs2 /bin/true
install hfs /bin/true
install hfsplus /bin/true
install squashfs /bin/true
install udf /bin/true
EOF'

# Secure Boot Settings
echo "Securing Boot Settings..."
sudo chown root:root /boot/grub/grub.cfg
sudo chmod og-rwx /boot/grub/grub.cfg

# Restrict Access to Compilers (Optional)
#echo "Restricting Access to Compilers..."
#sudo chmod 700 /usr/bin/as /usr/bin/byacc /usr/bin/yacc /usr/bin/bcc /usr/bin/kgcc /usr/bin/cc /usr/bin/gcc /usr/bin/*c++ /usr/bin/*g++

# Disable Core Dumps
echo "Disabling Core Dumps..."
echo "* hard core 0" | sudo tee -a /etc/security/limits.conf

# Enable Address Space Layout Randomization (ASLR)
echo "Enabling ASLR..."
echo "kernel.randomize_va_space = 2" | sudo tee -a /etc/sysctl.conf

# All done
echo "Basic Security Configuration Applied Successfully!"
