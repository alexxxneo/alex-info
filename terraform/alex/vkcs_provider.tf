terraform {
    required_providers {
        vkcs = {
            source = "vk-cs/vkcs"
            version = "~> 0.5.2" 
        }
    }
}

provider "vkcs" {
    # Your user account.
    username = "info@sambiahotel.com"

    # The password of the account
    password = "ADMsmb456456"

    # The tenant token can be taken from the project Settings tab - > API keys.
    # Project ID will be our token.
    project_id = "ccfda0e45cf84d9e8a14931dfdf0496b"
    
    # Region name
    region = "RegionOne"
    
    auth_url = "https://infra.mail.ru:35357/v3/" 
}