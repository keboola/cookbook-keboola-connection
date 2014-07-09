Keboola Storage API Console Syrup Cookbook
==============

This cookbook installs Syrup with all it's dependencies.
Cloudformation template is also provided with cookbook and performs these actions:
 * Creates EC2 instance in VPC and provision it with Syrup using this cookbook. Node name is same as stack name
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
