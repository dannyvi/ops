#/bin/sh


# functions

install_zsh () {
    if ! [ -x "$(command -v zsh)" ]; then
        yum -y install zsh
        sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
}


switch_shell () {
    if ! [ "$SHELL" = "/usr/bin/zsh" ] || [ "$SHELL" = "/bin/zsh" ]; then
        chsh -s `which zsh`
    fi
}

install_git () {
    if ! [ -x "$(command -v git)" ]; then
        yum -y install git
    fi
}

install_wget () {
    if ! [ -x "$(command -v wget)" ]; then
        yum -y install wget
    fi
}

install_mysql () {
    if ! [ -x "$(command -v mysql)" ]; then
        wget http://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
        rpm -ivh mysql57-community-release-el7-11.noarch.rpm
        yum -y update
        yum install mysql-community-server mysql-community-client mysql-community-devel mysql-community-common
        service mysqld start
    fi
}

echo_mysql_password () {
    echo "Your MySQL password is:"
    PASSWORD=`cat /var/log/mysqld.log | grep 'temporary password' | awk '{print $NF}'`
    echo $PASSWORD
}

install_redis () {
    if ! [ -x "$(command -v redis-cli)" ]; then
        yum -y install redis
        systemctl start redis
    fi
}

install_python3 () {
    if ! [ -x "$(command -v python3)" ]; then
        sudo yum groupinstall "Development tools"
        sudo yum -y install zlib zlib-devel libffi-devel
        wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz
        tar xJf Python-3.7.0.tar.xz
        cd Python-3.7.0
        sudo ./configure
        sudo make
        sudo make install
    fi
}

install_java () {
    if ! [ -x "$(command -v java)" ]; then
        yum -y install java-1.8.0-openjdk
        JAVA_HOME=$(dirname $(readlink -f $(which java))|sed 's^jre/bin^^')
        echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile
        source /etc/profile
    fi
}

install_maven () {
    if ! [ -x "$(command -v mvn)" ]; then
        yum -y install maven
    fi
}

# installation

yum -y update

install_zsh
switch_shell
install_git
install_wget
install_mysql
install_redis
install_java
install_maven
install_python3
echo_mysql_password
