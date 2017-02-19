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

For controlling the WeMo® I am using a bash script from 2013 I found [on the internet](http://moderntoil.com/?p=839). ~~[Here](http://wemo.forumatic.com/viewtopic.php?t=5&p=9) is a discussion about that script from 2014~~ (the page is a 404 now and sadly [Wayback Machine](https://web.archive.org/web/20160601000000*/http://wemo.forumatic.com/viewtopic.php?t=5&p=9) has not archived a copy).

For completeness reasons I added the `wemo.sh` script to this GitHub repository.

Anyways, full credit for the WeMo® control script `wemo.sh` go to rich@netmagi.com and [Donald Burr](mailto:dburr@DonaldBurr.com).

## requirements

You'll need a fully setup Apple Timemachine harddisk and a WeMo® Switch. I develop and use _tm-bash_ on an Apple MacBook Pro with OS X 10.11.

## setup

Set the variables `wemo_script`, `wemp_ip`, `wemo_name`, and `timemachine_volume` to values matching your setup.

If you want to add a [LaMetric Time](https://lametric.com/) to the setup you need to set the `lametric_*` values.

```bash
### configuration
logging_log=0
[...]
logging_lametric=1
[...]
wemo_ip="192.168.0.66:49154"
wemo_name="WeMo Switch"
[...]
lametric_push_url="https://developer.lametric.com/api/v1/dev/widget/update/com.lametric.a1b2c3d4e5f6g7h8i9j10k11l12m13n1/1"
lametric_access_token="OZ1Y2X3W4V5U6T7S8R9Q10P11O12N13M14L15K16J17I18H19G20F21E22D23C24B25A26z27y28x29w30v31u=="
lametric_success_delay=10
[...]
timemachine_volume="timemachine"
[...]
```
For more verbose output, you can set the `logging_log` value to `1`.

## optional: LaMetric Time

It is possible to use a [LaMetric Time](https://lametric.com/) to display the current state (standby, active, success, failed) of the _tm-bash_.
To do that you need to [sign up for a developer account at LaMetric](https://developer.lametric.com/register) and create an [indicator app](https://developer.lametric.com/applications/createdisplay) with the _user interface_ type "name" and the _communication type_ "push".

Copy the value of _URL for pushing data_ and enter it as value of `lametric_push_url` in the _configuration_ section of the _tm-bash_.

You also need to copy the value of the `X-Access-Token` from the _Sample push request_ section and enter it as `lametric_access_token` in the _tm-bash_. This is used to authenticate the push requests and makes sure that only your _tm-bash_ can send status data to your _LaMetric Time_.

Finally, to enable the logging to your _LaMetric Time_ you need to set the `logging_lametric` variable to `1`. 



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