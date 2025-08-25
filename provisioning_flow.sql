------------------------------ Clickhouse Click - Client Provisioning Example Flow ----------------------------------

--> Client Signs Up
---> Triggers service create API to create client service.
----> Create Tilla agent within new client segregated service.
CREATE USER 'tilla_agent_{client_name}' IDENTIFIED BY 'password';

----> Create new read only role for agent
CREATE ROLE tilla_agent_role;

----> Grant role to agent
GRANT tilla_agent_role TO tilla_agent_{client_name};

-- Set to readonly
ALTER USER tilla_agent_(client_name) SETTINGS readonly = 1;

----> The following occurs each time a new datasource is configured by the client. 
----> Client configures new datasource, create the raw database and use this in Airbyte.
----> The agent will not have access to this raw table.
CREATE DATABASE raw_{datasource_name}; -- e.g. raw_shopify

----> Create database for processed materialised data
CREATE DATABASE data_{datasource_name} -- e.g. data_shopify

---------- ** Silver Layer / Curated Layer Creation 
----> Create the materialised data views within this database 
----> ** See curated_datasets for the materialised view creation scripts per datasource **

----> Backdate the materialised view using the backdate scripts in the curated_datasets folder.

----> Grant permissions to the new materialised normalised data
----> Works on the bases of least access, agent will only be able to access what is given below.

GRANT SELECT ON data_shopify.* TO tilla_agent_role;
GRANT SELECT ON data_ga4.* TO tilla_agent_role;
GRANT SELECT ON data_klaviyo.* TO tilla_agent_role;
GRANT SELECT ON data_{datasource_name}.* TO tilla_agent_role;

---------- ** Gold Layer / Analytics Layer Creation 
----> Create the materialised analytics views within this database 
----> ** See analytics_datasets for the materialised view creation scripts per datasource **

----> Backdate the materialised view using the backdate scripts in the analytics_datasets folder.

----> Grant permissions to the new materialised normalised data
----> Works on the bases of least access, agent will only be able to access what is given below.

GRANT SELECT ON analytics_shopify.* TO tilla_agent_role;
GRANT SELECT ON analytics_ga4.* TO tilla_agent_role;
GRANT SELECT ON analytics_klaviyo.* TO tilla_agent_role;
GRANT SELECT ON analytics_{datasource_name}.* TO tilla_agent_role;

------ ***** RESTRICT AGENT TO CERTAIN COMPUTE USE??? ******* ---- 
