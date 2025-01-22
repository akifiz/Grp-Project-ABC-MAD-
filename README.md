# ABC Group Project (MAD)

## Group Members
<small>Akif Asyrani Bin Mohamad Izani - 2210267</small><br/>
<small>Rusyaida Nasuha Binti Rasnijeery - 2019922</small><br/>
<small>AHMAD KHAIRIL AMIN BIN HISHAMUDDIN - 2212947</small>

## Overview

## Objective

## How To Run
1. clone the repo <br>
2. open the abcmobileapp folder(flutter project folder) in vs code or terminal <br>
3. type these commands once inside the project folder (or use vscode extensions gui to create flutter project, get dependencies, and run)
> ..> flutter create .  
> ..> flutter pub get  
> ..> flutter run

## Database Structure (for now)

Events (collection)
  ├── event id (document)
         ├──> title
         ├──> users id
         ├──> final balance
  ├── event id (document)
         ├──> title
         ├──> users id
         ├──> final balance
  ..

Expenses (collection)
  ├── event id (document)
       ├── expenses (subcollection)
            ├── expense1 (document)
                  ├──> title
                  ├──> amount
                  ├──> paid by
                  ├──> split
                  ├──> dateTime
                  ├──> isSettled            
            ├── expense2 (document)
                  .
            ..
  ├── event id (document)
       ├── expenses (subcollection)
            ├── expense1 (document)
            ├── expense2 (document)
            ..
        ....

Users (collections)
  ├── user id (document)
       ├──> email
       ├──> default name
       ├──> event ids
       ├──> event names
  ├── user id (document)
       ├──> email
       ├──> default name
       ├──> event ids
       ├──> event names
   ..
