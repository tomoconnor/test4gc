

package "rubygems" do
	action :install
end

package "python-software-properties" do
	action :install
end

execute "add-passenger-ppa" do
	command "apt-add-repository -y ppa:brightbox/passenger"
	action :run
end

execute "agu" do
	command "apt-get update"
	action :run
end

package "libapache2-mod-passenger" do
	action :install
end

package "git" do
	action :install
end

execute "clone-down-app" do
	command "git clone https://github.com/tomoconnor/app4gc.git"
	action :run
end

package "apache2-mpm-worker" do
	action :install
end
package "mysql-server" do
	action :install
end
package "mysql-client" do
	action :install
end



service "apache2" do
	service_name "apache2"
	restart_command "service apache2 restart"
	reload_command "service apache2 reload"
	action :enable
end

file "/etc/apache2/sites-enabled/app" do
	path "/home/tom/test4gc/puppet/files/app.conf"
	owner "root"
	group "root"
	mode "644"
	action :create
end
#How the *hell* do you symlink in chef?

file "/etc/apache2/sites-enabled/000-default" do
	action :delete
end

