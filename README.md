Keboola Connection Cookbook
==============

This cookbook installs Keboola Connection with all it's dependencies.
Cloudformation template is also provided with cookbook and performs these actions:
 * Creates EC2 instance in VPC and provision it with Connection using this cookbook. Node name is same as stack name
 * Creates and associate DNS entry for instance `stack_name.keboola.com`


Usage
-----
#### keboola-storage-api-console::default

Just include `keboola-storage-api-console` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[keboola-storage-api-console]"
  ]
}
```

Running workers
_______________
Workers are not started on instance start. You can start them manually on instance:

```
sudo start connection.queue-receive QUEUE=main N=1
```