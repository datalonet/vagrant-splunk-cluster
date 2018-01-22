##### LOCAL VARIABLES ######
##### Change these to match the environment you need to stand up.
##### CAUTION: NOT ALL SPLUNK VERSIONS SUPPORT CLUSTERING COMMANDS - USE AT YOUR OWN RISK
##### LOCAL VARIABLES ######
##### Change these to match the environment you need to stand up.
##### CAUTION: NOT ALL SPLUNK VERSIONS SUPPORT CLUSTERING COMMANDS - USE AT YOUR OWN RISK

_SPLUNK_VERSION = ["6.6.5","x86_64","rpm"]
_VAGRANT_BOX = "geerlingguy/centos7"


### END LOCAL VARIABLES ###


Vagrant.configure("2") do |config|
  config.vm.box = _VAGRANT_BOX

	config.vm.define "master" do |master|
		master.vm.hostname = "vagrant-master"
                master.vm.network "private_network", ip: "192.168.33.130",
                        virtualbox__intnet: true
                master.vm.network :forwarded_port, host: 8000, guest: 8000
                master.vm.network :forwarded_port, host: 8089, guest: 8089
                master.vm.provision "splunk_base", type: "shell" do |s|
                  s.path = "bootstrap-mtr.sh"
                  s.args = _SPLUNK_VERSION
                end


	end
  config.vm.define "waf" do |waf|
    waf.vm.hostname = "vagrant-waf"
                waf.vm.network "private_network", ip: "192.168.33.170",
                        virtualbox__intnet: true
                waf.vm.network :forwarded_port, host: 8080, guest: 8080
                waf.vm.network :forwarded_port, host:8181, guest: 8089
                waf.vm.network :forwarded_port, host:8100, guest: 8100

                waf.vm.provision "splunk_base", type: "shell" do |s|
                  s.path = "bootstrap-waf.sh"
                  s.args = _SPLUNK_VERSION
                end

  end

	config.vm.define "idx1" do |idx1|

		idx1.vm.hostname = "vagrant-idx1"
		idx1.vm.network "private_network", ip: "192.168.33.100",
			virtualbox__intnet: true
		idx1.vm.network :forwarded_port, host: 8001, guest: 8000
		idx1.vm.network :forwarded_port, host: 8090, guest: 8089

		idx1.vm.provision "splunk_base", type: "shell" do |s|
                        s.path = "bootstrap-idx.sh"
                        s.args = _SPLUNK_VERSION
    		end

	end

	config.vm.define "idx2" do |idx2|
		idx2.vm.hostname = "vagrant-idx2"
                idx2.vm.network "private_network", ip: "192.168.33.110",
                        virtualbox__intnet: true
                idx2.vm.network :forwarded_port, host: 8002, guest: 8000
                idx2.vm.network :forwarded_port, host: 8091, guest: 8089

                idx2.vm.provision "splunk_base", type: "shell" do |s|
                        s.path = "bootstrap-idx.sh"
                        s.args = _SPLUNK_VERSION
                end

        end


	config.vm.define "idx3" do |idx3|
		idx3.vm.hostname = "vagrant-idx3"
                idx3.vm.network "private_network", ip: "192.168.33.120",
                        virtualbox__intnet: true
                idx3.vm.network :forwarded_port, host: 8003, guest: 8000
                idx3.vm.network :forwarded_port, host: 8092, guest: 8089

                idx3.vm.provision "splunk_base", type: "shell" do |s|
                        s.path = "bootstrap-idx.sh"
                        s.args = _SPLUNK_VERSION
                end

        end

	config.vm.define "shc1" do |shc1|
		shc1.vm.hostname = "vagrant-shc1"
                shc1.vm.network "private_network", ip: "192.168.33.140",
                        virtualbox__intnet: true
                shc1.vm.network :forwarded_port, host: 8004, guest: 8000
                shc1.vm.network :forwarded_port, host: 8093, guest: 8089

                shc1.vm.provision "splunk_base", type: "shell" do |s|
                        s.path = "bootstrap-shc.sh"
                        s.args = _SPLUNK_VERSION
                end

        end

        config.vm.define "shc2" do |shc2|
                shc2.vm.hostname = "vagrant-shc2"
		shc2.vm.network "private_network", ip: "192.168.33.150",
                        virtualbox__intnet: true
                shc2.vm.network :forwarded_port, host: 8005, guest: 8000
                shc2.vm.network :forwarded_port, host: 8094, guest: 8089

                shc2.vm.provision "splunk_base", type: "shell" do |s|
                        s.path = "bootstrap-shc.sh"
                        s.args = _SPLUNK_VERSION
                end

        end


        config.vm.define "shc3" do |shc3|
		shc3.vm.hostname = "vagrant-shc3"
                shc3.vm.network "private_network", ip: "192.168.33.160",
                        virtualbox__intnet: true
                shc3.vm.network :forwarded_port, host: 8006, guest: 8000
                shc3.vm.network :forwarded_port, host: 8095, guest: 8089

                shc3.vm.provision "splunk_base", type: "shell" do |s|
                        s.path = "bootstrap-shc.sh"
                        s.args = _SPLUNK_VERSION
                end

        end
end
