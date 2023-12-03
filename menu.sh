#!/bin/bash

domain=$(sed -n '1p' /root/iptv-panel/domain.txt)
API_BASE_URL="https://${domain}"
admin_password=$(grep -o 'admin_pass = "[^"]*' "/root/iptv-panel/data.txt" | grep -o '[^"]*$' | sed -n '1p')

function register_reseller() {
    read -p "Enter reseller username: " reseller_username
    read -p "Enter reseller balance: " reseller_balance

    response=$(curl -s --request POST \
        --url "$API_BASE_URL/api/register_reseller" \
        --header 'Content-Type: application/json' \
        --data '{
            "password": "'"$admin_password"'",
            "balance": '"$reseller_balance"',
            "username": "'"$reseller_username"'"
        }')

    echo "$response" | jq -C .
}

function add_user() {
    reseller_username=$(grep -o 'ADMIN_RES_USER = "[^"]*' "/root/iptv-panel/data.txt" | grep -o '[^"]*$' | sed -n '1p')
    reseller_password=$(grep -o 'ADMIN_RES_PASS = "[^"]*' "/root/iptv-panel/data.txt" | grep -o '[^"]*$' | sed -n '1p')
    read -p "Enter username: " username
    read -p "Enter package: " package

    response=$(curl -s --request POST \
        --url "$API_BASE_URL/api/add_user" \
        --header 'Content-Type: application/json' \
        --data '{
            "username": "'"$username"'",
            "reseller_username": "'"$reseller_username"'",
            "reseller_password": "'"$reseller_password"'",
            "package": "'"$package"'",
            "admin_password": "'"$admin_password"'"
        }')

    echo "$response" | jq -C .
}

function renew_user() {
    reseller_username=$(grep -o 'ADMIN_RES_USER = "[^"]*' "/root/iptv-panel/data.txt" | grep -o '[^"]*$' | sed -n '1p')
    reseller_password=$(grep -o 'ADMIN_RES_PASS = "[^"]*' "/root/iptv-panel/data.txt" | grep -o '[^"]*$' | sed -n '1p')
    read -p "Enter user UUID to renew: " user_uuid
    read -p "Enter package: " package

    response=$(curl -s --request POST \
        --url "$API_BASE_URL/api/renew_user" \
        --header 'Content-Type: application/json' \
        --data '{
            "reseller_username": "'"$reseller_username"'",
            "reseller_password": "'"$reseller_password"'",
            "uuid": "'"$user_uuid"'",
            "package": "'"$package"'"
        }')

    echo "$response" | jq -C .
}

function add_reseller_balance() {
    read -p "Enter reseller username to add balance: " username
    read -p "Enter amount to add: " amount

    response=$(curl -s --request POST \
        --url "$API_BASE_URL/api/add_reseller_balance" \
        --header 'Content-Type: application/json' \
        --data '{
            "username": "'"$username"'",
            "amount": '"$amount"',
            "password": "'"$admin_password"'"
        }')

    echo "$response" | jq -C .
}

function delete_user() {
    read -p "Enter username: " username
    read -p "Enter user UUID: " user_uuid

    response=$(curl -s --request POST \
        --url "$API_BASE_URL/api/delete_user" \
        --header 'Content-Type: application/json' \
        --data '{
            "username": "'"$username"'",
            "uuid": "'"$user_uuid"'",
            "admin_password": "'"$admin_password"'"
        }')

    echo "$response" | jq -C .
}

function get_user_data() {
    read -p "Enter user UUID: " user_uuid

    response=$(curl -s "$API_BASE_URL/api/get_user_data?user_uuid=$user_uuid&password_input=$admin_password")

    echo "$response" | jq -C .
}

function get_users_by_reseller() {
    read -p "Enter reseller username: " reseller_username

    response=$(curl -s "$API_BASE_URL/api/get_users_by_reseller?reseller_username=$reseller_username&password_input=$admin_password")

    echo "$response" | jq -C .
}

