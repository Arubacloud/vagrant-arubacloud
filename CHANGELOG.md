<a name="0.0.7"></a>
## [0.0.7] (2018-03-07)

#### Bug Fixes

 * Fix missing **'ip address'** when row display VM with hypervisor 'pro'  (  *'vagrant arubacloud servers'* ) 

#### Documentation

 * changes in README.md 


<a name="0.0.6"></a>
## [0.0.6] (2018-03-06)

#### Documentation

 * correct License info 


<a name="0.0.5"></a>
## [0.0.5] (2018-03-06)

#### Features

 * added command **'snapshot'**  *create*, *delete*, *restore*, *list*  methods
 * changed command  **vagrant arubacloud servers**  :now output *'DC*, *'Id'* , *'status description'* .
 * parameter  **admin_password** ( in :arubacloud section) is removed and replaced by the directive **'nodename'.ssh.password** in vagrant config section.    
 * added command **reload**   as  *power off* ( it's a 'shutdown ' and not 'power-off' forced)  and *power on*    
 * after vagrant command *'up'* or *'reload'*, is executed a **synced_folder**
 * changed option **package_id** (in :arubacloud section) : valid values now are : *'small'*, *'medium'*, *'large'*, *'extra large'* ;
 * added new parameter  **endpoint**  (in :arubacloud section)  to define DataCenter Aruba can be used for the defined VM in Vagrantfile (
this parameter replaces *'nodename'.url* )
 * changed the use of **url** parameter  (in :arubacloud section) : should only be used when a new 'dc?' not yet included in this plugin ( override the *'nodename'.endpoint* value ).       
 * added **[dc.]** (name of DataCenter) in output for command : *'up'*, *'reload'* , *'halt'*, *'arubacloud servers/templates'*, *'destroy'*, *'snapshot'*.

