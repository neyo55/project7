#!/bin/bash

LOG_FILE="/var/log/install_packages.log"

echo "Starting package installation script at $(date)" | tee -a "$LOG_FILE"

# Update package lists
echo "Updating package lists..." | tee -a "$LOG_FILE"
sudo apt-get update -y >"$LOG_FILE" 2>&1

# Install Python
if ! command -v python3 &>/dev/null; then
    echo "Installing Python..." | tee -a "$LOG_FILE"
    sudo apt-get install -y python3 python3-pip >"$LOG_FILE" 2>&1
else
    echo "Python is already installed." | tee -a "$LOG_FILE"
fi

# Install Nginx
if ! command -v nginx &>/dev/null; then
    echo "Installing Nginx..." | tee -a "$LOG_FILE"
    sudo apt-get install -y nginx >"$LOG_FILE" 2>&1
    sudo systemctl enable nginx >"$LOG_FILE" 2>&1
    sudo systemctl start nginx >"$LOG_FILE" 2>&1
else
    echo "Nginx is already installed." | tee -a "$LOG_FILE"
fi

# Install Node.js (Updated to version 18)
if ! command -v node &>/dev/null; then
    echo "Installing Node.js..." | tee -a "$LOG_FILE"
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - >"$LOG_FILE" 2>&1
    sudo apt-get install -y nodejs gcc g++ make >"$LOG_FILE" 2>&1
else
    echo "Node.js is already installed." | tee -a "$LOG_FILE"
fi

# Install Java
if ! command -v java &>/dev/null; then
    echo "Installing Java..." | tee -a "$LOG_FILE"
    sudo apt-get install -y openjdk-11-jdk >"$LOG_FILE" 2>&1
else
    echo "Java is already installed." | tee -a "$LOG_FILE"
fi

# Install Docker
if ! command -v docker &>/dev/null; then
    echo "Installing Docker..." | tee -a "$LOG_FILE"
    sudo apt-get remove -y docker docker-engine docker.io containerd runc >"$LOG_FILE" 2>&1
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release >"$LOG_FILE" 2>&1

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg >"$LOG_FILE" 2>&1
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    sudo apt-get update -y >"$LOG_FILE" 2>&1
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >"$LOG_FILE" 2>&1

    # Start and enable Docker
    echo "Ensuring Docker service is started..." | tee -a "$LOG_FILE"
    sudo systemctl enable docker >"$LOG_FILE" 2>&1
    sudo systemctl start docker >"$LOG_FILE" 2>&1
else
    echo "Docker is already installed." | tee -a "$LOG_FILE"
fi

# Install Git
if ! command -v git &>/dev/null; then
    echo "Installing Git..." | tee -a "$LOG_FILE"
    sudo apt-get install -y git >"$LOG_FILE" 2>&1
else
    echo "Git is already installed." | tee -a "$LOG_FILE"
fi

# Install Ansible
if ! command -v ansible &>/dev/null; then
    echo "Installing Ansible..." | tee -a "$LOG_FILE"
    sudo apt-get install -y ansible >"$LOG_FILE" 2>&1
else
    echo "Ansible is already installed." | tee -a "$LOG_FILE"
fi

# Install Apache2
if ! command -v apache2 &>/dev/null; then
    echo "Installing Apache2..." | tee -a "$LOG_FILE"
    sudo apt-get install -y apache2 >"$LOG_FILE" 2>&1
    sudo systemctl enable apache2 >"$LOG_FILE" 2>&1
    sudo systemctl start apache2 >"$LOG_FILE" 2>&1
else
    echo "Apache2 is already installed." | tee -a "$LOG_FILE"
fi

# Install Apache2-utils
if ! dpkg -s apache2-utils &>/dev/null; then
    echo "Installing Apache2-utils..." | tee -a "$LOG_FILE"
    sudo apt-get install -y apache2-utils >"$LOG_FILE" 2>&1
else
    echo "Apache2-utils is already installed." | tee -a "$LOG_FILE"
fi

