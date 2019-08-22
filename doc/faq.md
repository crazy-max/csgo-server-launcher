## FAQ

### Create multiple instances

If you are not using the Docker image, you can create several CSGO Server Launcher instances by following [this thread](https://github.com/crazy-max/csgo-server-launcher/issues/22)

### cannot create directory "/var/steamcmd"

You've got the following message when you try to install or update steam:

```
mkdir: cannot create directory "/var/steamcmd": Permission denied
```

It's because you are using a specific user (instead of `root`):

```
chown -R steam. /var/steamcmd/
```

> Replace `steam` with your current `USER`

### steamcmd: No such file or directory

You've got the following message when you try to install or update steam :

```
./steamcmd.sh: ligne 29: /var/steamcmd/linux32/steamcmd: No such file or directory
```

It's because you are on a 64-bit architecture and you have to to install the 32-bit libraries:

```
apt-get install -y libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1
```

### libcurl.so: cannot open shared object file

```
libcurl.so: cannot open shared object file: No such file or directory
```

Install `curl` for i386 architecture:

```
dpkg --add-architecture i386
apt-get install -y curl:i386
```
