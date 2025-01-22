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

Events (collection)  <br>
  _├── event id (document)<br>
  ___├──> title<br>
  ___├──> users id<br>
  ___├──> final balance<br>
  _├── event id (document)<br>
  ___├──> title<br>
  ___├──> users id<br>
  ___├──> final balance<br>
  ..<br>
<br>
Expenses (collection)<br>
  ├── event id (document)<br>
       ├── expenses (subcollection)<br>
            ├── expense1 (document)<br>
                  ├──> title<br>
                  ├──> amount<br>
                  ├──> paid by<br>
                  ├──> split<br>
                  ├──> dateTime<br>
                  ├──> isSettled<br>         
            ├── expense2 (document)<br>
                  .<br>
            ..<br>
  ├── event id (document)<br>
       ├── expenses (subcollection)<br>
            ├── expense1 (document)<br>
            ├── expense2 (document)<br>
            ..<br>
        ....<br>
<br>
Users (collections)<br>
  ├── user id (document)<br>
       ├──> email<br>
       ├──> default name<br>
       ├──> event ids<br>
       ├──> event names<br>
  ├── user id (document)<br>
       ├──> email<br>
       ├──> default name<br>
       ├──> event ids<br>
       ├──> event names<br>
   ..<br>
<br>
