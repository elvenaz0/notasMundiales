


shred -v -n 3 -u archivo.txt


az account list --output table.json


![[Pasted image 20250317195144.png]]

```
Name                        CloudName    SubscriptionId                        TenantId                              State    IsDefault
--------------------------  -----------  ------------------------------------  ------------------------------------  -------  -----------
Ambiente Productivo FULTRA  AzureCloud   e9ea8657-0ff7-48ac-8859-1172319c2219  f03d1b0e-7bde-48a4-a386-abbbf42d9a52  Enabled  False
promare                     AzureCloud   3fcc7aad-45aa-45d9-be1c-c8def0a97251  f03d1b0e-7bde-48a4-a386-abbbf42d9a52  Enabled  False
fultra                      AzureCloud   e4917f1e-a809-4ce2-9a4f-e4980e98997f  f03d1b0e-7bde-48a4-a386-abbbf42d9a52  Enabled  False
sierranorte                 AzureCloud   346d8dc1-067a-4416-bc03-18f558623178  f03d1b0e-7bde-48a4-a386-abbbf42d9a52  Enabled  False
fruehaufmex                 AzureCloud   fb93d3fd-cdc0-40d9-9869-743a02b76a64  f03d1b0e-7bde-48a4-a386-abbbf42d9a52  Enabled  False
appsfultra                  AzureCloud   0d148ad9-b669-4940-83b6-f40d5b79713d  f03d1b0e-7bde-48a4-a386-abbbf42d9a52  Enabled  False
fruehaufinc                 AzureCloud   1a21f7a6-d308-439b-bffe-5af77dcaf15d  f03d1b0e-7bde-48a4-a386-abbbf42d9a52  Enabled  False
idealeasenoreste            AzureCloud   7f1e46f2-c8c4-40d1-b4c4-55a2f8de08d9  f03d1b0e-7bde-48a4-a386-abbbf42d9a52  Enabled  True
idealeasenoreste            AzureCloud   5759b57e-1642-48cf-912f-e06061dbe51e  f03d1b0e-7bde-48a4-a386-abbbf42d9a52  Enabled  False
```

e9ea8657-0ff7-48ac-8859-1172319c2219
3fcc7aad-45aa-45d9-be1c-c8def0a97251
e4917f1e-a809-4ce2-9a4f-e4980e98997f
346d8dc1-067a-4416-bc03-18f558623178
fb93d3fd-cdc0-40d9-9869-743a02b76a64
0d148ad9-b669-4940-83b6-f40d5b79713d
1a21f7a6-d308-439b-bffe-5af77dcaf15d
7f1e46f2-c8c4-40d1-b4c4-55a2f8de08d9
5759b57e-1642-48cf-912f-e06061dbe51e

az webapp list \
  --subscription <ID_O_NOMBRE_DE_LA_SUSCRIPCION> \
  --output json

az webapp list \
  --subscription "appsfultra" \
  --output json > appsfultra.json
