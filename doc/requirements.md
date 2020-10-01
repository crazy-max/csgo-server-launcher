## Requirements

Obviously a [Steam](http://steampowered.com) account is required. If you are **not** using the Docker image you have to install the following packages on your host:

* [awk](http://en.wikipedia.org/wiki/Awk)
* [screen](http://linux.die.net/man/1/screen)
* [wget](http://en.wikipedia.org/wiki/Wget)
* [tar](http://linuxcommand.org/man_pages/tar1.html)

### Disk Space

Should have atleast 25 GB free space. If you see the error like below, disk space is not sufficient. You need to use a bigger disk.

```
Error! App '740' state is 0x202 after update job.
```

### Email

To be able to make use of the UPDATE_EMAIL function in the csgo-server-launcher.conf, you need to have an email server. e.g. 
* [postfix](https://en.wikipedia.org/wiki/Postfix_(software))
