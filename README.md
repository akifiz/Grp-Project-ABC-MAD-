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

### table LIST_OF_EVENTS  
- PK eventId  
- event title  
- FK userId [...]  
- bool: hasEventName [...] (optional)  
- finalBalance [idIndexFrom, idIndexTo, amount...] (length will be C(n,2) at max)  
- FK pending expenses [expenseId...]

### table EXPENSES  
- PK expenseId
- FK eventId
- FK userId [...]
- who paid (index of userId)
- total
- split [id, amount...]
- expense title
- dateTime
- isSettled
- subDescription (optional)

### table USERS
- PK userId
- default name
- event name [eventId, name] (optional)
- profilePic