# Verify installations
echo "Verifying installations..." | tee -a "$LOG_FILE"
{
    python3 --version
    nginx -v
    node -v
    java -version
    docker --version
    git --version
    ansible --version
    apache2 -v
    docker run hello-world
} >>"$LOG_FILE" 2>&1 || {
    echo "Verification failed. Check the log file at $LOG_FILE." | tee -a "$LOG_FILE"
    exit 1
}

echo "Installation completed. Check $LOG_FILE for detailed logs." | tee -a "$LOG_FILE"









# #!/bin/bash

# LOG_FILE="/var/log/install_packages.log"

# echo "Starting package installation script at $(date)" | tee -a "$LOG_FILE"

# # Update package lists
# echo "Updating package lists..." | tee -a "$LOG_FILE"
# sudo apt-get update -y >"$LOG_FILE" 2>&1

# # Install Python
# if ! command -v python3 &>/dev/null; then
#     echo "Installing Python..." | tee -a "$LOG_FILE"
#     sudo apt-get install -y python3 python3-pip >"$LOG_FILE" 2>&1
# else
#     echo "Python is already installed." | tee -a "$LOG_FILE"
# fi

# # Install Nginx
# if ! command -v nginx &>/dev/null; then
#     echo "Installing Nginx..." | tee -a "$LOG_FILE"
#     sudo apt-get install -y nginx >"$LOG_FILE" 2>&1
#     sudo systemctl enable nginx >"$LOG_FILE" 2>&1
#     sudo systemctl start nginx >"$LOG_FILE" 2>&1
# else
#     echo "Nginx is already installed." | tee -a "$LOG_FILE"
# fi

# # Install Node.js (Updated to version 18)
# if ! command -v node &>/dev/null; then
#     echo "Installing Node.js..." | tee -a "$LOG_FILE"
#     curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - >"$LOG_FILE" 2>&1
#     sudo apt-get install -y nodejs gcc g++ make >"$LOG_FILE" 2>&1
# else
#     echo "Node.js is already installed." | tee -a "$LOG_FILE"
# fi

# # Install Java
# if ! command -v java &>/dev/null; then
#     echo "Installing Java..." | tee -a "$LOG_FILE"
#     sudo apt-get install -y openjdk-11-jdk >"$LOG_FILE" 2>&1
# else
#     echo "Java is already installed." | tee -a "$LOG_FILE"
# fi

# # Install Docker
# if ! command -v docker &>/dev/null; then
#     echo "Installing Docker..." | tee -a "$LOG_FILE"
#     sudo apt-get remove -y docker docker-engine docker.io containerd runc >"$LOG_FILE" 2>&1
#     sudo apt-get install -y \
#         ca-certificates \
#         curl \
#         gnupg \
#         lsb-release >"$LOG_FILE" 2>&1

#     sudo mkdir -p /etc/apt/keyrings
#     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg >"$LOG_FILE" 2>&1
#     echo \
#         "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#         $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

#     sudo apt-get update -y >"$LOG_FILE" 2>&1
#     sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >"$LOG_FILE" 2>&1

#     # Start and enable Docker
#     echo "Ensuring Docker service is started..." | tee -a "$LOG_FILE"
#     sudo systemctl enable docker >"$LOG_FILE" 2>&1
#     sudo systemctl start docker >"$LOG_FILE" 2>&1
# else
#     echo "Docker is already installed." | tee -a "$LOG_FILE"
# fi

# # Install Git
# if ! command -v git &>/dev/null; then
#     echo "Installing Git..." | tee -a "$LOG_FILE"
#     sudo apt-get install -y git >"$LOG_FILE" 2>&1
# else
#     echo "Git is already installed." | tee -a "$LOG_FILE"
# fi

# # Install Ansible
# if ! command -v ansible &>/dev/null; then
#     echo "Installing Ansible..." | tee -a "$LOG_FILE"
#     sudo apt-get install -y ansible >"$LOG_FILE" 2>&1
# else
#     echo "Ansible is already installed." | tee -a "$LOG_FILE"
# fi

