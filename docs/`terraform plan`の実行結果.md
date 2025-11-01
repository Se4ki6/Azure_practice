PS C:\Users\sksrd\Programing\Azure> terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:

- create

Terraform will perform the following actions:

# azurerm_resource_group.main will be created

- resource "azurerm_resource_group" "main" {
  - id = (known after apply)
  - location = "japaneast"
  - name = "rg-storage-demo"
  - tags = { + "Environment" = "Demo" + "Purpose" = "StorageAccount"
    }
    }

# azurerm_storage_account.main will be created

- resource "azurerm_storage_account" "main" {

  - access_tier = (known after apply)
  - account_kind = "StorageV2"
  - account_replication_type = "LRS"
  - account_tier = "Standard"
  - allow_nested_items_to_be_public = true
  - cross_tenant_replication_enabled = false
  - default_to_oauth_authentication = false
  - dns_endpoint_type = "Standard"
  - https_traffic_only_enabled = true
  - id = (known after apply)
  - infrastructure_encryption_enabled = false
  - is_hns_enabled = false
  - large_file_share_enabled = (known after apply)
  - local_user_enabled = true
  - location = "japaneast"
  - min_tls_version = "TLS1_2"
  - name = "azuretrainingsekishirost"
  - nfsv3_enabled = false
  - primary_access_key = (sensitive value)
  - primary_blob_connection_string = (sensitive value)
  - primary_blob_endpoint = (known after apply)
  - primary_blob_host = (known after apply)
  - primary_blob_internet_endpoint = (known after apply)
  - primary_blob_internet_host = (known after apply)
  - primary_blob_microsoft_endpoint = (known after apply)
  - primary_blob_microsoft_host = (known after apply)
  - primary_connection_string = (sensitive value)
  - primary_dfs_endpoint = (known after apply)
  - primary_dfs_host = (known after apply)
  - primary_dfs_internet_endpoint = (known after apply)
  - primary_dfs_internet_host = (known after apply)
  - primary_dfs_microsoft_endpoint = (known after apply)
  - primary_dfs_microsoft_host = (known after apply)
  - primary_file_endpoint = (known after apply)
  - primary_file_host = (known after apply)
  - primary_file_internet_endpoint = (known after apply)
  - primary_file_internet_host = (known after apply)
  - primary_file_microsoft_endpoint = (known after apply)
  - primary_file_microsoft_host = (known after apply)
  - primary_location = (known after apply)
  - primary_queue_endpoint = (known after apply)
  - primary_queue_host = (known after apply)
  - primary_queue_microsoft_endpoint = (known after apply)
  - primary_queue_microsoft_host = (known after apply)
  - primary_table_endpoint = (known after apply)
  - primary_table_host = (known after apply)
  - primary_table_microsoft_endpoint = (known after apply)
  - primary_table_microsoft_host = (known after apply)
  - primary_web_endpoint = (known after apply)
  - primary_web_host = (known after apply)
  - primary_web_internet_endpoint = (known after apply)
  - primary_web_internet_host = (known after apply)
  - primary_web_microsoft_endpoint = (known after apply)
  - primary_web_microsoft_host = (known after apply)
  - public_network_access_enabled = true
  - queue_encryption_key_type = "Service"
  - resource_group_name = "rg-storage-demo"
  - secondary_access_key = (sensitive value)
  - secondary_blob_connection_string = (sensitive value)
  - secondary_blob_endpoint = (known after apply)
  - secondary_blob_host = (known after apply)
  - secondary_blob_internet_endpoint = (known after apply)
  - secondary_blob_internet_host = (known after apply)
  - secondary_blob_microsoft_endpoint = (known after apply)
  - secondary_blob_microsoft_host = (known after apply)
  - secondary_connection_string = (sensitive value)
  - secondary_dfs_endpoint = (known after apply)
  - secondary_dfs_host = (known after apply)
  - secondary_dfs_internet_endpoint = (known after apply)
  - secondary_dfs_internet_host = (known after apply)
  - secondary_dfs_microsoft_endpoint = (known after apply)
  - secondary_dfs_microsoft_host = (known after apply)
  - secondary_file_endpoint = (known after apply)
  - secondary_file_host = (known after apply)
  - secondary_file_internet_endpoint = (known after apply)
  - secondary_file_internet_host = (known after apply)
  - secondary_file_microsoft_endpoint = (known after apply)
  - secondary_file_microsoft_host = (known after apply)
  - secondary_location = (known after apply)
  - secondary_queue_endpoint = (known after apply)
  - secondary_queue_host = (known after apply)
  - secondary_queue_microsoft_endpoint = (known after apply)
  - secondary_queue_microsoft_host = (known after apply)
  - secondary_table_endpoint = (known after apply)
  - secondary_table_host = (known after apply)
  - secondary_table_microsoft_endpoint = (known after apply)
  - secondary_table_microsoft_host = (known after apply)
  - secondary_web_endpoint = (known after apply)
  - secondary_web_host = (known after apply)
  - secondary_web_internet_endpoint = (known after apply)
  - secondary_web_internet_host = (known after apply)
  - secondary_web_microsoft_endpoint = (known after apply)
  - secondary_web_microsoft_host = (known after apply)
  - sftp_enabled = false
  - shared_access_key_enabled = true
  - table_encryption_key_type = "Service"
  - tags = {

    - "environment" = "demo"
      }

  - blob_properties (known after apply)

  - network_rules (known after apply)

  - queue_properties (known after apply)

  - routing (known after apply)

  - share_properties (known after apply)

  - static_website (known after apply)
    }

# azurerm_storage_blob.main will be created

- resource "azurerm_storage_blob" "main" {
  - access_tier = (known after apply)
  - content_type = "application/octet-stream"
  - id = (known after apply)
  - metadata = (known after apply)
  - name = "uploaded-sample.txt"
  - parallelism = 8
  - size = 0
  - source = "./sample.txt"
  - storage_account_name = "azuretrainingsekishirost"
  - storage_container_name = "uploads"
  - type = "Block"
  - url = (known after apply)
    }

# azurerm_storage_container.main will be created

- resource "azurerm_storage_container" "main" {
  - container_access_type = "private"
  - default_encryption_scope = (known after apply)
  - encryption_scope_override_enabled = true
  - has_immutability_policy = (known after apply)
  - has_legal_hold = (known after apply)
  - id = (known after apply)
  - metadata = (known after apply)
  - name = "uploads"
  - resource_manager_id = (known after apply)
  - storage_account_name = "azuretrainingsekishirost"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:

- blob_url = (known after apply)
- container_name = "uploads"
- resource_group_name = "rg-storage-demo"
- storage_account_connection_string = (sensitive value)
- storage_account_name = "azuretrainingsekishirost"
- storage_account_primary_key = (sensitive value)
  ╷
  │ Warning: Argument is deprecated
  │
  │ with azurerm_storage_container.main,
  │ on main.tf line 34, in resource "azurerm_storage_container" "main":
  │ 34: storage_account_name = azurerm_storage_account.main.name
  │
  │ the `storage_account_name` property has been deprecated in favour of `storage_account_id` and will be removed in version 5.0 of the Provider.
