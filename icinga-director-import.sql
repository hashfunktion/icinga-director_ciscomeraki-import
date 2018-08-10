/*
MYSQL Script to Add and Delete Import Source in Icinga Director to import CISCO MERAKI Devices from JSON file.

WARNING! Without warranty!

Take care by edit the sql database!
*/

use director;
select * from import_source;
INSERT INTO `director`.`import_source` (`id`, `source_name`, `key_column`, `provider_class`, `import_state`, `last_attempt`) VALUES ('10', 'JSON-Meraki_<NETWORKNAME>', 'name', 'Icinga\\Module\\Fileshipper\\ProvidedHook\\Director\\ImportSource', 'in-sync', '2018-08-02 15:02:10');

select * from import_source_setting;
INSERT INTO `director`.`import_source_setting` (`source_id`, `setting_name`, `setting_value`) VALUES ('10', 'basedir', '<FILEPATH>');
INSERT INTO `director`.`import_source_setting` (`source_id`, `setting_name`, `setting_value`) VALUES ('10', 'file_format', 'json');
INSERT INTO `director`.`import_source_setting` (`source_id`, `setting_name`, `setting_value`) VALUES ('10', 'file_name', 'MerakiEXPORT-<NETWORKNAME>.json');

select * from import_row_modifier;
INSERT INTO `director`.`import_row_modifier` (`id`, `source_id`, `property_name`, `target_property`, `provider_class`, `priority`) VALUES ('21', '10', 'lng', 'lng', 'Icinga\\Module\\Director\\PropertyModifier\\PropertyModifierReplace', '2');
INSERT INTO `director`.`import_row_modifier` (`id`, `source_id`, `property_name`, `target_property`, `provider_class`, `priority`) VALUES ('22', '10', 'lat', 'lat', 'Icinga\\Module\\Director\\PropertyModifier\\PropertyModifierReplace', '1');
INSERT INTO `director`.`import_row_modifier` (`id`, `source_id`, `property_name`, `target_property`, `provider_class`, `priority`) VALUES ('23', '10', 'lng', 'geolocation', 'Icinga\\Module\\Director\\PropertyModifier\\PropertyModifierCombine', '3');

select * from import_row_modifier_setting;
INSERT INTO `director`.`import_row_modifier_setting` (`row_modifier_id`, `setting_name`, `setting_value`) VALUES ('21', 'replacement', '.');
INSERT INTO `director`.`import_row_modifier_setting` (`row_modifier_id`, `setting_name`, `setting_value`) VALUES ('21', 'string', ',');
INSERT INTO `director`.`import_row_modifier_setting` (`row_modifier_id`, `setting_name`, `setting_value`) VALUES ('22', 'replacement', '.');
INSERT INTO `director`.`import_row_modifier_setting` (`row_modifier_id`, `setting_name`, `setting_value`) VALUES ('22', 'string', ',');
INSERT INTO `director`.`import_row_modifier_setting` (`row_modifier_id`, `setting_name`, `setting_value`) VALUES ('23', 'pattern', '${lat},${lng}');

select * from sync_property;
INSERT INTO `director`.`sync_property` (`id`, `rule_id`, `source_id`, `source_expression`, `destination_field`, `priority`, `merge_policy`) VALUES ('91', '9', '10', '<HOSTTEMPLATE>', 'import', '41', 'override');
INSERT INTO `director`.`sync_property` (`id`, `rule_id`, `source_id`, `source_expression`, `destination_field`, `priority`, `merge_policy`) VALUES ('92', '9', '10', '${lanIp}', 'address', '42', 'override');
INSERT INTO `director`.`sync_property` (`id`, `rule_id`, `source_id`, `source_expression`, `destination_field`, `priority`, `merge_policy`) VALUES ('93', '9', '10', '${name}', 'display_name', '43', 'override');
INSERT INTO `director`.`sync_property` (`id`, `rule_id`, `source_id`, `source_expression`, `destination_field`, `priority`, `merge_policy`) VALUES ('94', '9', '10', '${name}', 'object_name', '44', 'override');
INSERT INTO `director`.`sync_property` (`id`, `rule_id`, `source_id`, `source_expression`, `destination_field`, `priority`, `merge_policy`) VALUES ('95', '9', '10', 'https://n213.meraki.com', 'notes_url', '45', 'override');
INSERT INTO `director`.`sync_property` (`id`, `rule_id`, `source_id`, `source_expression`, `destination_field`, `priority`, `merge_policy`) VALUES ('96', '9', '10', '${tags}', 'notes', '46', 'override');
INSERT INTO `director`.`sync_property` (`id`, `rule_id`, `source_id`, `source_expression`, `destination_field`, `priority`, `merge_policy`) VALUES ('97', '9', '10', '${geolocation}', 'vars.geolocation', '47', 'override');
INSERT INTO `director`.`sync_property` (`id`, `rule_id`, `source_id`, `source_expression`, `destination_field`, `priority`, `merge_policy`) VALUES ('98', '9', '10', '${model}', 'vars.model', '48', 'override');
INSERT INTO `director`.`sync_property` (`id`, `rule_id`, `source_id`, `source_expression`, `destination_field`, `priority`, `merge_policy`) VALUES ('99', '9', '10', 'Cisco Meraki', 'vars.manufacturer', '49', 'override');
INSERT INTO `director`.`sync_property` (`id`, `rule_id`, `source_id`, `source_expression`, `destination_field`, `priority`, `merge_policy`) VALUES ('100', '9', '10', '${serial}', 'vars.serial', '50', 'override');

