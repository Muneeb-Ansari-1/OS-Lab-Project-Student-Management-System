# Operating_System_Project_Flex_System_BashScriptCode
Mini Flex – Bash-Based Student Management System

Developed by: Muneeb Akbar
Roll Number: 23F-0608
Course: Operating Systems Lab
Section: BSCS-4A
Department: Computer Science

Project Overview
Mini Flex is a simple and interactive student management system developed using Bash scripting. It provides a command-line interface that allows role-based access for both teachers and students. The project was created to demonstrate the practical application of shell scripting concepts such as file handling, input processing, and basic data operations in a Linux or Unix environment.

Key Features

Role-Based Login System

Separate login for teachers and students

Credentials are securely managed through a user file

Teacher Functionalities

Add new student records with a maximum limit of sixty students

Delete existing student records

Assign marks to students and automatically calculate grades and CGPA

View a list of students sorted in ascending or descending order based on CGPA

Student Functionalities

View assigned grades

View calculated CGPA

Technologies Used

Bash Shell Scripting

Linux or Unix-based environment

Shell utilities such as grep, sed, awk, and sort

File Structure

students.txt: Stores student data in the format RollNo,Name,Marks,Grade,CGPA

users.txt: Stores login credentials in the format Username:Password:Role

Learning Outcomes
Through this project, I gained practical experience in the following areas:

Shell scripting and command-line programming

File-based data storage and retrieval

Creating role-based menu-driven interfaces

Using Unix utilities to manage and process data

How to Use

Step 1: Clone the repository
Use the Git command to clone the project repository to your local system

Step 2: Make the script executable
Use the chmod command to make the script executable

Step 3: Run the program
Execute the script in the terminal to launch the student management system

Sample Teacher Credentials
The following sample login details can be added to the users.txt file for testing:
Username: teacher1
Password: pass123
Role: teacher

License
This project was developed for academic and educational purposes
