# Automated import for Cisco Meraki

> fileshipper module required

This will call the Meraki Dashboard API and query all networks from the organisation for Meraki devices.
Query results are writen into a json file for each network so the Icinga Director can import them.

The json file will store a lot of values. From the name over the serial number to the geolocation.

*Meraki data fields*
- name
- address
- lanip
- lat
- lng
- mac
- model
- networkid
- serial

*Data that i use in my import/sync rules*
- name
- lat & lng = geolocation
- model
- serial
- lanip


Returns the script any error, the script can send an email to the icinga admin with the error code.



The python script can be trigged with a cron job.


## SQL Script to add ImportSource and Sync Rule
The SQL file will show how to add import sources and sync rules for the icinga director to import the devices from the json file with sql so when you have a lot of networks in the Meraki environment you don´t have to create this in the gui.

# WARNING - THE SQL FILE IS WITHOUT WARRANTY - BE CARFUL WHEN YOU EDIT DATABASES

This is the host object that the import/sync rules from the sql file will create:

        1	object Host "<name>" { 
 	 	2	   import "network-host" 
 	 	3	 
 	 	4	   display_name = "<name>" 
 	 	5	   address = "<lanip>" 
 	 	6	   notes_url = "https://n213.meraki.com" 
 	 	7	   vars.geolocation = "<geolocation>" 
 	 	8	   vars.manufacturer = "Cisco Meraki" 
 	 	9	   vars.model = "<model>" 
 	 	10	   vars.serial = "<serial>" 
 	 	11	} 

### Create geolocation
The import source from the sql file will generate the custom var "geolocation" from the import data lat and lng in the modification tab. The json file stores only the lat and lng data.

### Implemented custom variables
This are the var´s that are implemented in the sync rule from the sql file.
- geolocation
- manufacturer
- model
- serial

