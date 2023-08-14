#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'  
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'   

source cities.sh
source names.sh



newbanner
banner(){
clear
echo -e "${RED}"
echo -e "********************************************************************"
echo -e "*                                                                  *"
echo -e "*  ██▄   ▄███▄     ▄▄▄▄▄   ▄█ ▄█▄    ▄█ █ ▄▄   ▄  █ ▄███▄   █▄▄▄▄  *"
echo -e "*  █  █  █▀   ▀   █     ▀▄ ██ █▀ ▀▄  ██ █   █ █   █ █▀   ▀  █  ▄▀  *"
echo -e "*  █   █ ██▄▄   ▄  ▀▀▀▀▄   ██ █   ▀  ██ █▀▀▀  ██▀▀█ ██▄▄    █▀▀▌   *"
echo -e "*  █  █  █▄   ▄▀ ▀▄▄▄▄▀    ▐█ █▄  ▄▀ ▐█ █     █   █ █▄   ▄▀ █  █   *"
echo -e "*  ███▀  ▀███▀              ▐ ▀███▀   ▐  █       █  ▀███▀     █    *"
echo -e "*                                         ▀     ▀            ▀     *"
echo -e "********************************************************************"
echo -e "${RESET}"

}
# Display
display_menu() {

    banner
    echo -e "${RED}--------------------------------------------------------------------"
    echo -e "${RED} Please select an option: ${RESET} ${RED}"
    echo -e "--------------------------------------------------------------------\n" 
    echo -e "1) Cities Wordlist"
    echo -e "2) Names Wordlist"
    echo -e "3) Clean Directories${RESET}"
    echo -e "${BOLD}"
    read -p "Select an option:" choice
}
# add city
city_exists() {

    local check_city="$1"
    for city in "${cities[@]}"; do
        if [[ "${city,,}" == "${check_city,,}" ]]; then
            return 0 
        fi
    done
    return 1  

}

# Addition to the city array
add_city() {
    while true; do
        read -p "Enter the city or name to add: " new_city
        if city_exists "$new_city"; then
            echo -e "${RED}City '$new_city' already exists.${RESET}"
        else
            cities+=("$new_city")
            echo -e "${GREEN}City '$new_city' added to the city list.${RESET}"
            break
        fi
    done
    
}

preparing() {
    banner
    local duration="$1"   
    local interval=1 
    local end_time=$((SECONDS + duration))

    while [ $SECONDS -lt $end_time ]; do
        echo -n "Preparing."
        sleep $interval
        echo -ne "\033[2K\rPreparing.."
        sleep $interval
        echo -ne "\033[2K\rPreparing..."
        sleep $interval
        echo -ne "\033[2K\rPreparing...."
        sleep $interval
        echo -ne "\033[2K\rPreparing....."
        sleep $interval
        echo -ne "\033[2K\r"
        clear
    done
}

