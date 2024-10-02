# Используем официальный образ Ubuntu в качестве основы
FROM ubuntu:latest

# Устанавливаем OpenSSH Server и sudo
RUN apt-get update && apt-get install -y openssh-server sudo

# Создаем директорию для работы SSH
RUN mkdir /var/run/sshd

# Добавляем пользователя с именем 'user' и назначаем пароль 'password'
RUN useradd -rm -d /home/user -s /bin/bash -G sudo -u 1001 user
RUN echo 'user:123' | chpasswd

# Настраиваем SSH для входа под пользователем root
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitEmptyPasswords no' >> /etc/ssh/sshd_config
RUN echo 'ChallengeResponseAuthentication no' >> /etc/ssh/sshd_config
RUN echo 'UsePAM yes' >> /etc/ssh/sshd_config

# Копируем публичный ключ с хоста
COPY authorized_keys /home/user/.ssh/authorized_keys
RUN chown -R user /home/user/.ssh && chmod 600 /home/user/.ssh/authorized_keys

# Открываем порт 22 для SSH
EXPOSE 22

# Запускаем SSH-сервер
CMD ["/usr/sbin/sshd", "-D"]
