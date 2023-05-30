#!/bin/bash

# Обновление утилит и списка пакетов
pkg update

# Установка необходимых пакетов
pkg install -y openssh autossh termux-services

# Задание пароля для доступа к серверу SSH
passwd

# Настройка файла sshd_config
echo "Port 2222" >> ~/../usr/etc/ssh/sshd_config
echo "PrintMotd no" >> ~/../usr/etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> ~/../usr/etc/ssh/sshd_config
echo "PubkeyAcceptedKeyTypes +ssh-dss" >> ~/../usr/etc/ssh/sshd_config
echo "Subsystem sftp /data/data/com.termux/files/usr/libexec/sftp-server" >> ~/../usr/etc/ssh/sshd_config

# Перезапуск сервера SSH
sv down sshd
sv up sshd

# Настройка автозапуска сервера при старте устройства
sv-enable sshd

# Создание папки для сервиса autossh
mkdir -p ~/../usr/var/service/autossh/

# Создание скрипта запуска сервиса autossh
echo '#!/bin/sh' > ~/../usr/var/service/autossh/run
echo 'exec autossh -M 20022 -NT -f srv_rev' >> ~/../usr/var/service/autossh/run

# Фикс shebang для Termux
termux-fix-shebang ~/../usr/var/service/autossh/run

# Добавление прав на исполнение скрипта
chmod +x ~/../usr/var/service/autossh/run

# Запуск сервиса autossh
sv up autossh
