#
# Cookbook Name:: cryptopro
# Recipe:: default
#
# Copyright 2013, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

execute "apt-get" do
  command "apt-get update"
end

dependencies = %w{unzip libxtst6 libxi6}

dependencies.each do |pkg|
  apt_package pkg do
    action :install
  end
end


bash "download_cryptopro" do
user "root"
cwd node[:cryptopro][:tmp_dir]
code <<-EOH
wget -c #{node[:cryptopro][:url]} -O #{node[:cryptopro][:filename]}
mkdir #{node[:cryptopro][:install_dir]}
unzip -j #{node[:cryptopro][:filename]} -d #{node[:cryptopro][:install_dir]}
mkdir #{node[:cryptopro][:keys_dir]}
chown -R vagrant:vagrant #{node[:cryptopro][:install_dir]} #{node[:cryptopro][:keys_dir]} /usr/lib/jvm/default-java /usr/lib/jvm/jdk1.6.0_43/
EOH
end
bash "setup_cryptopro" do
user "vagrant"
cwd node[:cryptopro][:install_dir]
code <<-EOH
/bin/sh #{node[:cryptopro][:install_dir]}/install.sh /usr/lib/jvm/default-java #{node[:cryptopro][:serial_number]} #{node[:cryptopro][:org_name]}
EOH
end