function add_user_custom() {
    reseller_username=$(grep -o 'ADMIN_RES_USER = "[^"]*' "/root/iptv-panel/data.txt" | grep -o '[^"]*$' | sed -n '1p')
    reseller_password=$(grep -o 'ADMIN_RES_PASS = "[^"]*' "/root/iptv-panel/data.txt" | grep -o '[^"]*$' | sed -n '1p')
    read -p "Enter username: " username
    read -p "Enter number of days: " days

    response=$(curl -s --request POST \
        --url "$API_BASE_URL/api/add_user_custom" \
        --header 'Content-Type: application/json' \
        --data '{
            "admin_password": "'"$admin_password"'",
            "reseller_username": "'"$reseller_username"'",
            "reseller_password": "'"$reseller_password"'",
            "username": "'"$username"'",
            "days": '"$days"'
        }')

    echo "$response" | jq -C .
}

function get_all_resellers() {
    response=$(curl -s "$API_BASE_URL/api/get_all_resellers?password_input=$admin_password")

    echo "$response" | jq -C .
}

function add_secure_url() {
    read -p "Enter short ID: " short_id
    read -p "Enter URL: " url

    response=$(curl -s --request POST \
        --url "$API_BASE_URL/secure" \
        --header 'Content-Type: application/json' \
        --data '{
            "short_id": "'"$short_id"'",
            "url": "'"$url"'"
        }')

    echo "$response" | jq -C .
}

function edit_secure_url() {
    read -p "Enter short ID to edit: " short_id
    read -p "Enter new URL: " new_url

    response=$(curl -s --request POST \
        --url "$API_BASE_URL/secure_edit" \
        --header 'Content-Type: application/json' \
        --data '{
            "short_id": "'"$short_id"'",
            "url": "'"$new_url"'"
        }')

    echo "$response" | jq -C .
}

function check_multilogin() {
    read -p "Enter user UUID: " user_uuid

    response=$(curl -s "$API_BASE_URL/api/check_multilogin?user_uuid=$user_uuid&password_input=$admin_password")

    echo "$response" | jq -C .
}

function check_all_multilogin() {

    response=$(curl -s "$API_BASE_URL/api/check_all_multilogin?password_input=$admin_password")

    echo "$response" | jq -C .
}

function restart_api() {
    run.sh
}

while true; do
    clear
    echo "========= API Interaction Script ========="
    echo "1. Register Reseller"
    echo "2. Add User"
    echo "3. Delete User"
    echo "4. Get User Data"
    echo "5. Get Users by Reseller"
    echo "6. Check User Multilogin"
    echo "7. Check All Multilogin"
    echo "8. Renew User"
    echo "9. Add Balance"
    echo "10. Add User Custom"
    echo "11. Renew User Custom"
    echo "12. Get All Resellers"
    echo "13. Add Secure URL"
    echo "14. Edit Secure URL"
    echo "15. Restart Services"
    echo "16. Manual Backup"
    echo "17. Exit"
    echo "=========================================="
    read -p "Select an option (1-10): " choice

    case $choice in
    1)
        register_reseller
        ;;
    2)
        add_user
        ;;
    3)
        delete_user
        ;;
    4)
        get_user_data
        ;;
    5)
        get_users_by_reseller
        ;;
    6)
        check_multilogin
        ;;
    7)
        check_all_multilogin
        ;;
    8)
        renew_user
        ;;
    9)
        add_reseller_balance
        ;;
    10)
        add_user_custom
        ;;
    11)
        renew_user_custom
        ;;
    12)
        get_all_resellers
        ;;
    13)
        add_secure_url
        ;;
    14)
        edit_secure_url
        ;;
    15)
        restart_api
        ;;
    16)
        ott_sam.sh -b
        ;;
    17)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please enter a number between 1 and 10."
        ;;
    esac

    read -p "Press enter to continue..."
done