clean_directories(){
    if [ -n "$(find "$1" -maxdepth 1 -type f -name "*.txt")" ]; then
        echo "Cleaning $1"
        rm -r "$1"/*.txt
    else 
        echo "$1 is empty!"
    fi
}
# add city
name_exists() {
    local check_name="$1"
    for name in "${names[@]}"; do
        if [[ "${name,,}" == "${check_name,,}" ]]; then
            return 0  
        fi
    done
    return 1  
}

# Addition to the name array 
add_name() {
    while true; do
        read -p "Enter the city or name to add: " new_name
        if name_exists "$new_name"; then
            echo -e "${RED}Name '$new_name' already exists.${RESET}"
        else
            names+=("$new_name")
            echo -e "${GREEN}City '$new_name' added to the names list.${RESET}"
            break
        fi
    done
    
    
}

# Display the menu
display_menu

generate_names(){
banner
for name in "${names[@]}"; do
    echo -e "${BOLD} Generating: ${GREEN} $name ${RESET}"
    # Convert names to uppercase and lowercase
    name_upper=$(echo "$name" | tr '[:lower:]' '[:upper:]')
    name_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')

    pattern_length=$(echo -n "$name%%% " | wc -c)
    special_pattern_length=$(echo -n "$name%%%^" | wc -c)

    # Generate lowercase wordlist
    crunch "$pattern_length" "$pattern_length" -t "$name_lower%%% " -o "temp/$name-lower.txt" &>/dev/null

    # Generate uppercase wordlist
    crunch "$pattern_length" "$pattern_length" -t "$name_upper%%% " -o "temp/$name-upper.txt" &>/dev/null

    # Generate special character wordlist
    crunch "$special_pattern_length" "$special_pattern_length" -t "$name%%%^" -o "temp/$name-special.txt" &>/dev/null

    # Merge lowercase, uppercase, and special character wordlists
    cat "temp/$name-lower.txt" "temp/$name-upper.txt" "temp/$name-special.txt" > "temp/$name.txt"

    mv "temp/$name.txt" names_wordlist/
    # Remove individual wordlist files
    rm "temp/$name-lower.txt" "temp/$name-upper.txt" "temp/$name-special.txt"
done

}

generate_cities(){
    banner
for city in "${cities[@]}"; do

    echo -e "${BOLD} Generating: ${GREEN} $city ${RESET}"
    # Convert names to uppercase and lowercase
    city_upper=$(echo "$city" | tr '[:lower:]' '[:upper:]')
    city_lower=$(echo "$city" | tr '[:upper:]' '[:lower:]')

    pattern_length=$(echo -n "$city%%% " | wc -c)
    special_pattern_length=$(echo -n "$city%%%^" | wc -c)

    # Generate lowercase wordlist
    crunch "$pattern_length" "$pattern_length" -t "$city_lower%%% " -o "temp/$city-lower.txt" &>/dev/null

    # Generate uppercase wordlist
    crunch "$pattern_length" "$pattern_length" -t "$city_upper%%% " -o "temp/$city-upper.txt" &>/dev/null

    # Generate special character wordlist
    crunch "$special_pattern_length" "$special_pattern_length" -t "$city%%%^" -o "temp/$city-special.txt" &>/dev/null

    # Merge lowercase, uppercase, and special character wordlists
    cat "temp/$city-lower.txt" "temp/$city-upper.txt" "temp/$city-special.txt" > "temp/$city.txt"
    
    mv "temp/$city.txt" cities_wordlist/

    # Remove individual wordlist files
    rm "temp/$city-lower.txt" "temp/$city-upper.txt" "temp/$city-special.txt"
done

}

if [[ $choice == 1 ]]; then
    echo -e "${GREEN}You selected Cities Wordlist.${RESET}"
    
    while true; do
        # Display the current entries
        echo -e "Current city list:"
        for city in "${cities[@]}"; do
            echo "$city"
        done
        
        # Add another entry
        read -p "Do you want to add another city? (y/n): " add_another_city
        if [[ $add_another_city == "y" ]]; then
            echo -e "Type cities name without spaces and in lowercase."
            add_city
        else
            clear
            preparing 5
            generate_cities
            break
        fi
    done
    
elif [[ $choice == 2 ]]; then
    echo -e "${GREEN}You selected Names Wordlist.${RESET}"
    
    while true; do
        # Display the current name list:
        echo -e "Current Names list:"
        for name in "${names[@]}"; do
            echo "$name"
        done
        
        # Ask user if they want to add another name
        read -p "Do you want to add another name? (y/n): " add_another_name
        if [[ $add_another_name == "y" ]]; then
            echo -e "Type a name without spaces and in lowercase."
            add_name
        else
            clear
            preparing 5
            generate_names
            break
        fi
    done

elif [[ $choice == 3 ]]; then
    clean_directories "temp/" 
    clean_directories "names_wordlist/"
    clean_directories "cities_wordlist/"
else
    echo -e "${RED}Invalid choice. Please select a valid option.${RESET}"
fi

