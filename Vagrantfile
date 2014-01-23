# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = "opscode_ubuntu-12.04_provisionerless"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.vm.define 'graphite' do |c|
    c.vm.hostname = 'graphite.demo.devopscasts.com'
    c.vm.network :private_network, ip: "192.168.33.10"
    c.vm.provision :shell, :inline => <<-SH
      export ROLE=graphite

      /vagrant/prep_apt.sh
      /vagrant/install_graphite.sh
    SH
  end

  config.vm.define 'app' do |c|
    c.vm.hostname = 'app.demo.devopscasts.com'
    c.vm.network :private_network, ip: "192.168.33.20"
    c.vm.provision :shell, :inline => <<-SH
      export ROLE=app
      export GRAPHITE_HOST=192.168.33.10

      /vagrant/prep_apt.sh
      /vagrant/install_app.sh
    SH
  end

  # Intended for use with digital ocean or similar provider.
  #
  # See https://github.com/smdahlen/vagrant-digitalocean for setup instructions then place
  # your `config.vm.provider :digital_ocean` section in `~/.vagrant.d/Vagrantfile` similar to this:
  #
  #     config.vm.provider :digital_ocean do |provider, override|
  #       override.ssh.private_key_path = '~/.ssh/id_rsa'
  #       override.vm.box = 'digital_ocean'
  #       override.vm.box_url = 'https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box'
  #       provider.client_id = '...'
  #       provider.api_key = '...'
  #       provider.image = 'Ubuntu 12.04 x64'
  #       provider.region = 'San Francisco 1'
  #       provider.size = '1GB'
  #       provider.ssh_key_name = '...'
  #     end
  #
  # Please use a 1GB droplet as tomcat will likely crash on a 512MB droplet.
  #
  # Once that's set up use `vagrant up demo-complete --provider=digital_ocean` to provision a single all-in-one box

  # config.vm.define 'demo-complete' do |c|
  #   c.vm.hostname = 'complete.demo.devopscasts.com'
  #   c.vm.provision :shell, :inline => <<-SH
  #     export ROLE=complete
  #     export GRAPHITE_HOST=localhost

  #     sed -i.bak 's/complete/complete complete.demo.devopscasts.com/' /etc/hosts

  #     /vagrant/prep_apt.sh
  #     /vagrant/install_graphite.sh
  #     /vagrant/install_app.sh
  #   SH
  # end
end
