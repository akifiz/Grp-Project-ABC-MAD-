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
- int:PK eventId  
- string:event title  
- int:FK userId [...]  
- bool: hasEventName [...] (optional)  
- map:finalBalance [int:idIndexFrom,int:idIndexTo,float:amount...] (length will be C(n,2) at max)  
- int:FK pending expenses [int:expenseId...]

### table EXPENSES  
- int:PK expenseId
- int:FK eventId
- int:FK userId [...]
- int:who paid (index of userId)
- float:total
- map:split [int:id, float:amount...]
- string:expense title
- :dateTime
- bool:isSettled
- string:subDescription

### table USERS
- int:PK userId
- string:default name
- map:event name [eventId, name] (not important)
- image:profilePic
- string: email
- 
