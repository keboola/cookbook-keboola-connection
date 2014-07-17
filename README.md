Keboola Connection Cookbook
==============

This cookbook installs Keboola Connection with all it's dependencies.
[Cloudformation template](cloudformation-template.json) is also provided with cookbook and performs these actions:
 * Creates EC2 instance in VPC and provision it with Connection using this cookbook. Node name is same as stack name
 * Creates and associate DNS entry for instance `stack_name.keboola.com`

Running instance
----------------
Launch [Cloudformation template](cloudformation-template.json) in Cloudformation AWS console. After filling few required parameters instance will be up and running latest version of Keboola Connection server.


Troubleshooting
---------------
Each step of instance provisioning provides logs, these can be helplful when something goes wrong during instance provisioning.

 * `/var/log/cloud-init.log` - Cloud init script
 * `/var/log/cfn-init.log` - Cloudformation init script
 * `/var/init/bootstrap.log` - Downloading chef and required recipes using Berkshelf
 * `/var/init/storage.log` - Disks settings
 * `/var/init/chef_solo.log` - Chef provisioning

