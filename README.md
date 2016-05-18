# tm-bash

a primitive bash script to control a WeMo® powered external Apple Timemachine harddisk

## motivation

The external harddrive with my Apple Timemachine backup is physically mounted on the underside of my desk. Because I hate to crawl below my desk powering on the harddisk every time I want to make a backup I decided to bring a [WeMo® Switch](https://www.belkin.com/us/F7C027-Belkin/p/P-F7C027) into the game.

* The _tm-bash_ script turns on the power, 
* checks if the harddisk is available in OS X,
* initiates the Apple Timemachine backup process,
* waits until the process is done,
* then safely ejects the harddrive from OS X, and
* turns off the power of the WeMo®.

All the user has to do is plug in the USB cable, start the tm-bash script, wait, and unplug the USB cable.

## external dependencies

For controlling the WeMo® I am using a bash script from 2013 I found [on the internet](http://moderntoil.com/?p=839). [Here](http://wemo.forumatic.com/viewtopic.php?t=5&p=9) is a discussion about that script from 2014.

For completeness reasons I added the `wemo.sh` script to this GitHub repository.

Anyways, full credit for the WeMo® control script `wemo.sh` go to rich@netmagi.com and [Donald Burr](mailto:dburr@DonaldBurr.com).

## requirements

You'll need a fully setup Apple Timemachine harddisk and a WeMo® Switch. I develop and use _tm-bash_ on an Apple MacBook Pro with OS X 10.11.

## setup

Set the variables `wemo_script`, `wemp_ip`, `wemo_name`, and `timemachine_volume` to values matching your setup.

```bash
### configuration
logging_log=0
[...]
wemo_script="/Users/jule_/settings/scripts/tm/wemo.sh"
wemo_ip="192.168.0.66"
wemo_name="WeMo Switch"
[...]
timemachine_volume="timemachine"
[...]
```
For more verbose output, you can set the `logging_log` value to `1`.

## usage

Execute the `tm.sh` (make sure `chmod +x` is set).

```bash
machine:folder user$ ./tm.sh
```

## sample output

```bash
INFO: setting WeMo to 'ON'
INFO: waiting for Timemachine volume
■■■■■■■■■■■■■■■■■■■■■
INFO: starting Timemachine backup
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
INFO: Timemachine backup complete
INFO: unmounting 'timemachine'
INFO: setting WeMo to 'OFF'
INFO: Backup complete, Timemachine Volume ejected, Power off
INFO: It is now safe to remove the USB cable from the MacBook Pro
machine:folder user$
```