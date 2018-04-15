# add_minutes

add_minutes will take 2 arguments:
* a quoted `12hr timestamp`:
  * For example: `"9:13 AM"`
* `additional minutes`
  * For example: `200`

and return a new timestamp equaling the original timestamp + the additional minutes.
```
# ./add_minutes.rb "9:13 AM" 200
12:33 PM
```

Additionially, you can set `debug` as your third argument to recieve additional logging:
```
./add_minutes.rb "9:13 AM" 200 debug
Current timestamp: 9:13 AM
Added minutes: 200
Total minutes from hours: 540
Total minutes from hours and minutes: 553
Total minutes from hours, minutes and added_minutes: 753
Total hours: 12 and remaining minutes: 33
12:33 PM
```
