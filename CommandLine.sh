#!/usr/bin/env bash
# Specify the path to your file


file_path="merged_courses.csv"

# Set IFS to comma for splitting
IFS=','
declare -A countries_d
declare -A cities_d
declare -A colleges_d
total_number=0
number_eng=0
# Use a while loop to read the file line by line and split each line using IFS
while IFS= read -r line; do
    ((total_number++))
    # Read the line into an array
    read -ra elements <<< "$line"
    
    # Print the elements, or process them as needed
    degree=${elements[1]}
    
    if [[ $degree == *"Engineering"* || $degree == *"engineering"*  ]]; then
    	
    	((number_eng++))
    	
    fi
    country="${elements[@]:(-3):1}"
    city="${elements[@]:(-4):1}"
    mod="${elements[@]:(-5):1}"
    lowercase_string=$(echo "$mod" | tr '[:upper:]' '[:lower:]')
    college="${elements[2]}"
    college=$(echo "$college" | sed 's/\"//g')
    if [[ "$lowercase_string" =~ "part time" || "$lowercase_string" =~ "part-time" ]]; then
    	
    	if [[ $colleges_d["$college"] ]]; then
		# If the key exists, increment the count
			((colleges_d["$college"]++))
	else
			# If the key doesn't exist, initialize the count to 1
			colleges_d[$college]=1
	fi
        
    fi
    
    
    if [[ "$degree" == *"MS"* && "$degree" != *"MSc"* ]]; then
	    if [ -n "$city" ]; then
	    	    if [[ $cities_d["$city"] ]]; then
		# If the key exists, increment the count
			((cities_d["$city"]++))
		    else
			# If the key doesn't exist, initialize the count to 1
			cities_d["$city"]=1
		    fi
	    fi
	    if [ -n "$country" ]; then
	    
		    if [[ $countries_d["$country"] ]]; then
			# If the key exists, increment the count
			((countries_d["$country"]++))
		    else
			# If the key doesn't exist, initialize the count to 1
			countries_d["$country"]=1
		    fi
	    fi
    fi
done < "$file_path"
max_key=""
max_value=-1
for key in "${!cities_d[@]}"; do
    value=${cities_d[$key]}
    
    # Compare values and update max_key if necessary
    if ((value > max_value)); then
        max_key=$key
        max_value=$value
    fi
done


# Print the key with the maximum value
echo "City with most master degrees $max_key"
max_key=""
max_value=-1
for key in "${!countries_d[@]}"; do
    value=${countries_d[$key]}
    
    # Compare values and update max_key if necessary
    if ((value > max_value)); then
        max_key=$key
        max_value=$value
    fi
done
echo "Country with most master degrees $max_key"
echo "Number of colleges with part time education:${#colleges_d[@]}"
((total_number--))
result=$(awk -v var1=$number_eng -v var2=$total_number 'BEGIN { print  ( var1 / var2 *100 ) }')

echo "Number of engineering courses:$number_eng Total Number Courses:$total_number"
echo "Percentage of courses in Engineering $result"




