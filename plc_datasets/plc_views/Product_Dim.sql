-- View: Product_Dim
CREATE OR REPLACE VIEW Product_Dim AS
with products as (select distinct site,Product_Id from `CloudDWConsolidated.Product_Site_Price_Insert` ps where ps.Site in (46, 37) )
SELECT
ps.Site,
pd.*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Dim` pd
JOIN products ps
ON ps.Product_Id = pd.Product_Id
