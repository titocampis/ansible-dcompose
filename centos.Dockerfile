# Download base image ubuntu 18.04
FROM jdeathe/centos-ssh:latest

# Defining the user and password
ARG USER=alex
ARG PSWD=securepassword

# Create the user with home directory and password and the /home/${USER}/.ssh directory, creating /home/${USER}/.ssh and
# creating a symbolic link pointing to the secret file from ~/.ssh/authorized_keys
RUN useradd -m ${USER} && echo "${USER}:${PSWD}" | chpasswd &&\
    mkdir -p /home/${USER}/.ssh &&\
    ln -s /run/secrets/user_ssh_rsa /home/${USER}/.ssh/authorized_keys

# Give permissions to alex, configuring no StringHostkeyChecking and configuring SSH to only allow PubKeyAuthentication
RUN chown -R ${USER}:${USER} /home/${USER}/.ssh/authorized_keys &&\
    echo "Host remotehost\n\tStrictHostKeyChecking no\n" >> /home/${USER}/.ssh/config &&\
    echo "RSAAuthentication yes\nPubkeyAuthentication yes\nPasswordAuthentication no\nIgnoreRhosts yes" >> /etc/ssh/sshd_config

# Inform docker to expose port 22
EXPOSE 22

# Start the ssh service and tail -F anything to mantain the container alive
CMD /usr/sbin/init