Let's use vagrant to auto-provision a Splunk Clustered Environment.

* LoaBalancing Haproxy for three search Head
* 1 Master Node
* 3 Indexers
* 3 Search Heads

#Requirement
We can upload rpm package of SPlunk Entrprise on Github. You Have to suscribe  with an account on https://www.splunk.com/en_us/download.html?r=header

and download in the folder the wanted rpm:
* 6.6.5
* 7.0.1 (latest)

You can modify Vagrantfile at the top with the right release:

```
_SPLUNK_VERSION = ["6.6.5","x86_64","rpm"]
```

#How-To

First, install Vagrant and Virtualbox (but this could probably use whatever Vagrant has hooks for).

This was built with Vagrant 2.0 Virtualbox 5.2


Run Vagrant up, create one master node, 3 indexers, 3 search-head andh other a haproxy loadbalancing. You can work in Vagrant environment with other VM-Vagrant you have to config network VM with 192.168.33.XX
except:
* 192.168.33.100 (idx1)
* 192.168.33.120 (idx2)
* 192.168.33.130 (idx3)

* 192.168.33.110 (master licence)

* 192.168.33.140 (search-head 1)
* 192.168.33.150 (search-head 2)
* 192.168.33.160 (search-head 3)

The Vagrantfile will stand up the entire Indexer Cluster, Search Head Cluster, and Master Node, and configure each as needed.

The credentials for all systems are: admin/superS3cr3t.


* master
    * VM IP: 192.168.33.130
    * Web: https://127.0.0.1:8000
    * Management: https://127.0.0.1:8089
    * Functions: Master Node, License Master (Trial license), Deployer.


* waf
    * VM IP: 192.168.33.70
    * search-head-backend: https://127.0.0.1:8100
    * Management: https://127.0.0.1:8181
    * HAproxy Management: http://127.0.0.1:8080

#REQUIREMENTS:
* vagrant 1.9 +
* virtualbox 5.2