# # Verify installations
# echo "Verifying installations..." | tee -a "$LOG_FILE"
# {
#     python3 --version
#     nginx -v
#     node -v
#     java -version
#     docker --version
#     git --version
#     ansible --version
#     docker run hello-world
# } >>"$LOG_FILE" 2>&1 || {
#     echo "Verification failed. Check the log file at $LOG_FILE." | tee -a "$LOG_FILE"
#     exit 1
# }

# echo "Installation completed. Check $LOG_FILE for detailed logs." | tee -a "$LOG_FILE"



















# #!/bin/bash

# LOG_FILE="/var/log/install_packages.log"

# echo "Starting package installation script at $(date)" | tee -a "$LOG_FILE"

# # Update package lists
# echo "Updating package lists..." | tee -a "$LOG_FILE"
# sudo apt-get update -y >"$LOG_FILE" 2>&1

# # Install Python
# if ! command -v python3 &>/dev/null; then
#     echo "Installing Python..." | tee -a "$LOG_FILE"
#     sudo apt-get install -y python3 python3-pip >"$LOG_FILE" 2>&1
# else
#     echo "Python is already installed." | tee -a "$LOG_FILE"
# fi

# # Install Nginx
# if ! command -v nginx &>/dev/null; then
#     echo "Installing Nginx..." | tee -a "$LOG_FILE"
#     sudo apt-get install -y nginx >"$LOG_FILE" 2>&1
#     sudo systemctl enable nginx >"$LOG_FILE" 2>&1
#     sudo systemctl start nginx >"$LOG_FILE" 2>&1
# else
#     echo "Nginx is already installed." | tee -a "$LOG_FILE"
# fi

# # Install Node.js (Updated to version 18)
# if ! command -v node &>/dev/null; then
#     echo "Installing Node.js..." | tee -a "$LOG_FILE"
#     curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - >"$LOG_FILE" 2>&1
#     sudo apt-get install -y nodejs gcc g++ make >"$LOG_FILE" 2>&1
# else
#     echo "Node.js is already installed." | tee -a "$LOG_FILE"
# fi

# # Install Java
# if ! command -v java &>/dev/null; then
#     echo "Installing Java..." | tee -a "$LOG_FILE"
#     sudo apt-get install -y openjdk-11-jdk >"$LOG_FILE" 2>&1
# else
#     echo "Java is already installed." | tee -a "$LOG_FILE"
# fi

# # Install Docker
# if ! command -v docker &>/dev/null; then
#     echo "Installing Docker..." | tee -a "$LOG_FILE"
#     sudo apt-get remove -y docker docker-engine docker.io containerd runc >"$LOG_FILE" 2>&1
#     sudo apt-get install -y \
#         ca-certificates \
#         curl \
#         gnupg \
#         lsb-release >"$LOG_FILE" 2>&1

#     sudo mkdir -p /etc/apt/keyrings
#     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg >"$LOG_FILE" 2>&1
#     echo \
#         "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#         $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

#     sudo apt-get update -y >"$LOG_FILE" 2>&1
#     sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >"$LOG_FILE" 2>&1

#     # Start and enable Docker
#     echo "Ensuring Docker service is started..." | tee -a "$LOG_FILE"
#     sudo systemctl enable docker >"$LOG_FILE" 2>&1
#     sudo systemctl start docker >"$LOG_FILE" 2>&1
# else
#     echo "Docker is already installed." | tee -a "$LOG_FILE"
# fi

# # Verify installations
# echo "Verifying installations..." | tee -a "$LOG_FILE"
# {
#     python3 --version
#     nginx -v
#     node -v
#     java -version
#     docker --version
#     docker run hello-world
# } >>"$LOG_FILE" 2>&1 || {
#     echo "Verification failed. Check the log file at $LOG_FILE." | tee -a "$LOG_FILE"
#     exit 1
# }

# echo "Installation completed. Check $LOG_FILE for detailed logs." | tee -a "$LOG_FILE"







