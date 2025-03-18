---
title:
source: "https://learn.microsoft.com/en-us/cli/azure/sql/vm?view=azure-cli-latest#az_sql_vm_create"
author:
published:
created: 2025-03-05
description:
tags:
  - "clippings"
---
[Skip to main content](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#main)[Skip to in-page navigation](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#side-doc-outline)

This browser is no longer supported.

Upgrade to Microsoft Edge to take advantage of the latest features, security updates, and technical support.[Learn](https://learn.microsoft.com/en-us/)

- - [Documentation](https://learn.microsoft.com/en-us/docs/)

In-depth articles on Microsoft developer tools and technologies
- [Training](https://learn.microsoft.com/en-us/training/)

Personalized learning paths and courses
- [Credentials](https://learn.microsoft.com/en-us/credentials/)

Globally recognized, industry-endorsed credentials
- [Q&A](https://learn.microsoft.com/en-us/answers/)

Technical questions and answers moderated by Microsoft
- [Code Samples](https://learn.microsoft.com/en-us/samples/)

Code sample library for Microsoft developer tools and technologies
- [Assessments](https://learn.microsoft.com/en-us/assessments/)

Interactive, curated guidance and recommendations
- [Shows](https://learn.microsoft.com/en-us/shows/)

Thousands of hours of original programming from Microsoft experts

Microsoft Learn for Organizations

[Boost your team's technical skills](https://learn.microsoft.com/en-us/training/organizations/)

Access curated resources to upskill your team and close skills gaps.

[Sign in](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#)

## az sql vm

- Reference

## In this article

1. [Commands](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#commands)
2. [az sql vm add-to-group](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#az-sql-vm-add-to-group)
3. [az sql vm create](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#az-sql-vm-create)
4. [az sql vm delete](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#az-sql-vm-delete)
5. [az sql vm enable-azure-ad-auth](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#az-sql-vm-enable-azure-ad-auth)
6. [az sql vm list](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#az-sql-vm-list)
7. [az sql vm remove-from-group](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#az-sql-vm-remove-from-group)
8. [az sql vm show](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#az-sql-vm-show)
9. [az sql vm start-assessment](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#az-sql-vm-start-assessment)
10. [az sql vm update](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#az-sql-vm-update)
11. [az sql vm validate-azure-ad-auth](https://learn.microsoft.com/en-us/cli/azure/sql/?view=azure-cli-latest#az-sql-vm-validate-azure-ad-auth)

Manage SQL virtual machines.## Commands## az sql vm add-to-group

Adds SQL virtual machine to a SQL virtual machine group.

```azurecli
az sql vm add-to-group --sqlvm-group
                       [--bootstrap-acc-pwd]
                       [--ids]
                       [--name]
                       [--operator-acc-pwd]
                       [--resource-group]
                       [--service-acc-pwd]
                       [--subscription]
```### Examples

Add SQL virtual machine to a group.

```azurecli
az sql vm add-to-group -n sqlvm -g myresourcegroup --sqlvm-group sqlvmgroup --bootstrap-acc-pwd {bootstrappassword} --operator-acc-pwd {operatorpassword} --service-acc-pwd {servicepassword}
```### Required Parameters

Name or resource ID of the SQL virtual machine group. If only name provided, SQL virtual machine group should be in the same resource group of the SQL virtual machine.### Optional Parameters

Password for the cluster bootstrap account if provided in the SQL virtual machine group.

One or more resource IDs (space-delimited). It should be a complete resource ID containing all information of 'Resource Id' arguments. You should provide either --ids or other 'Resource Id' arguments.

Name of the SQL virtual machine.

Password for the cluster operator account provided in the SQL virtual machine group.

Name of resource group. You can configure the default group using `az configure --defaults group=<name>`.

Password for the SQL service account provided in the SQL virtual machine group.

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Global Parameters

Increase logging verbosity to show all debug logs.

Show this help message and exit.

Only show errors, suppressing warnings.

Output format.

Accepted values: json, jsonc, none, table, tsv, yaml, yamlc

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Increase logging verbosity. Use --debug for full debug logs.## az sql vm create

Creates a SQL virtual machine.

```azurecli
az sql vm create --name
                 --resource-group
                 [--backup-pwd]
                 [--backup-schedule-type {Automated, Manual}]
                 [--backup-system-dbs {false, true}]
                 [--connectivity-type {LOCAL, PRIVATE, PUBLIC}]
                 [--credential-name]
                 [--day-of-week {Everyday, Friday, Monday, Saturday, Sunday, Thursday, Tuesday, Wednesday}]
                 [--enable-auto-backup {false, true}]
                 [--enable-auto-patching {false, true}]
                 [--enable-encryption {false, true}]
                 [--enable-key-vault-credential {false, true}]
                 [--enable-r-services {false, true}]
                 [--full-backup-duration]
                 [--full-backup-frequency {Daily, Weekly}]
                 [--full-backup-start-hour]
                 [--image-offer]
                 [--image-sku {Developer, Enterprise, Express, Standard, Web}]
                 [--key-vault]
                 [--least-privilege-mode {Enabled, NotSet}]
                 [--license-type {AHUB, DR, PAYG}]
                 [--location]
                 [--log-backup-frequency]
                 [--maintenance-window-duration]
                 [--maintenance-window-start-hour]
                 [--port]
                 [--retention-period]
                 [--sa-key]
                 [--sp-name]
                 [--sp-secret]
                 [--sql-auth-update-pwd]
                 [--sql-auth-update-username]
                 [--sql-mgmt-type {Full, LightWeight, NoAgent}]
                 [--sql-workload-type {DW, GENERAL, OLTP}]
                 [--storage-account]
                 [--tags]
```### Examples

Create a SQL virtual machine with AHUB billing tag.

```azurecli
az sql vm create -n sqlvm -g myresourcegroup -l eastus --license-type AHUB
```

Create a SQL virtual machine with DR billing tag.

```azurecli
az sql vm create -n sqlvm -g myresourcegroup -l eastus --license-type DR
```

Create a SQL virtual machine with specific sku type and license type.

```azurecli
az sql vm create -n sqlvm -g myresourcegroup -l eastus --image-sku Enterprise --license-type AHUB
```

Create a SQL virtual machine with least privilege mode enabled.

```azurecli
az sql vm create -n sqlvm -g myresourcegroup -l eastus --least-privilege-mode Enabled --sql-mgmt-type Full
```

Create a SQL virtual machine with NoAgent type, only valid for EOS SQL 2008 and SQL 2008 R2.

```azurecli
az sql vm create -n sqlvm -g myresourcegroup -l eastus --license-type AHUB --sql-mgmt-type NoAgent --image-sku Enterprise --image-offer SQL2008-WS2008R2
```

Enable R services in SQL2016 onwards.

```azurecli
az sql vm create -n sqlvm -g myresourcegroup -l eastus --license-type PAYG --sql-mgmt-type Full --enable-r-services true
```

Create SQL virtual machine and configure auto backup settings.

```azurecli
az sql vm create -n sqlvm -g myresourcegroup -l eastus --license-type PAYG --sql-mgmt-type Full --backup-schedule-type manual --full-backup-frequency Weekly --full-backup-start-hour 2 --full-backup-duration 2 --sa-key {storageKey} --storage-account 'https://storageacc.blob.core.windows.net/' --retention-period 30 --log-backup-frequency 60
```

Create SQL virtual machine and configure auto patching settings.

```azurecli
az sql vm create -n sqlvm -g myresourcegroup -l eastus --license-type PAYG --sql-mgmt-type Full --day-of-week sunday --maintenance-window-duration 60 --maintenance-window-start-hour 2
```

Create SQL virtual machine and configure SQL connectivity settings.

```azurecli
az sql vm create -n sqlvm -g myresourcegroup -l eastus --license-type PAYG --sql-mgmt-type Full --connectivity-type private --port 1433 --sql-auth-update-username {newlogin} --sql-auth-update-pwd {sqlpassword}
```### Required Parameters

Name of the SQL virtual machine. The name of the new SQL virtual machine must be equal to the underlying virtual machine created from SQL marketplace image.

Name of resource group. You can configure the default group using `az configure --defaults group=<name>`.### Optional Parameters

Password for encryption on backup.

Backup schedule type.

Accepted values: Automated, Manual

Include system databases on backup.

Accepted values: false, true

SQL Server connectivity option.

Accepted values: LOCAL, PRIVATE, PUBLIC

Day of week to apply the patch on.

Accepted values: Everyday, Friday, Monday, Saturday, Sunday, Thursday, Tuesday, Wednesday

Enable or disable autobackup on SQL virtual machine. If any backup settings provided, parameter automatically sets to true.

Accepted values: false, true

Enable or disable autopatching on SQL virtual machine. If any autopatching settings provided, parameter automatically sets to true.

Accepted values: false, true

Enable encryption for backup on SQL virtual machine.

Accepted values: false, true

\--enable-key-vault-credential

Enable or disable key vault credential setting. If any key vault settings provided, parameter automatically sets to true.

Accepted values: false, true

Enable or disable R services (SQL 2016 onwards).

Accepted values: false, true

Duration of the time window of a given day during which full backups can take place. 1-23 hours.

Frequency of full backups. In both cases, full backups begin during the next scheduled time window.

Accepted values: Daily, Weekly

Start time of a given day during which full backups can take place. 0-23 hours.

SQL image offer. Examples include SQL2008R2-WS2008, SQL2008-WS2008.

SQL image sku.

Accepted values: Developer, Enterprise, Express, Standard, Web

SQL IaaS Agent Least Privilege Mode. Updates from sysadmin to specific permissions used per feature.

Accepted values: Enabled, NotSet

SQL Server license type.

Accepted values: AHUB, DR, PAYG

Location. If not provided, virtual machine should be in the same region of resource group.You can configure the default location using `az configure --defaults location=<location>`.

Frequency of log backups. 5-60 minutes.

\--maintenance-window-duration

Duration of patching. 30-180 minutes.

\--maintenance-window-start-hour

Hour of the day when patching is initiated. Local VM time 0-23 hours.

Retention period of backup. 1-30 days.

Storage account key where backup will be taken to.

Service principal name to access key vault.

Service principal name secret to access key vault.

SQL Server sysadmin login password.

\--sql-auth-update-username

SQL Server sysadmin login to create.

Argument 'sql\_management\_mode' has been deprecated and will be removed in a future release.

SQL Server management type. If NoAgent selected, please provide --image-sku and --offer-type.

Accepted values: Full, LightWeight, NoAgent

Default value: LightWeight

SQL Server workload type.

Accepted values: DW, GENERAL, OLTP

Storage account url where backup will be taken to.

Space-separated tags: key\[=value\] \[key\[=value\] ...\]. Use "" to clear existing tags.

Global Parameters

Increase logging verbosity to show all debug logs.

Show this help message and exit.

Only show errors, suppressing warnings.

Output format.

Accepted values: json, jsonc, none, table, tsv, yaml, yamlc

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Increase logging verbosity. Use --debug for full debug logs.## az sql vm delete

Deletes a SQL virtual machine.

```azurecli
az sql vm delete [--ids]
                 [--name]
                 [--resource-group]
                 [--subscription]
                 [--yes]
```### Optional Parameters

One or more resource IDs (space-delimited). It should be a complete resource ID containing all information of 'Resource Id' arguments. You should provide either --ids or other 'Resource Id' arguments.

Name of the SQL virtual machine.

Name of resource group. You can configure the default group using `az configure --defaults group=<name>`.

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Do not prompt for confirmation.

Global Parameters

Increase logging verbosity to show all debug logs.

Show this help message and exit.

Only show errors, suppressing warnings.

Output format.

Accepted values: json, jsonc, none, table, tsv, yaml, yamlc

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Increase logging verbosity. Use --debug for full debug logs.

Enable Azure AD authentication of a SQL virtual machine.

```azurecli
az sql vm enable-azure-ad-auth [--ids]
                               [--msi-client-id]
                               [--name]
                               [--resource-group]
                               [--skip-client-validation]
                               [--subscription]
```### Examples

Enable Azure AD authentication with system-assigned managed identity with client side validation.

```azurecli
az sql vm enable-azure-ad-auth -n sqlvm -g myresourcegroup
```

Enable Azure AD authentication with user-assigned managed identity with client side validation.

```azurecli
az sql vm enable-azure-ad-auth -n sqlvm -g myresourcegroup --msi-client-id 12345678
```

Enable Azure AD authentication with system-assigned managed identity skipping client side validation. The server side validation always happens.

```azurecli
az sql vm enable-azure-ad-auth -n sqlvm -g myresourcegroup --skip-client-validation
```

Enable Azure AD authentication with user-assigned managed identity skipping client side validation. The server side validation always happens.

```azurecli
az sql vm enable-azure-ad-auth -n sqlvm -g myresourcegroup --msi-client-id 12345678 --skip-client-validation
```### Optional Parameters

One or more resource IDs (space-delimited). It should be a complete resource ID containing all information of 'Resource Id' arguments. You should provide either --ids or other 'Resource Id' arguments.

Virutal Machine Managed Identity Client ID.

Name of the SQL virtual machine.

Name of resource group. You can configure the default group using `az configure --defaults group=<name>`.

Skip client side Azure AD authentication validation, the server side validation will still happen.

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Global Parameters

Increase logging verbosity to show all debug logs.

Show this help message and exit.

Only show errors, suppressing warnings.

Output format.

Accepted values: json, jsonc, none, table, tsv, yaml, yamlc

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Increase logging verbosity. Use --debug for full debug logs.## az sql vm list

Lists all SQL virtual machines in a resource group or subscription.

```azurecli
az sql vm list [--resource-group]
```### Optional Parameters

Name of resource group. You can configure the default group using `az configure --defaults group=<name>`.

Global Parameters

Increase logging verbosity to show all debug logs.

Show this help message and exit.

Only show errors, suppressing warnings.

Output format.

Accepted values: json, jsonc, none, table, tsv, yaml, yamlc

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Increase logging verbosity. Use --debug for full debug logs.## az sql vm remove-from-group

Remove SQL virtual machine from its current SQL virtual machine group.

```azurecli
az sql vm remove-from-group [--ids]
                            [--name]
                            [--resource-group]
                            [--subscription]
```### Examples

Remove SQL virtual machine from a group.

```azurecli
az sql vm remove-from-group -n sqlvm -g myresourcegroup
```### Optional Parameters

One or more resource IDs (space-delimited). It should be a complete resource ID containing all information of 'Resource Id' arguments. You should provide either --ids or other 'Resource Id' arguments.

Name of the SQL virtual machine.

Name of resource group. You can configure the default group using `az configure --defaults group=<name>`.

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Global Parameters

Increase logging verbosity to show all debug logs.

Show this help message and exit.

Only show errors, suppressing warnings.

Output format.

Accepted values: json, jsonc, none, table, tsv, yaml, yamlc

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Increase logging verbosity. Use --debug for full debug logs.## az sql vm show

Gets a SQL virtual machine.

```azurecli
az sql vm show [--expand {*, AssessmentSettings, AutoBackupSettings, AutoPatchingSettings, KeyVaultCredentialSettings, ServerConfigurationsManagementSettings}]
               [--ids]
               [--name]
               [--resource-group]
               [--subscription]
```### Optional Parameters

Get the SQLIaaSExtension configuration settings. To view all settings, use \*. To select only a few, the settings must be space-separated.

Accepted values: \*, AssessmentSettings, AutoBackupSettings, AutoPatchingSettings, KeyVaultCredentialSettings, ServerConfigurationsManagementSettings

One or more resource IDs (space-delimited). It should be a complete resource ID containing all information of 'Resource Id' arguments. You should provide either --ids or other 'Resource Id' arguments.

Name of the SQL virtual machine.

Name of resource group. You can configure the default group using `az configure --defaults group=<name>`.

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Global Parameters

Increase logging verbosity to show all debug logs.

Show this help message and exit.

Only show errors, suppressing warnings.

Output format.

Accepted values: json, jsonc, none, table, tsv, yaml, yamlc

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Increase logging verbosity. Use --debug for full debug logs.## az sql vm start-assessment

Starts SQL best practice assessment on SQL virtual machine.

```azurecli
az sql vm start-assessment [--ids]
                           [--name]
                           [--resource-group]
                           [--subscription]
```### Examples

Starts SQL best practice assessment.

```azurecli
az sql vm start-assessment -n sqlvm -g myresourcegroup
```### Optional Parameters

One or more resource IDs (space-delimited). It should be a complete resource ID containing all information of 'Resource Id' arguments. You should provide either --ids or other 'Resource Id' arguments.

Name of the SQL virtual machine.

Name of resource group. You can configure the default group using `az configure --defaults group=<name>`.

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Global Parameters

Increase logging verbosity to show all debug logs.

Show this help message and exit.

Only show errors, suppressing warnings.

Output format.

Accepted values: json, jsonc, none, table, tsv, yaml, yamlc

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Increase logging verbosity. Use --debug for full debug logs.## az sql vm update

Updates the properties of a SQL virtual machine.

```azurecli
az sql vm update [--add]
                 [--agent-rg]
                 [--am-day {Friday, Monday, Saturday, Sunday, Thursday, Tuesday, Wednesday}]
                 [--am-month-occ {-1, 1, 2, 3, 4}]
                 [--am-schedule {false, true}]
                 [--am-time]
                 [--am-week-int {1, 2, 3, 4, 5, 6}]
                 [--backup-pwd]
                 [--backup-schedule-type {Automated, Manual}]
                 [--backup-system-dbs {false, true}]
                 [--connectivity-type {LOCAL, PRIVATE, PUBLIC}]
                 [--credential-name]
                 [--day-of-week {Everyday, Friday, Monday, Saturday, Sunday, Thursday, Tuesday, Wednesday}]
                 [--enable-assessment {false, true}]
                 [--enable-auto-backup {false, true}]
                 [--enable-auto-patching {false, true}]
                 [--enable-encryption {false, true}]
                 [--enable-key-vault-credential {false, true}]
                 [--enable-r-services {false, true}]
                 [--force-string]
                 [--full-backup-duration]
                 [--full-backup-frequency {Daily, Weekly}]
                 [--full-backup-start-hour]
                 [--ids]
                 [--image-sku {Developer, Enterprise, Express, Standard, Web}]
                 [--key-vault]
                 [--least-privilege-mode {Enabled, NotSet}]
                 [--license-type {AHUB, DR, PAYG}]
                 [--log-backup-frequency]
                 [--maintenance-window-duration]
                 [--maintenance-window-start-hour]
                 [--name]
                 [--port]
                 [--remove]
                 [--resource-group]
                 [--retention-period]
                 [--sa-key]
                 [--set]
                 [--sp-name]
                 [--sp-secret]
                 [--sql-mgmt-type {Full, LightWeight, NoAgent}]
                 [--sql-workload-type {DW, GENERAL, OLTP}]
                 [--storage-account]
                 [--subscription]
                 [--tags]
                 [--workspace-name]
                 [--workspace-rg]
                 [--workspace-sub]
                 [--yes]
```### Examples

Add or update a tag.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --set tags.tagName=tagValue
```

Remove a tag.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --remove tags.tagName
```

Update a SQL virtual machine with specific sku type.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --image-sku Enterprise
```

Update a SQL virtual machine manageability from LightWeight to Full.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --sql-mgmt-type Full
```

Update a SQL virtual machine to least privilege mode.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --least-privilege-mode Enabled --sql-mgmt-type Full
```

Update SQL virtual machine auto backup settings.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --backup-schedule-type manual --full-backup-frequency Weekly --full-backup-start-hour 2 --full-backup-duration 2 --sa-key {storageKey} --storage-account 'https://storageacc.blob.core.windows.net/' --retention-period 30 --log-backup-frequency 60
```

Disable SQL virtual machine auto backup settings.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --enable-auto-backup false
```

Update SQL virtual machine auto patching settings.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --day-of-week sunday --maintenance-window-duration 60 --maintenance-window-start-hour 2
```

Disable SQL virtual machine auto patching settings.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --enable-auto-patching false
```

Update a SQL virtual machine billing tag to AHUB.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --license-type AHUB
```

Update a SQL virtual machine billing tag to DR.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --license-type DR
```

Update a SQL virtual machine to disable SQL best practice assessment.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --enable-assessment false
```

Update a SQL virtual machine to disable schedule for SQL best practice assessment.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --enable-assessment-schedule false
```

Update a SQL virtual machine to enable schedule with weekly interval for SQL best practice assessment when VM is already associated with a Log Analytics workspace.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --assessment-weekly-interval 1 --assessment-day-of-week monday --assessment-start-time-local '19:30'
```

Update a SQL virtual machine to enable schedule with monthly occurrence for SQL best practice assessment while associating with a Log Analytics workspace and assigning a Resource group for the Agent resources.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --workspace-name myLogAnalyticsWorkspace --workspace-rg myRg --agent-rg myRg2 --assessment-monthly-occurrence 1 --assessment-day-of-week monday --assessment-start-time-local '19:30'
```

Update a SQL virtual machine to enable SQL best practices assessment without setting a schedule for running assessment on-demand. Must provide Log Analytics workspace and a Resource group for deploying the Agent resources.

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --enable-assessment true --workspace-name myLogAnalyticsWorkspace --workspace-rg myRg --agent-rg myRg2
```

Update a SQL virtual machine to enable SQL best practices assessment while associating with a Log Analytics Workspace in a different subscription

```azurecli
az sql vm update -n sqlvm -g myresourcegroup --enable-assessment true --workspace-name myLogAnalyticsWorkspace --workspace-rg myRg --workspace-sub myLogAnalyticsWorkspaceSubName --agent-rg myRg2
```### Optional Parameters

Add an object to a list of objects by specifying a path and key value pairs. Example: `--add property.listProperty <key=value, string or JSON string>`.

Resource group containing the AMA resources DCE and DCR.

\--am-day --assessment-day-of-week

Day of the week to run assessment.

Accepted values: Friday, Monday, Saturday, Sunday, Thursday, Tuesday, Wednesday

\--am-month-occ --assessment-monthly-occurrence

Occurrence of the DayOfWeek day within a month to schedule assessment. Supports values 1,2,3,4 and -1. Use -1 for last DayOfWeek day of the month (for example - last Tuesday of the month).

Accepted values: -1, 1, 2, 3, 4

\--am-schedule --enable-assessment-schedule

Enable or disable assessment Schedule. If any assessment schedule settings provided, parameter automatically sets to true.

Accepted values: false, true

\--am-time --assessment-start-time-local

Time of the day in HH:mm format. Examples include 17:30, 05:13.

\--am-week-int --assessment-weekly-interval

Number of weeks to schedule between 2 assessment runs. Supports value from 1-6.

Accepted values: 1, 2, 3, 4, 5, 6

Password for encryption on backup.

Backup schedule type.

Accepted values: Automated, Manual

Include system databases on backup.

Accepted values: false, true

SQL Server connectivity option.

Accepted values: LOCAL, PRIVATE, PUBLIC

Day of week to apply the patch on.

Accepted values: Everyday, Friday, Monday, Saturday, Sunday, Thursday, Tuesday, Wednesday

Enable or disable assessment feature. If any assessment settings provided, parameter automatically sets to true.

Accepted values: false, true

Enable or disable autobackup on SQL virtual machine. If any backup settings provided, parameter automatically sets to true.

Accepted values: false, true

Enable or disable autopatching on SQL virtual machine. If any autopatching settings provided, parameter automatically sets to true.

Accepted values: false, true

Enable encryption for backup on SQL virtual machine.

Accepted values: false, true

\--enable-key-vault-credential

Enable or disable key vault credential setting. If any key vault settings provided, parameter automatically sets to true.

Accepted values: false, true

Enable or disable R services (SQL 2016 onwards).

Accepted values: false, true

When using 'set' or 'add', preserve string literals instead of attempting to convert to JSON.

Duration of the time window of a given day during which full backups can take place. 1-23 hours.

Frequency of full backups. In both cases, full backups begin during the next scheduled time window.

Accepted values: Daily, Weekly

Start time of a given day during which full backups can take place. 0-23 hours.

One or more resource IDs (space-delimited). It should be a complete resource ID containing all information of 'Resource Id' arguments. You should provide either --ids or other 'Resource Id' arguments.

SQL image sku.

Accepted values: Developer, Enterprise, Express, Standard, Web

SQL IaaS Agent Least Privilege Mode. Updates from sysadmin to specific permissions used per feature.

Accepted values: Enabled, NotSet

SQL Server license type.

Accepted values: AHUB, DR, PAYG

Frequency of log backups. 5-60 minutes.

\--maintenance-window-duration

Duration of patching. 30-180 minutes.

\--maintenance-window-start-hour

Hour of the day when patching is initiated. Local VM time 0-23 hours.

Name of the SQL virtual machine.

Remove a property or an element from a list. Example: `--remove property.list <indexToRemove>` OR `--remove propertyToRemove`.

Name of resource group. You can configure the default group using `az configure --defaults group=<name>`.

Retention period of backup. 1-30 days.

Storage account key where backup will be taken to.

Update an object by specifying a property path and value to set. Example: `--set property1.property2=<value>`.

Service principal name to access key vault.

Service principal name secret to access key vault.

Argument 'sql\_management\_mode' has been deprecated and will be removed in a future release.

SQL Server management type. Updates from LightWeight to Full.

Accepted values: Full, LightWeight, NoAgent

SQL Server workload type.

Accepted values: DW, GENERAL, OLTP

Storage account url where backup will be taken to.

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Space-separated tags: key\[=value\] \[key\[=value\] ...\]. Use "" to clear existing tags.

Name of the Log Analytics workspace to associate with VM.

Resource group containing the Log Analytics workspace.

Subscription containing the Log Analytics workspace.

Argument 'prompt' has been deprecated and will be removed in a future release.

Do not prompt for confirmation. Requires --sql-mgmt-type.

Global Parameters

Increase logging verbosity to show all debug logs.

Show this help message and exit.

Only show errors, suppressing warnings.

Output format.

Accepted values: json, jsonc, none, table, tsv, yaml, yamlc

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Increase logging verbosity. Use --debug for full debug logs.

Validate Azure AD authentication of a SQL virtual machine at the client side without enabling it.

```azurecli
az sql vm validate-azure-ad-auth [--ids]
                                 [--msi-client-id]
                                 [--name]
                                 [--resource-group]
                                 [--subscription]
```### Examples

Validate Azure AD authentication with system-assigned managed identity at the client side.

```azurecli
az sql vm validate-azure-ad-auth -n sqlvm -g myresourcegroup
```

Validate Azure AD authentication with user-assigned managed identity at the client side.

```azurecli
az sql vm validate-azure-ad-auth -n sqlvm -g myresourcegroup --msi-client-id 12345678
```### Optional Parameters

One or more resource IDs (space-delimited). It should be a complete resource ID containing all information of 'Resource Id' arguments. You should provide either --ids or other 'Resource Id' arguments.

Virutal Machine Managed Identity Client ID.

Name of the SQL virtual machine.

Name of resource group. You can configure the default group using `az configure --defaults group=<name>`.

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Global Parameters

Increase logging verbosity to show all debug logs.

Show this help message and exit.

Only show errors, suppressing warnings.

Output format.

Accepted values: json, jsonc, none, table, tsv, yaml, yamlc

Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.

Increase logging verbosity. Use --debug for full debug logs.

Collaborate with us on GitHub

The source for this content can be found on GitHub, where you can also create and review issues and pull requests. For more information, see [our contributor guide](https://learn.microsoft.com/contribute/content/how-to-write-overview).