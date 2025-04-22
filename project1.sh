#!/bin/bash

# Files for storing data
STUDENT_FILE="students.txt"
USER_FILE="users.txt"

# Ensure files exist
[[ ! -f $STUDENT_FILE ]] && touch "$STUDENT_FILE"
[[ ! -f $USER_FILE ]] && touch "$USER_FILE"

# Function to display the main menu
display_menu() {
    echo -e "\n=============================="
    echo "Student Management System"
    echo "=============================="
    echo "[1]->. Teacher Login"
    echo "[2]->. Student Login"
    echo "[3]->. Exit"
    echo "=============================="
    read -p "Enter your choice: " choice
    case $choice in
        1) teacher_login ;;
        2) student_login ;;
        3) exit 0 ;;
        *) echo "Invalid choice, please try again." ; display_menu ;;
    esac
}

# Teacher Login
teacher_login() {
    read -p "Enter Teacher Username: " username
    read -sp "Enter Password: " password
    echo ""
    if grep -E "^$username:$password:teacher$" "$USER_FILE"; then
    echo "";
    echo "**********************************";
    echo "Successfully logged in as Teacher!";
    echo "**********************************";
        teacher_menu
    else
        echo "Invalid credentials!"; display_menu
    fi
}

# Student Login
student_login() {
    read -p "Enter Student Roll No: " roll_no
    if grep -q "^$roll_no," "$STUDENT_FILE"; then
        echo "";
    echo "**********************************";
    echo "Successfully logged in as Student!";
    echo "**********************************";
        student_menu "$roll_no"
    else
        echo "Student not found!"; display_menu
    fi
}

# Teacher Menu
teacher_menu() {
    echo -e "\n----------------"
    echo "| Teacher Menu |"
    echo "----------------"
    echo "1. Add Student"
    echo "2. Delete Student"
    echo "3. Assign Marks & Calculate Grades"
    echo "4. List Students"
    echo "5. Logout"
    echo -e "\n------------"
    read -p "Enter your choice: " choice
    case $choice in
        1) add_student ;;
        2) delete_student ;;
        3) assign_marks ;;
        4) list_students ;;
        5) display_menu ;;
        *) echo "Invalid choice, try again." ;
        teacher_menu ;;
    esac
}

# Function to update student records
update_student_record() {
    roll_no="$1"
    new_data="$2"
    sed -i "/^$roll_no,/s/.*/$new_data/" "$STUDENT_FILE"
}

# Add Student
add_student() {
    if [[ $(wc -l < "$STUDENT_FILE") -ge 60 ]]; then
        echo "Cannot add more than 60 students in 1 class."
        teacher_menu
    fi
    read -p "Enter Roll No: " roll_no
    if grep -q "^$roll_no," "$STUDENT_FILE"; then
        echo "Student with this Roll No already exists!"
        teacher_menu
    fi
    read -p "Enter Name: " name
    echo "$roll_no,$name,0,F,0.0" >> "$STUDENT_FILE"
    echo "Student added successfully!"
    teacher_menu
}

# Delete Student
delete_student() {
    read -p "Enter Roll No to Delete: " roll_no
    sed -i "/^$roll_no,/d" "$STUDENT_FILE"
    echo "Student deleted."
    teacher_menu
}

# Assign Marks and Calculate Grades
assign_marks() {
    read -p "Enter Roll No: " roll_no
    if ! grep -q "^$roll_no," "$STUDENT_FILE"; then
        echo "Student not found!"
        teacher_menu
    fi
    read -p "Enter Total Marks (out of 100): " marks
    if ! [[ "$marks" =~ ^[0-9]+$ ]] || (( marks > 100 || marks < 0 )); then
        echo "Invalid marks. Enter a number between 0 and 100."
        teacher_menu
    fi
    grade=$(calculate_grade "$marks")
    cgpa=$(calculate_cgpa "$grade")
    sed -i "/^$roll_no,/s/.*/$roll_no,$(grep "^$roll_no," "$STUDENT_FILE" | cut -d, -f2),$marks,$grade,$cgpa/" "$STUDENT_FILE"
    echo "Marks assigned successfully!"
    teacher_menu
}


# Calculate Grade
calculate_grade() {
    marks=$1
    if (( marks >= 90 )); then echo "A"
    elif (( marks >= 80 )); then echo "B"
    elif (( marks >= 70 )); then echo "C"
    elif (( marks >= 60 )); then echo "D"
    else echo "F"
    fi
}

# Calculate CGPA
calculate_cgpa() {
    case $1 in
        A) echo "4.0" ;;
        B) echo "3.0" ;;
        C) echo "2.0" ;;
        D) echo "1.0" ;;
        F) echo "0.0" ;;
    esac
}

# List Students
list_students() {
    echo -e "\nList of Students:"
    echo "1. Ascending Order (CGPA)"
    echo "2. Descending Order (CGPA)"
    read -p "Choose order: " order
    echo "Roll Name    M   G  CGPA ";
    echo "------------------------------------";
    case $order in
        1) sort -t, -k5 -n "$STUDENT_FILE" | column -t -s ',' ;;
        2) sort -t, -k5 -nr "$STUDENT_FILE" | column -t -s ',' ;;
        *) echo "Invalid choice!" ;;
    esac
    teacher_menu
}

# Student Menu
student_menu() {
    roll_no=$1
    echo -e "\nStudent Menu"
    echo "1. View Grades"
    echo "2. View CGPA"
    echo "3. Logout"
    read -p "Enter your choice: " choice
    case $choice in
        1) view_grades "$roll_no" ;;
        2) view_cgpa "$roll_no" ;;
        3) display_menu ;;
        *) echo "Invalid choice, try again." ; 
        student_menu "$roll_no" ;;
    esac
}

# View Grades
view_grades() {
    grep "^$1," "$STUDENT_FILE" | awk -F, '{print "Grade: " $4}'
    student_menu "$1"
}

# View CGPA
view_cgpa() {
    grep "^$1," "$STUDENT_FILE" | awk -F, '{print "CGPA: " $5}'
    student_menu "$1"
}

# Start the system
display_menu

