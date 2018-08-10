# Automated import for Cisco Meraki

This will call the Meraki Dashboard API and query all networks from the organisation for Meraki devices.
Query results are writen into a json file for each network so the Icinga Director can import them.

> fileshipper module required

### SQL Script to add ImportSource and Sync Rule
The SQL file will show how to add import sources and sync rules for the icinga director to import the devices from the json file.
### Implemented custom variables
This are the var´s that are implemented in the sync rule from the sql file.
- geolocation
- manufacturer
- model
- serial
